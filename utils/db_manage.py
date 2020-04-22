from .db import GeneralizedWorkFunction, RequiredSkills, LaborActions, NecessaryKnowledges, \
    Blanks, BlankStandards, Users, UserAnswers, session, Competences
from hashlib import md5
from sqlalchemy import and_


def get_token(data):
    result = data['blank_name']
    result = result.encode('utf-8')
    result = md5(result).hexdigest()

    return result


def add_new_blank(data):
    result = {
        'blank_name': data['blank_name'],
    }

    token = get_token(result)
    state = 'moderating'

    s = session()

    check = []
    rows = s.query(Blanks).filter(Blanks.token == token)

    for row in rows:
        check.append(row.token)

    if token not in check:
        blank = Blanks(
            name=data['blank_name'],
            token=token,
            state=state
        )
        s.add(blank)
    s.commit()

    gwf = data['standards']
    add_new_gwf(gwf, token)

    return token


def add_new_gwf(data, token):

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
    add_new_blank_standard(token, rn)


def add_new_blank_standard(token, standard_registration_number):
    s = session()

    blank_id = s.query(Blanks).filter(Blanks.token == token)

    for row in blank_id:
        blank_id = row.id

    bs = BlankStandards(
        blankId=blank_id,
        standardRegistrationNumber=standard_registration_number
    )

    s.add(bs)
    s.commit()

    get_all_questions_by_token(token)


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
            'laborAction': data[i][j]
        }

        for i in range(len(data))
        for j in range(len(data[i]))

    ]

    s = session()

    rows = s.query(LaborActions).all()
    check = []
    for row in rows:
        check.append(row.registrationNumber)
        check.append(row.codeTF)
        check.append(row.laborAction)

    for curr_row in result:
        if str(curr_row["registrationNumber"]) not in check \
                and str(curr_row["codeTF"]) not in check \
                and str(curr_row["laborAction"] not in check):
            la = LaborActions(
                codeTF=curr_row['codeTF'],
                registrationNumber=curr_row['registrationNumber'],
                laborAction=curr_row['laborAction']
            )
            s.add(la)
    s.commit()


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

    s = session()

    rows = s.query(NecessaryKnowledges).all()
    check = []
    for row in rows:
        check.append(row.registrationNumber)
        check.append(row.codeTF)
        check.append(row.necessaryKnowledge)

    for curr_row in result:
        if str(curr_row["registrationNumber"]) not in check \
                and str(curr_row["codeTF"]) not in check \
                and str(curr_row["necessaryKnowledge"] not in check):
            nk = NecessaryKnowledges(
                codeTF=curr_row['codeTF'],
                registrationNumber=curr_row['registrationNumber'],
                necessaryKnowledge=curr_row['necessaryKnowledge']
            )
            s.add(nk)
    s.commit()


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


def get_required_skills_by_registration_number(registration_number):
    s = session()

    rs = s.query(RequiredSkills).filter(RequiredSkills.registrationNumber == registration_number).all()

    result = [
        {
            'id': rs[i].id,
            'codeTF': rs[i].codeTF,
            'registrationNumber': rs[i].registrationNumber,
            'question': rs[i].requiredSkill,
            'questionType': 'requiredSkill'
        }
        for i in range(len(rs))
    ]

    return result


def get_necessary_knowledges_by_registration_number(registration_number):
    s = session()

    nk = s.query(NecessaryKnowledges).filter(NecessaryKnowledges.registrationNumber == registration_number).all()

    result = [
        {
            'id': nk[i].id,
            'codeTF': nk[i].codeTF,
            'registrationNumber': nk[i].registrationNumber,
            'question': nk[i].necessaryKnowledge,
            'questionType': 'necessaryKnowledge'
        }
        for i in range(len(nk))
    ]

    return result


def get_labor_actions_by_registration_number(registration_number):
    s = session()

    la = s.query(LaborActions).filter(LaborActions.registrationNumber == registration_number).all()

    result = [
        {
            'id': la[i].id,
            'codeTF': la[i].codeTF,
            'registrationNumber': la[i].registrationNumber,
            'question': la[i].laborAction,
            'questionType': 'laborAction'
        }
        for i in range(len(la))
    ]

    return result


def get_all_questions_by_blank_id(blank_id):
    s = session()

    standards = s.query(BlankStandards).filter(BlankStandards.blankId == blank_id).all()

    _rs = []
    _la = []
    _nk = []

    for standard in standards:
        rs_standard = get_required_skills_by_registration_number(standard.standardRegistrationNumber)
        _rs.append(rs_standard)

        la_standard = get_labor_actions_by_registration_number(standard.standardRegistrationNumber)
        _la.append(la_standard)

        nk_standard = get_necessary_knowledges_by_registration_number(standard.standardRegistrationNumber)
        _nk.append(nk_standard)

    blank_questions = []

    for rs in _rs:
        for question in rs:
            blank_questions.append(question)

    for la in _la:
        for question in la:
            blank_questions.append(question)

    for nk in _nk:
        for question in nk:
            blank_questions.append(question)

    questions = [
        {
            'id': question['id'],
            'question': question['question'],
            'questionType': question['questionType'],
            'codeTF': question['codeTF'],
            'standardRegistrationNumber': question['registrationNumber']
        }
        for question in blank_questions
    ]

    return questions


def get_all_questions_by_token(token):
    s = session()

    blank = s.query(Blanks).filter(Blanks.token == token)
    blank_id = blank[0].id

    questions = get_all_questions_by_blank_id(blank_id)

    return questions


def get_blank_id_by_token(token):
    s = session()

    blanks = s.query(Blanks).filter(Blanks.token == token)

    blank_id = blanks[0].id

    return blank_id


def get_blank_info_by_token(token):
    s = session()

    blanks = s.query(Blanks).filter(Blanks.token == token)
    blanks = blanks[0]

    blank_info = {
        'id': blanks.id,
        'name': blanks.name,
        'token': token,
        'state': blanks.state
    }

    return blank_info


def get_all_standards_by_token(token):
    s = session()

    blank_id = get_blank_id_by_token(token)

    standards = s.query(BlankStandards).filter(BlankStandards.blankId == blank_id)

    all_standards = [standard.standardRegistrationNumber for standard in standards]

    return all_standards


def get_all_blanks(state="all"):
    s = session()

    blanks = s.query(Blanks).all()

    if state == "moderating":
        blanks = s.query(Blanks).filter(Blanks.state == "moderating").all()

    all_blanks = [
        {
            'name': blank.name,
            'token': blank.token,
            'state': blank.state
        }
        for blank in blanks
    ]

    return all_blanks


def add_new_user(data):
    s = session()

    for user_data in data:

        user = Users(
            token=user_data['token'],
            email=user_data['email'],
            state='unfinished'
        )

        s.add(user)

    s.commit()

    # return last_id


def get_all_users_by_token(token):
    s = session()

    users = s.query(Users).filter(Users.token == token).all()

    users = [
        {
            'user_id': user.id,
            'user_email': user.email
        }
        for user in users
    ]

    return users


def add_new_users_answers(data, blank_id, user_id):

    s = session()

    rows = s.query(UserAnswers).filter(UserAnswers.userId == user_id).all()
    check = []

    for row in rows:
        check.append(row.question)

    print("check", check)

    for curr_row in data:
        if len(check) > 0:
                if curr_row["question"] not in check:
                    print("add", curr_row)

                    user_answers = UserAnswers(
                        blankId=blank_id,
                        userId=user_id,
                        question=curr_row['question'],
                        questionType=curr_row['questiontype'],
                        answer=curr_row['answer'],
                        registrationNumber=curr_row['registrationnumber']
                    )

                    s.add(user_answers)

                else:
                    print("update", curr_row)

                    s.query(UserAnswers).filter(and_(UserAnswers.question == curr_row["question"], UserAnswers.userId == user_id)).update({"answer": curr_row["answer"]})

        else:
            print("add", curr_row)
            
            user_answers = UserAnswers(
                blankId=blank_id,
                userId=user_id,
                question=curr_row['question'],
                questionType=curr_row['questiontype'],
                answer=curr_row['answer'],
                registrationNumber=curr_row['registrationnumber']
            )

            s.add(user_answers)

    s.commit()


def get_user_answers_by_blank_id(blank_id):

    s = session()

    user_answers = s.query(UserAnswers).filter(UserAnswers.blankId == blank_id)

    user_answers = [
        {
            'blankId': user_answer.blankId,
            'userId': user_answer.userId,
            'question': user_answer.question,
            'questionType': user_answer.questionType,
            'answer': user_answer.answer,
            'registrationNumber': user_answer.registrationNumber
        }
        for user_answer in user_answers
    ]

    return user_answers


def get_user_answers_by_user_id(user_id):

    s = session()

    user_answers = s.query(UserAnswers).filter(UserAnswers.userId == user_id).all()

    user_answers = [
        {
            'blankId': user_answer.blankId,
            'userId': user_answer.userId,
            'question': user_answer.question,
            'questionType': user_answer.questionType,
            'answer': user_answer.answer,
            'registrationNumber': user_answer.registrationNumber
        }
        for user_answer in user_answers
    ]

    return user_answers


def get_report_by_token(token):

    blank_id = get_blank_id_by_token(token)
    user_answers = get_user_answers_by_blank_id(blank_id)

    return user_answers


def mark_competences_as_used(competences, token):

    s = session()

    for competence in competences:
        competence = Competences(
            token=token,
            competenceId=competence['id'],
            competenceType=competence['questiontype']
        )
        s.add(competence)

    s.commit()


def get_all_questions_for_competences(competences):

    s = session()

    tables = {
        'requiredSkill': RequiredSkills,
        'necessaryKnowledge': NecessaryKnowledges,
        'laborAction': LaborActions
    }

    questions = []

    for competence in competences:
        curr_type = competence['type']
        curr_id = competence['id']

        question = s.query(tables[curr_type]).filter(tables[curr_type].id == curr_id).first().__dict__

        question = {
            'id': question['id'],
            'question': question[curr_type],
            'questionType': curr_type,
            'codeTF': question['codeTF'],
            'standardRegistrationNumber': question['registrationNumber']
        }

        questions.append(question)

    return questions


def get_competences_by_token(token):

    s = session()

    competences = s.query(Competences).filter(Competences.token == token)

    competences = [
        {
            'id': competence.competenceId,
            'type': competence.competenceType
        }
        for competence in competences
    ]

    questions = get_all_questions_for_competences(competences)

    return questions


def change_blank_state_by_token(state, token):

    s = session()

    s.query(Blanks).filter(Blanks.token == token).update({"state": state})
    s.commit()


def change_user_state_by_user_id(state, user_id):

    s = session()

    s.query(Users).filter(Users.id == user_id).update({"state": state})
    s.commit()


def get_user_state_by_user_id(user_id):

    s = session()

    user = s.query(Users).filter(Users.id == user_id).first().__dict__
    state = user["state"]

    return state


def get_users_work_experience_by_blank_id(blank_id):
    user_answers = get_user_answers_by_blank_id(blank_id)

    data = [[],[],[]]

    work_experiences = [{"answer": int(user_answer["answer"]), "userId": user_answer["userId"]} for user_answer in user_answers if user_answer["registrationNumber"] == 0]

    for work_experience in work_experiences:
        exp = work_experience["answer"] - 1
        userId = work_experience["userId"]

        user_answers = get_user_answers_by_user_id(userId)

        data[exp].append(user_answers)

    return data
