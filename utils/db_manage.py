def add_new_blank(data):
    print(data)

    gwf = data['standards']
    add_new_gwf(gwf)


def add_new_gwf(data):
    print(data)
    print(type(data))
    # otf = [func for func in data]
    pwf = [elem['particularWorkFunctions'] for elem in data][0]
    add_new_pwf(pwf)


def add_new_pwf(data):
    tf = [elem['codeTF'] for elem in data]
    rs = [elem['requiredSkills'] for elem in data]
    nk = [elem['necessaryKnowledges'] for elem in data]
    oc = [elem['otherCharacteristics'] for elem in data]
    add_new_rs(rs, tf)
    add_new_nk(nk, tf)
    add_new_oc(oc, tf)


def add_new_rs(data, tf):

    result = [

        {
            'tf': tf[i],
            'requiredSkill': data[i][j]
        }

        for i in range(len(data))
        for j in range(len(data[i]))

    ]

    print(result)


def add_new_oc(data, tf):

    result = [

        {
            'tf': tf[i],
            'otherCharacteristic': data[i][j]
        }

        for i in range(len(data))
        for j in range(len(data[i]))

    ]

    print(result)


def add_new_nk(data, tf):

    result = [

        {
            'tf': tf[i],
            'necessaryKnowledge': data[i][j]
        }

        for i in range(len(data))
        for j in range(len(data[i]))

    ]

    print(result)


def add_new_otf(data, tf):
    pass
