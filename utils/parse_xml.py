from bs4 import BeautifulSoup
import io


def get_content_by_tag(page, tag):
    result = page.findAll(tag)
    return result


def get_text_by_tag(page, tag, checker=None):
    result = page.findAll(tag)
    if checker:
        checker = checker.decode('utf-8', 'ignore')
        checker = checker[1:-3]

        result = [res.get_text().encode('utf-8', 'ignore') for res in result if checker not in res.get_text()] \
            if len(result) > 1 else result[0].get_text().encode('utf-8', 'ignore')
    else:
        result = [res.get_text().encode('utf-8', 'ignore') for res in result] \
            if len(result) > 1 else result[0].get_text().encode('utf-8', 'ignore')
    return result


def get_generalized_work_functions(page):
    tag = 'generalizedworkfunction'
    content = get_content_by_tag(page, tag)

    result = [
        {
            'codeOTF': get_text_by_tag(content[i], 'codeotf'),
            'nameOTF': get_text_by_tag(content[i], 'nameotf'),
            'registrationNumber': get_text_by_tag(page, 'registrationnumber'),
            'levelOfQualification': get_text_by_tag(content[i], 'levelofqualification'),
            'possibleJobTitle': get_text_by_tag(content[i], 'possiblejobtitle'),
            'particularWorkFunctions': get_particular_work_function(content[i])
        }
        for i in range(len(content))
    ]

    return result


def get_particular_work_function(page):
    tag = 'particularworkfunction'
    content = get_content_by_tag(page, tag)

    result = [
        {
            'codeTF': get_text_by_tag(content[i], 'codetf'),
            'nameTF': get_text_by_tag(content[i], 'nametf'),
            'laborActions': get_text_by_tag(content[i], 'laboraction', get_text_by_tag(content[i], 'codetf')),
            'requiredSkills': get_text_by_tag(content[i], 'requiredskill', get_text_by_tag(content[i], 'codetf')),
            'necessaryKnowledges': get_text_by_tag(content[i], 'necessaryknowledge', get_text_by_tag(content[i], 'codetf'))
        }
        for i in range(len(content))
    ]

    return result


def parse_xml(filename):
    xml = io.open(filename, mode="r", encoding="utf-8")
    xml = xml.read()
    page = BeautifulSoup(xml, 'lxml')
    generalized_work_functions = get_generalized_work_functions(page)

    return generalized_work_functions
