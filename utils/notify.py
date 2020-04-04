import smtplib
from .config import *


def send_email(receivers, token):
	sender = CONFIG['NOTIFY_EMAIL']

	connection = smtplib.SMTP_SSL(CONFIG['NOTIFY_SMTP_HOST'], CONFIG['NOTIFY_SMTP_PORT'])
	connection.login(sender, CONFIG['NOTIFY_PASSWORD'])

	for receiver in receivers:
		msg = 'Здравствуйте! Пройдите, пожалуйста, анкету для АОРПО: {}:{}/quiz/{}/{}'.format(CONFIG["HOSTNAME"], CONFIG["PORT"], token, receiver['user_id']).encode('utf-8')
		rec_email = receiver['user_email']
		connection.sendmail(sender, rec_email, msg)

	connection.quit()
