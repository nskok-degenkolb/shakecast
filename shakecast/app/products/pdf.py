from fpdf import FPDF, HTMLMixin
import os
import time

from ..impact import get_event_impact
from ..notifications.builder import NotificationBuilder
from ..notifications.templates import TemplateManager
from ..urlopener import URLOpener
from ..util import Clock, SC


class Pdf(FPDF):
    def __init__(self):
        super(Pdf, self).__init__()

        self.set_font('Arial', '', 10)
    #NRS add header
    def header(self):
        # Arial italic 8
        self.set_font('Arial', 'BI', 10)
        # Page number
        self.cell(0, 10, 'Confidential Information', 0, 1, 'C')
        
        
    def footer(self):
        # Position at 1.5 cm from bottom
        self.set_y(-15)
        # Arial italic 8
        self.set_font('Arial', 'BI', 10)
        # Page number
        self.cell(0, 10, 'Page ' + str(self.page_no()) + '/{nb}', 0, 0, 'C')


def generate_impact_pdf(group, shakemap, save=False, pdf_name='', template_name=''):
    pdf = Pdf()
    pdf.set_margins(10,5,10)
    pdf.add_page()

    tm = TemplateManager()
    configs = tm.get_configs('pdf', template_name or 'default.json')
    add_header_to_pdf(pdf, shakemap, configs['header'])
    
    pdf.ln(pdf.font_size * 2)
    #NRS update summary to consider only facilties within the group
    add_summary_to_pdf(pdf, shakemap, group)

    try:
        add_impact_image_to_pdf(pdf, shakemap)
    except Exception:
        # can't add impact pdf
        pass

    pdf.add_page()
    add_shakemap_details_to_pdf(pdf, shakemap)

    add_shakemap_to_pdf(pdf, shakemap)

    pdf.add_page()
    facility_shaking = sorted(
        shakemap.facility_shaking, key=lambda x: x.weight, reverse=True)
    facility_shaking = [x for x in facility_shaking if group in x.facility.groups]

    try:
        add_pdf_table(pdf, configs['table']['table_head'], facility_shaking)
    except:
        pass
        
    # NRS - Add disclosure
    try:
        font = pdf.font_family
        style = pdf.font_style
        size = pdf.font_size_pt
        
        pdf.add_page()
        pdf.set_font(font, 'b', 18)
        pdf.multi_cell(0, pdf.font_size, 'Confidentiality and Disclaimer Notice')
        pdf.set_font(font, '', 10)
        pdf.ln(pdf.font_size)
        
        myDisclaimer = 'This automated report is confidential and intended soley for Providence. If received in error, please notify the sender and the report from your system. The results provided herein are computer-generated building damage estimates and may not accurately represent the actual conditions or extent of damage. They are not a subsitute for a structural evaluation by a professional engineer. Degenkolb Engineers disclaims any liability for errors or omissions and makes no warranties, express or implied, regarding accuracy or completeness. Unauthorized use, disclosure, or copying is prohibited. '
        pdf.multi_cell(0, pdf.font_size, myDisclaimer)
        pdf.set_font(font, style, size)
        
    except:
        pass
        
    pdf.alias_nb_pages()
    pdf_string = pdf.output('', 'S')

    if save is True:
        pdf_name = pdf_name or 'impact.pdf'
        # NRS revise filename to include date. 
        #myTimeFmt = time.strftime("%y%m%d-%H%M",time.localtime())
        #pdf_name ='{0}rpt_{1}_impact.pdf'.format(myTimeFmt,group.name)
        save_pdf(pdf_string, pdf_name, shakemap.local_products_dir)
    return pdf_string


def add_header_to_pdf(pdf, shakemap, configs):
    font = pdf.font_family
    style = pdf.font_style
    size = pdf.font_size_pt

    title = configs.get('title', 'ShakeCast Report')

    pdf.set_font(font, 'b', 24)
    pdf.multi_cell(pdf.w, pdf.font_size + 5, title)

    pdf.set_font(font, 'b', 14)
    pdf.multi_cell(pdf.w, pdf.font_size, shakemap.event.title)

    #add introduction NRS
    pdf.ln(10)
    myIntroduction = configs.get('introduction', 'Introduction')
    primary_contact = configs.get('pContact', 'Introduction')
    secondary_contact = configs.get('sContact', 'Introduction')
    
    pdf.set_font(font, '', 12)
    pdf.multi_cell(0, 14, myIntroduction)
    pdf.ln(10)
    pdf.multi_cell(0, 14, primary_contact)
    pdf.multi_cell(0, 14, secondary_contact)
    pdf.ln(10)
    
    pdf.set_font(font, style, size)

def add_impact_image_to_pdf(pdf, shakemap):
    width = pdf.w * .75
    top = pdf.get_y() + 10
    left = (pdf.w - width) / 2

    url_opener = URLOpener()
    sc = SC()

    impact_image = os.path.join(shakemap.local_products_dir, 'geojson_capture.html')
    image = url_opener.open(sc.dict.get('image_server', '').format(impact_image, 'map_pane'))
    image_location = shakemap.save_local_product('impact.png', image, write_method='wb')

    pdf.image(image_location, x=left, y=top, w=width)


def add_shakemap_details_to_pdf(pdf, shakemap):
    font = pdf.font_family
    style = pdf.font_style
    size = pdf.font_size_pt

    details_height = pdf.font_size + 2
    pdf.set_font(font, 'b', 14)
    pdf.multi_cell(pdf.w, pdf.font_size, 'Event Details')

    pdf.set_font(font, '', 10)
    pdf.multi_cell(pdf.w, details_height, 'Epicenter Location: {}, {}'.format(
        shakemap.event.lat, shakemap.event.lon))
    pdf.multi_cell(pdf.w, details_height,
                   'Event ID: {}'.format(shakemap.shakemap_id))
    pdf.multi_cell(pdf.w, details_height,
                   'Version: {}'.format(shakemap.shakemap_version))

    clock = Clock()
    event_time = clock.from_time(shakemap.event.time)
    event_time_str = event_time.strftime('%H:%M %d-%b-%Y')
    pdf.multi_cell(pdf.w, details_height,
                   'Event Time: {}'.format(event_time_str))

    datetime = clock.from_time(time.time())
    date_string = datetime.strftime('%H:%M %d-%b-%Y')
    pdf.multi_cell(pdf.w, details_height,
                   'Report Generated: {}'.format(date_string))
    pdf.set_font(font, style, size)
    pdf.ln(10)
    myDescription = 'This is a ShakeMap generated by USGS showing the estimated shaking intensities caused by the earthquake. The gradation indicates the estimated Modified Mercalli Intensity which corresponds to physical responses caused by the earthquake such as people awakening, movement of furniture, building damage, or building collapse. Lower numbers on the intensity scale relate to the response of people to the earthquake, and higher numbers correspond to observed structural damage. The intensity scale below is adapted from this USGS webpage.'
    pdf.multi_cell(0, details_height, myDescription)
    pdf.set_font(font, style, size)

def add_summary_to_pdf(pdf, shakemap, group):
    font = pdf.font_family
    style = pdf.font_style
    size = pdf.font_size_pt
    
    #NRS only consider facilities in the group being reported.
    facility_shaking = sorted(
        shakemap.facility_shaking, key=lambda x: x.weight, reverse=True)
    facility_shaking = [x for x in facility_shaking if group in x.facility.groups]
    
    impact = get_event_impact(facility_shaking)

    details_height = pdf.font_size + 2
    font = pdf.font_family
    pdf.set_font(font, 'b', 14)
    pdf.multi_cell(pdf.w, details_height, 'Impact Summary')
    pdf.set_font(font, '', 12)
    pdf.multi_cell(pdf.w, details_height,
                   'Total Facilities Evaluated: {}'.format(impact['all']))
    pdf.multi_cell(pdf.w, details_height, 'High: {}'.format(impact['red']))
    pdf.multi_cell(pdf.w, details_height,
                   'Medium-High: {}'.format(impact['orange']))
    pdf.multi_cell(pdf.w, details_height,
                   'Medium: {}'.format(impact['yellow']))
    pdf.multi_cell(pdf.w, details_height, 'Low: {}'.format(impact['green']))
    pdf.multi_cell(pdf.w, details_height, 'None: {}'.format(impact['gray']))

   


def add_pdf_table(pdf, headers, data): 
    font = pdf.font_family
    style = pdf.font_style
    size = pdf.font_size_pt
    
    pdf.set_font(font, 'b', 18)
    pdf.multi_cell(0, 18, 'Inspection List')
    pdf.set_font(font, '', 10)
    pdf.ln(pdf.font_size)

    text1 = 'The following list ranks the ministry inspection priorities based on the estimated shaking at the building site and the structure type of the building. The table contains the following metrics.'
    text2 = 'Inspection Priority – Likelihood of damage computed by HAZUS analysis considering the ground shaking metrics at the building site.'
    text3 = 'MMI – Modified Mercalli Intensity discussed on the previous page. This metric is considered by HAZUS in determining the inspection priority when structural system information is not well defined. '
    text4 = 'Peak Ground Velocity (PGV), cm/s – maximum velocity of the ground at the building site'
    text5 = 'PSA03, \% g  – Spectral acceleration response at 0.3s which is of interest to Degenkolb Engineers'
    text6 = 'Metric – Value that HAZUS is considering in when estimating inspection priority.  MMI is considered where the structural system information is not well defined. Peak Ground Acceleration is considered where the structural system is defined. '
    text7 = 'Dist., km – Site distance from the epicenter'
    text8 = 'Shaking Value – Value of the metric considered by the HAZUS analysis. MMI or PGA (cm/s/s)'
    
    pdf.multi_cell(0, 12, text1)
    pdf.multi_cell(0, 12, text2)
    pdf.multi_cell(0, 12, text3)
    pdf.multi_cell(0, 12, text4)
    pdf.multi_cell(0, 12, text5)
    pdf.multi_cell(0, 12, text6)
    pdf.multi_cell(0, 12, text7)
    pdf.multi_cell(0, 12, text8)
    pdf.ln(pdf.font_size)
    
    use_headers = [header for header in headers if header['use']]

    page_width = pdf.w - 2 * pdf.l_margin

    table_width_percent = get_line_width_percent(use_headers)
    if table_width_percent < 1:
        x_offset = (page_width * (1-table_width_percent)) / 2 + pdf.l_margin
    else:
        x_offset = 5

    pdf.set_fill_color(255, 255, 255)
    padding = 2.0

    add_pdf_table_page(use_headers, pdf, padding, x_offset)
    facility_values = get_impact_line_values(use_headers, data)

    line_count = 0
    for line in facility_values:
        # add a new page if we have to
        max_cell_height = get_line_height(line)
        if pdf.get_y() + max_cell_height > pdf.h - pdf.t_margin - pdf.b_margin:
            add_pdf_table_page(use_headers, pdf, padding, x_offset)
    
        pdf.set_x(x_offset)
        add_line_to_pdf(line, use_headers, pdf, padding=padding)

        pdf.ln(max_cell_height + padding)

        line_count += 1

        if line_count % 2 != 0:
            pdf.set_fill_color(215, 215, 215)
        else:
            pdf.set_fill_color(255, 255, 255)


def add_shakemap_to_pdf(pdf, shakemap):
    font = pdf.font_family
    style = pdf.font_style
    size = pdf.font_size_pt
    
    shakemap_image_loc = os.path.join(shakemap.directory_name, 'intensity.jpg')
    shakemap_legend_loc = 'https://d9-wret.s3.us-west-2.amazonaws.com/assets/palladium/production/s3fs-public/thumbnails/image/Mercalli%20Intensity%20Scale_0.png'
    width = pdf.w * 0.50
    top = pdf.get_y() + 10
    left = (pdf.w - width) / 2

    pdf.image(shakemap_image_loc, x=left, y=top, w=width)

    pdf.add_page()
    pdf.set_font(font, 'b', 14)
    pdf.multi_cell(pdf.w, pdf.font_size, 'USGS Shakemap Legend')
    top = pdf.get_y() + 10
    try: 
        pdf.image(shakemap_legend_loc,x=left, y=top, w=width)
    except:
        pass
    
    pdf.set_font(font, '', size)
    
def add_line_to_pdf(line, headers, pdf, padding=0):
    page_width = pdf.w - 2 * pdf.l_margin
    max_cell_height = get_line_height(line)
    start_y = pdf.get_y()

    header_pos = 0
    maxCellHeightLine = 0
    for cell in line:
        start_x = pdf.get_x()

        cell_width = page_width * float(cell['width'])

        #NRS remember the maximum cell height if facility name spans multiple rows
        cell_height = get_cell_height(cell)
        
        
        cell.update(headers[header_pos])
        if cell.get('colors', False):
            colors = cell['colors']
            rgb = colors.get(cell['value'], {'r': 0, 'g': 0, 'b': 0})
            pdf.set_text_color(rgb['r'], rgb['g'], rgb['b'])

        font_style = pdf.font_style
        if cell.get('font_style', False):
            pdf.set_font(pdf.font_family, cell['font_style'], pdf.font_size_pt)

        if cell.get('translate', False):
            value = cell['translate'][cell['value']]
        else:
            value = cell['value']

        if cell_height > pdf.font_size:
            lines = cell_height / pdf.font_size
            pdf.multi_cell(cell_width, pdf.font_size +
                           (padding / lines), str(value), border=1, fill=1)
        else:
            pdf.multi_cell(cell_width, max_cell_height +
                           padding, str(value), border=1, fill=1)
        
        #if (pdf.get_y() - start_y) > maxCellHeightLine:
        #    maxCellHeightLine = (pdf.get_y() - start_y)
        #    cell_height = maxCellHeightLine
        
        pdf.set_text_color(0, 0, 0)
        pdf.set_font(pdf.font_family, font_style, pdf.font_size_pt)
        pdf.set_xy(start_x + cell_width, start_y)

        header_pos += 1


def add_pdf_table_page(headers, pdf, padding=0, x_offset=0):
    pdf.add_page()
    page_width = pdf.w - 2 * pdf.l_margin

    font = pdf.font_family
    style = pdf.font_style
    size = pdf.font_size_pt

    pdf.set_font(font, 'b', size)

    if x_offset:
        pdf.set_x(x_offset)
    for header in headers:
        cell_width = page_width * float(header['width'])
        pdf.cell(cell_width, pdf.font_size + padding, header['val'], border=1)

    pdf.ln(pdf.font_size + padding)
    pdf.set_font(font, style, size)


def get_impact_line_values(headers, data):
    values = []
    for facility_shaking in data:
        facility_data = []
        for header in headers:
            header_name = header['name']

            if header_name == 'shaking_value':
                header_name = facility_shaking.facility.metric.lower()

            value = facility_shaking.__dict__.get(
                header_name, facility_shaking.facility.__dict__.get(header_name,
                                                                    facility_shaking.facility.get_attribute(header_name) or ''))
            if type(value) is float:
                value = round(value * 100) / 100

            facility_data += [{'value': value,
                               'width': float(header['width'])}]

        values += [facility_data]

    return values


def get_line_height(line):
    max_height = 0
    for cell in line:
        height = get_cell_height(cell)
        max_height = height if height > max_height else max_height
    return max_height


def get_line_width_percent(line):
    percent = 0
    for cell in line:
        percent += float(cell['width'])

    return percent


def get_cell_height(cell):
    pdf = Pdf()
    pdf.add_page()
    page_width = pdf.w - 2 * pdf.l_margin

    cell_height = pdf.font_size

    start_y = pdf.get_y()
    cell_width = page_width * float(cell['width'])
    pdf.multi_cell(cell_width, cell_height, str(cell['value']), border=1)

    return pdf.get_y() - start_y


def save_pdf(pdf_string, file_name, directory):
    file_name_ = os.path.join(directory, file_name)
    with open(file_name_, 'wb') as file_:
        file_.write(pdf_string.encode('latin-1'))

def main(group, shakemap, name):
    return generate_impact_pdf(group, shakemap, save=True, pdf_name=name, template_name=group.template)
