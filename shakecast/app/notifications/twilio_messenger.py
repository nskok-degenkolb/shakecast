"""Utility wrapper for sending MMS notifications through Twilio."""

from __future__ import annotations

import importlib
from typing import List, Optional, Sequence

from twilio.rest import Client

import shakecast.app.env as env


class TwilioMessenger:
    """Send MMS messages through the configured Twilio account."""

    def __init__(self) -> None:
        importlib.reload(env)
        self.account_sid: str = env.TWILIO_ACCOUNT_SID or ''
        self.auth_token: str = env.TWILIO_AUTH_TOKEN or ''
        self.from_number: str = env.TWILIO_FROM_NUMBER or ''
        self.messaging_service_sid: str = env.TWILIO_MESSAGING_SERVICE_SID or ''
        self.notify: bool = bool(env.TWILIO_SEND_NOTIFICATIONS)
        self._client: Optional[Client] = None

        if self.account_sid and self.auth_token:
            self._client = Client(self.account_sid, self.auth_token)
        print("Account SID" + env.TWILIO_ACCOUNT_SID)
        print("Auth Token" + env.TWILIO_AUTH_TOKEN )
        print("From Number" + env.TWILIO_FROM_NUMBER )
        print("Service SID" + env.TWILIO_MESSAGING_SERVICE_SID )
        print("self notify" + bool(env.TWILIO_SEND_NOTIFICATIONS))
    @property
    def enabled(self) -> bool:
        """Return True when Twilio notifications are configured."""

        return (
            self.notify
            and self._client is not None
            and (self.from_number or self.messaging_service_sid)
        )

    def send_mms(
        self,
        *,
        body: str,
        recipients: Sequence[str],
        media_urls: Optional[Sequence[str]] = None,
    ) -> List[str]:
        """Send an MMS to the provided recipients.

        Args:
            body: Text body for the MMS message.
            recipients: Iterable of phone numbers (E.164 format preferred).
            media_urls: Optional list of media URLs to attach to the MMS.

        Returns:
            The Twilio message SIDs for successfully queued messages.

        Raises:
            ValueError: If Twilio is not configured properly.
            TwilioException: If Twilio raises an error while sending.
        """

        if not self.enabled:
            raise ValueError('Twilio MMS notifications are not enabled')

        if not recipients:
            return []

        client = self._client
        assert client is not None

        message_kwargs = {
            'body': body,
            'media_url': list(media_urls) if media_urls else None,
        }

        if self.messaging_service_sid:
            message_kwargs['messaging_service_sid'] = self.messaging_service_sid
        else:
            message_kwargs['from_'] = self.from_number

        if not message_kwargs['media_url']:
            message_kwargs.pop('media_url')

        sids: List[str] = []
        for recipient in recipients:
            if not recipient:
                continue

            send_kwargs = dict(message_kwargs)
            send_kwargs['to'] = recipient
            message = client.messages.create(**send_kwargs)
            sids.append(message.sid)

        return sids
