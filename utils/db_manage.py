from .db import GeneralizedWorkFunction, RequiredSkills, session


def add_new_blank(data):
    print(data)

    gwf = data['standards']
    add_new_gwf(gwf)


def add_new_gwf(data):
    print(data)

    otf = [
        {
            'codeOTF': data[i]['codeOTF'],
            'nameOTF': data[i]['nameOTF'],
            'registrationNumber': data[i]['registrationNumber'],
            'levelOfQualification': data[i]['levelOfQualification']
        }
        for i in range(len(data))
    ]

    add_new_otf(otf)

    pwf = [elem['particularWorkFunctions'] for elem in data][0]
    rn = data[0]['registrationNumber']
    add_new_pwf(pwf, rn)


def add_new_pwf(data, rn):
    tf = [elem['codeTF'] for elem in data]
    rs = [elem['requiredSkills'] for elem in data]
    nk = [elem['necessaryKnowledges'] for elem in data]
    la = [elem['laborActions'] for elem in data]
    add_new_rs(rs, tf, rn)
    add_new_nk(nk, tf, rn)
    add_new_la(la, tf, rn)


def add_new_rs(data, tf, rn):

    result = [

        {
            'codeTF': tf[i],
            'registrationNumber': rn,
            'requiredSkill': data[i][j]
        }

        for i in range(len(data))
        for j in range(len(data[i]))

    ]

    s = session()

    rows = s.query(RequiredSkills).all()
    check = []
    for row in rows:
        check.append(row.registrationNumber)
        check.append(row.codeTF)
        check.append(row.requiredSkill)

    for curr_row in result:
        if str(curr_row["registrationNumber"]) not in check \
                and str(curr_row["codeTF"]) not in check \
                and str(curr_row["requiredSkill"] not in check):
            rs = RequiredSkills(
                codeTF=curr_row['codeTF'],
                registrationNumber=curr_row['registrationNumber'],
                requiredSkill=curr_row['requiredSkill']
            )
            s.add(rs)
    s.commit()


def add_new_la(data, tf, rn):

    result = [

        {
            'codeTF': tf[i],
            'registrationNumber': rn,
            'laborActions': data[i][j]
        }

        for i in range(len(data))
        for j in range(len(data[i]))

    ]

    print(result)


def add_new_nk(data, tf, rn):

    result = [

        {
            'codeTF': tf[i],
            'registrationNumber': rn,
            'necessaryKnowledge': data[i][j]
        }

        for i in range(len(data))
        for j in range(len(data[i]))

    ]

    print(result)


def add_new_otf(data):
    s = session()

    rows = s.query(GeneralizedWorkFunction).all()
    check = []
    for row in rows:
        check.append(row.registrationNumber)
    for curr_row in data:
        if str(curr_row["registrationNumber"]) not in check:
            gwf = GeneralizedWorkFunction(
                codeOTF=curr_row['codeOTF'],
                nameOTF=curr_row['nameOTF'],
                levelOfQualification=curr_row['levelOfQualification'],
                registrationNumber=curr_row['registrationNumber'],
            )
            s.add(gwf)
    s.commit()
