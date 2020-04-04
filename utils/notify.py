import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from .config import *


def send_email(receivers, token):
	sender = CONFIG['NOTIFY_EMAIL']

	connection = smtplib.SMTP_SSL(CONFIG['NOTIFY_SMTP_HOST'], CONFIG['NOTIFY_SMTP_PORT'])
	connection.login(sender, CONFIG['NOTIFY_PASSWORD'])

	for receiver in receivers:
		msg = MIMEMultipart()

		msg['From'] = sender
		msg['To'] = receiver['user_email']
		msg['Subject'] = 'Анкета от АОРПО'

		msg_body = 'Здравствуйте! \n Пройдите, пожалуйста, анкету для АОРПО: {}:{}/quiz/{}/{}'.format(CONFIG['HOSTNAME'], \
			CONFIG['PORT'], token, receiver['user_id'])

		msg.attach(MIMEText(msg_body, 'plain'))
		
		connection.send_message(msg)

	connection.quit()
