from os import listdir
from os.path import isfile, join
from .parse_xml import parse_xml
from .db_manage import add_new_blank


def create_blank(data):
    path = './standards/'
    file = data['files'].get('fileInput1')
    filename = '{}{}'.format(path, file.filename)
    files = [f for f in listdir(path) if isfile(join(path, f))]
    if file.filename not in files:
        file.save(path)

    result = {
        'blank_name': data['forms'].get('blank_name'),
        'standards': parse_xml(filename)
    }

    add_new_blank(result)
