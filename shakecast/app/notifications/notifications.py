from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication
from jinja2 import Template, Environment
import json
import os
import shutil
import time

from ..products.geojson import generate_impact_geojson
from .builder import NotificationBuilder
from .mailer import Mailer
from ..orm import dbconnect, ShakeMap, Notification
from .templates import TemplateManager
from ..util import sc_dir, SC, get_template_dir, split_string_on_spaces

jinja_env = Environment(extensions=['jinja2.ext.do'])


def get_image(image_path):
    default_image = os.path.join(sc_dir(),'view','assets', 'sc_logo.jpg')
    try:
        image = open(image_path, 'rb')
    except Exception:
        image = open(default_image, 'rb')

    return image


def new_event_notification(notifications=None,
                           scenario=False):
    """
    Build and send HTML email for a new event or scenario
    
    Args:
        event (ShakeMap): which ShakeMap the Notification is attached to
        group (Group): The Group that this Notification is being send to
        notification (Notification): The Notification that will be sent
        scenario (bool): True if the user is running a scenario
        
    Returns:
        None
    """
    events = [n.event for n in notifications]
    group = notifications[0].group
    notification = notifications[0]
    
    print('Creating new notification for events:\n{}'
            .format(events))

    # aggregate multiple events
    for n in notifications[1:]:
        n.status = 'aggregated'

    print('Generating HTML...')
    # create HTML for the event email
    not_builder = NotificationBuilder()
    message = not_builder.build_new_event_html(events=events, notification=notification, name=group.template)
    print('Done.')

    notification.status = 'Message built'
    notification.generated_timestamp = time.time()

    #initiate message
    #NRS - adde 'related' to try and stop images from showing up as attachments. 
    msg = MIMEMultipart('related')
    
    # attach html
    message_type = 'html' if '<html>' in message else 'plain'
    mime_message = MIMEText(message, message_type)
    msg.attach(mime_message)

    # get and attach map
    for count,event in enumerate(events):
        # get and attach shakemap
        if len(event.shakemaps) > 0:
            shakemap = event.shakemaps[-1]
            msg_shakemap = MIMEImage(shakemap.get_map(), _subtype='jpeg')
            msg_shakemap.add_header('Content-ID', 'shakemap{0}'.format(shakemap.shakecast_id))
            msg_shakemap.add_header('Content-Disposition', 'attachment', filename='intensity_{0}.jpg'.format(shakemap.shakecast_id))
            msg.attach(msg_shakemap)        
        else:
            map_image = get_image(os.path.join(event.directory_name,
                                        'image.png'))
            msg_gmap = MIMEImage(map_image.read(), _subtype='png')
            map_image.close()
            
            msg_gmap.add_header('Content-ID', 'gmap{0}_{1}'.format(count, notification.shakecast_id))
            # NRS remove - msg_gmap.add_header('Content-Disposition', 'attachment', filename='gmap_{0}.png'.format(notification.shakecast_id))
            msg.attach(msg_gmap)

    # find the ShakeCast logo
    temp_manager = TemplateManager()
    configs = temp_manager.get_configs('new_event', 
                                        name=notification.group.template)
    logo_str = os.path.join(sc_dir(),'view','assets',configs['logo'])
    
    # open logo and attach it to the message
    logo_file = get_image(logo_str)
    msg_image = MIMEImage(logo_file.read(), _subtype='jpeg')
    logo_file.close()
    msg_image.add_header('Content-ID', 'sc_logo_{0}'.format(notification.shakecast_id))
    #msg_image.add_header('Content-Disposition', 'attachment', filename='sc_logo.jpg')
    msg.attach(msg_image)
    
    # attach a header if it's needed
    if configs.get('header'):
        header_str = os.path.join(sc_dir(),'view','assets',configs['header'])
        if os.path.isfile(header_str):
            header_file = get_image(header_str)
            msg_image = MIMEImage(header_file.read(), _subtype='jpeg')
            header_file.close()
            msg_image.add_header('Content-ID', 'header')
            msg_image.add_header('Content-Disposition', 'attachment', filename='header.jpg')
            msg.attach(msg_image)

    mailer = Mailer()
    me = mailer.me

    # get notification format
    not_format = group.get_notification_format(notification, scenario)

    # get notification destination based on notification format
    you = [user.__dict__[not_format] for user in group.users
            if user.__dict__.get(not_format, False)]

    # Remove scenario from the group name
    group_str = (group.name).lower()
    if group_str.find('_scenario') > -1:
        group_str = group_str.replace('_scenario','')
        
    # capitalize Providence, all caps for other groups    
    if group_str.find('providence') > -1 :
        groupFormat_str = group_str.capitalize()
    else:
        groupFormat_str = group_str.upper()
        
    if len(you) > 0:
        if len(events) == 1:
            #subject = event.title

            subject = '{0} EQ - {1}'.format(groupFormat_str, event.title)
        else:
            mags = []
            for e in events:
                if e.event_id == 'heartbeat':
                    mags += ['None']
                else:
                    mags += [e.magnitude]

            subject = '{0} - {1} New Events - Magnitudes: {2}'.format(groupFormat_str,len(events),
                                                                        str(mags).replace("'", ''))

        if scenario is True:
            subject = 'SCENARIO: ' + subject

        msg['Subject'] = subject
        msg['To'] = ', '.join(you)
        msg['From'] = me
        
        print('Sending notification...')
        mailer.send(msg=msg, you=you)
        print('Done.')
        
        notification.status = 'sent'
        notification.sent_timestamp = time.time()

    else:
        print('Notification not sent due to lack of users')
        notification.status = 'not sent - no users'

@dbconnect
def inspection_notification(notification=None,
                            scenario=False,
                            session=None):
    '''
    Create local products and send inspection notification
    
    Args:
        notification (Notification): The Notification that will be sent

    Returns:
        None
    '''
    shakemap = notification.shakemap
    group = notification.group

    print('Creating inspeciton notification: \nShakemap: {}-{}\nGroup:{}'
            .format(shakemap.shakemap_id, shakemap.shakemap_version, group.name))
    error = ''

    has_alert_level, new_inspection, update = check_notification_for_group(
        group,
        notification,
        session=session,
        scenario=shakemap.type == 'scenario'
    )

    if has_alert_level and new_inspection:
        try:
            #initiate message
            msg = MIMEMultipart('related')

            # build the notification
            print('Generating html...')
            not_builder = NotificationBuilder()
            message = not_builder.build_insp_html(shakemap, notification=notification, name=group.template)
            print('Done.')
            # attach html
            message_type = 'html' if '<html>' in message else 'plain'
            mime_message = MIMEText(message, message_type)
            msg.attach(mime_message)

            # get and attach shakemap
            msg_shakemap = MIMEImage(shakemap.get_map(), _subtype='jpeg')
            msg_shakemap.add_header('Content-ID', 'shakemap{0}'.format(shakemap.shakecast_id))
            msg_shakemap.add_header('Content-Disposition', 'attachment', filename='intensity_{0}.jpg'.format(shakemap.shakecast_id))
            msg.attach(msg_shakemap)
            
            # find the ShakeCast logo
            temp_manager = TemplateManager()
            configs = temp_manager.get_configs('inspection',
                                        name=notification.group.template)
            logo_str = os.path.join(sc_dir(),'view','assets',configs['logo'])
            
            # open logo and attach it to the message
            logo_file = open(logo_str, 'rb')
            msg_image = MIMEImage(logo_file.read(), _subtype='jpeg')
            logo_file.close()
            msg_image.add_header('Content-ID', 'sc_logo_{0}'.format(shakemap.shakecast_id))
            # NRS remove - msg_image.add_header('Content-Disposition', 'attachment', filename='sc_logo.jpg')
            msg.attach(msg_image)
            
            # attach a header if it's needed
            if configs.get('header'):
                header_str = os.path.join(sc_dir(),'view','assets',configs['header'])
                if os.path.isfile(header_str):
                    header_file = get_image(header_str)
                    msg_image = MIMEImage(header_file.read(), _subtype='jpeg')
                    header_file.close()
                    msg_image.add_header('Content-ID', 'header')
                    msg_image.add_header('Content-Disposition', 'attachment', filename='header.jpg')
                    msg.attach(msg_image)
            
            # check for and attach local products
            for product in shakemap.local_products:
                if product.error or product.group != group:
                    continue

                try:
                    content = product.read()
                    # NRS addition, try to format the name of the pdf attached. 
                    myTime = time.strftime("%y%m%d",time.localtime())
                     
                    if ((product.name).lower()).find('providence') > -1 :
                        myProductName = (((product.name).lower()).replace('_impact.pdf','')).capitalize()
                    else:
                        myProductName = (product.name).replace('_impact.pdf','')
                    myShakemapID = '{0}-{1}'.format(shakemap.shakemap_id,shakemap.shakemap_version)
                    attach_product = MIMEApplication(content, _subtype=product.product_type.subtype)
                    attach_product.add_header('Content-Disposition', 'attachment', filename='{0}rpt_{1}_Post-EQ_Inspection_List_{2}.pdf'.format(myTime,myProductName,myShakemapID))
                    msg.attach(attach_product)
                    print('Attached: {}'.format(product.product_type.name))
                except Exception as e:
                    print('Unable to attach: {}'.format(product.product_type.name))
                    product.error = 'Unable to attach to email'

            mailer = Mailer()
            me = mailer.me

            # get notification format
            not_format = group.get_notification_format(notification, scenario)

            # get notification destination based on notification format
            you = [user.__dict__[not_format] for user in group.users
                    if user.__dict__.get(not_format, False)]
            
            if len(you) > 0:
                # NRS modify subject content
                event_str = shakemap.event.title
                #event_str = event_str.replace('\'','')
                #event_str = event_str.replace('b','')
                group_str = (group.name).lower()
                
                # Remove scenario from the group name
                if group_str.find('_scenario') > -1:
                    group_str = group_str.replace('_scenario','')
                
                if group_str.find('providence') > -1 :
                    subject = '{0} {1} {2}'.format(group_str.capitalize(),' - Post-EQ Potential Inspection List - ', event_str)
                else:
                    subject = '{0} {1} {2} {3}'.format('CONFIDENTIAL Inspection - Group:', group_str.upper(),' ', event_str)
                #subject = f'Inspection -  {shakemap.event.title}'

                if scenario is True:
                    subject = 'SCENARIO: ' + subject
                elif update is True:
                    subject = 'UPDATE: ' + subject
                    

                msg['Subject'] = subject
                msg['To'] = ', '.join(you)
                msg['From'] = me
                
                mailer.send(msg=msg, you=you)
                
                notification.status = 'sent'
                notification.sent_timestamp = time.time()
                print('Notification sent.')
            else:
                print('Notification not sent: no users.')
                notification.status = 'not sent - no users'
        except Exception as e:
            error = str(e)
            notification.status = 'send failed'
            notification.error = error
            print('Notification failed: {}'.format(str(e)))
            
    elif new_inspection:
        notification.status = 'not sent: low inspection priority'
        print('Notification not sent due to low inspection priority')
    else:
        notification.status = 'not sent: update without impact changes'
        print('Notification not sent due to lack of changes in map update')

    return {'status': notification.status,
            'error': error}

@dbconnect
def check_notification_for_group(group, notification, session=None, scenario=False):
    shakemap = notification.shakemap

    # Check that the inspection status merits a sent notification
    alert_level = shakemap.get_alert_level(group)

    #NRS - do not send an inspection if alert_level is gray or None. A group is determined to be affected by an event if it is present within shakemap boundaries. The original code would send a new inspection notification regardless of alert_level. 
    if (alert_level is None) or (alert_level == 'gray'):
        new_inspection = False
        update = False
    else:
        new_inspection = True
        update = False
    # End NRS modificaiton 
    
    # check if inspection list has changed
    if shakemap.old_maps():
        update = True
        new_inspection = False

        # get the most recent map version
        previous_map = (session.query(ShakeMap)
            .filter(ShakeMap.shakemap_id == shakemap.shakemap_id)
            .filter(ShakeMap.shakemap_version < shakemap.shakemap_version)
            .order_by(ShakeMap.shakemap_version.desc())
        ).first()

        prev_alert_level = previous_map.get_alert_level(group)

        # ignore changes if they don't merit inspection (grey and None)
        # Start NRS - add third condition if previous alert is third condition if previous alert is none and new is gray then do not send a notification.
        if (((prev_alert_level is None) and 
                (alert_level is None)) or
                ((prev_alert_level == 'gray') and
                (alert_level == 'gray')) or 
                ((prev_alert_level is None) and
                (alert_level == 'gray'))):
            new_inspection = False
        # End NRS
        
        # if overall inspection level changes, send notification
        elif prev_alert_level != alert_level:
            new_inspection = True

        # trigger new inspection if the content of the facility_shaking
        # list changes
        elif len(previous_map.facility_shaking) != len(shakemap.facility_shaking):
            new_inspection = True
        else:
            for idx in range(len(shakemap.facility_shaking)):
                if (shakemap.facility_shaking[idx].facility.facility_id !=
                        previous_map.facility_shaking[idx].facility.facility_id):
                    new_inspection = True
                    break
    
    return group.has_alert_level(alert_level, scenario), new_inspection, update


@dbconnect
def inspection_notification_service(session=None):
    # grab new notifications, and any that might have failed to send
    notification = (session.query(Notification)
                        .filter(Notification.notification_type == 'DAMAGE')
                        .filter(Notification.status == 'ready')
                        .first())

    notification = send_inspection_notification(notification, session)
    return notification

@dbconnect
def send_inspection_notification(notification, session=None):
    if not notification:
        return None

    notification.status = 'generating-notification'
    session.commit()

    print('Generating inspection notification {}'.format(notification))

    shakemap = notification.shakemap
    try:
        inspection_notification(notification=notification,
                                scenario='scenario' == shakemap.type,
                                session=session)
    except Exception as e:
        notification.status = 'error'
        notification.error = str(e)
        session.commit()

        print('Error generating inspection notification. \n{}'.format(str(e)))
        raise

    print(str(notification))
    return notification
