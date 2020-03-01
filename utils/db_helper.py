import os
from .parse_xml import parse_xml


def create_blank(data):
    file = data['files'].get('fileInput1')
    file.save('./standards')
    filename = './standards/{}'.format(file.filename)
    result = {
        'blank_name': data['forms'].get('blank_name'),
        'start_date': data['forms'].get('start_date'),
        'end_date': data['forms'].get('end_date'),
        'standards': parse_xml(filename)
    }

    print(result)