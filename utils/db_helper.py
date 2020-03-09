from os import listdir
from os.path import isfile, join
from .parse_xml import parse_xml
from .db_manage import add_new_blank


def create_blank(data):
    path = './standards/'
    files = [data['files'].get('fileInput{}'.format(i)) for i in range(1, len(data['files']) + 1)]
    print('files', files)
    for file in files:
        print(file)
        filename = '{}{}'.format(path, file.filename)
        all_files = [f for f in listdir(path) if isfile(join(path, f))]
        if file.filename not in all_files:
            file.save(path)

        result = {
            'blank_name': data['forms'].get('blank_name'),
            'standards': parse_xml(filename)
        }

        add_new_blank(result)
