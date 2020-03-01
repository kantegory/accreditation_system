from bs4 import BeautifulSoup


def get_content_by_tag(page, tag):
    result = page.findAll(tag)
    return result


def get_text_by_tag(page, tag):
    result = page.findAll(tag)
    result = [res.get_text() for res in result] if len(result) > 1 else result[0].get_text()
    return result


def get_generalized_work_functions(page):
    tag = 'generalizedworkfunction'
    content = get_content_by_tag(page, tag)

    result = [
        {
            'codeOTF': get_text_by_tag(content[i], 'codeotf'),
            'nameOTF': get_text_by_tag(content[i], 'nameotf'),
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
            'laborActions': get_text_by_tag(content[i], 'laboraction'),
            'requiredSkills': get_text_by_tag(content[i], 'requiredskill'),
            'necessaryKnowledges': get_text_by_tag(content[i], 'necessaryknowledge'),
            'otherCharacteristics': get_text_by_tag(content[i], 'othercharacteristic')
        }
        for i in range(len(content))
    ]

    return result


def main():
    file = open('test.xml', 'r')
    xml = file.read()
    page = BeautifulSoup(xml, 'lxml')
    generalized_work_functions = get_generalized_work_functions(page)
    print(len(generalized_work_functions))
    print(generalized_work_functions)


if __name__ == "__main__":
    main()
