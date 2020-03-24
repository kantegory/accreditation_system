import smtplib


def send_email(receivers, msg):
    sender = 'mail'

    connection = smtplib.SMTP_SSL('smtp.mail.ru', 465)
    connection.login(sender, 'strong_password')

    for receiver in receivers:
        connection.sendmail(sender, receiver, msg)

    connection.quit()
