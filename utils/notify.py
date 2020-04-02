import smtplib
from .config import *


def send_email(receivers, token):
	sender = CONFIG['EMAIL']

	connection = smtplib.SMTP_SSL('smtp.mail.ru', 465)
	connection.login(sender, CONFIG['PASSWORD'])

	for receiver in receivers:
		msg = 'Здравствуйте! Пройдите, пожалуйста, анкету для АОРПО: http://localhost:8080/quiz/{}/{}'.format(token, receiver['user_id']).encode('utf-8')
		rec_email = receiver['user_email']
		connection.sendmail(sender, rec_email, msg)

	connection.quit()
