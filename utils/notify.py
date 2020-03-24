import smtplib
from .config import *


def send_email(receivers, msg):
    sender = CONFIG['EMAIL']

    connection = smtplib.SMTP_SSL('smtp.mail.ru', 465)
    connection.login(sender, CONFIG['PASSWORD'])

    for receiver in receivers:
        connection.sendmail(sender, receiver, msg)

    connection.quit()
