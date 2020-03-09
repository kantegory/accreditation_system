from os import listdir
from os.path import isfile, join
from .parse_xml import parse_xml
from .db_manage import add_new_blank, add_new_user


def create_blank(data):
    path = './standards/'
    files = [data['files'].get('fileInput{}'.format(i)) for i in range(1, len(data['files']) + 1)]
    token = ''

    emails = data['forms'].get('emails').split(',')
    emails = [email.strip() for email in emails]

    for file in files:

        filename = '{}{}'.format(path, file.filename)
        all_files = [f for f in listdir(path) if isfile(join(path, f))]
        if file.filename not in all_files:
            file.save(path)

        result = {
            'blank_name': data['forms'].get('blank_name'),
            'standards': parse_xml(filename)
        }

        token = add_new_blank(result)

    user_data = [
        {
            'email': email,
            'token': token
        }
        for email in emails
    ]

    add_new_user(user_data)

    return token
