import bottle
from bottle import request, route, template, auth_basic, redirect
from utils.db_helper import create_blank
from utils.db_manage import get_all_blanks, get_all_questions_by_token, \
    get_blank_id_by_token, add_new_users_answers, \
    get_blank_info_by_token, get_report_by_token, get_all_standards_by_token, \
    get_all_users_by_token, mark_competences_as_used, get_competences_by_token, \
    change_blank_state_by_token, get_user_answers_by_user_id, \
    change_user_state_by_user_id, get_user_state_by_user_id
import json
from utils.config import *
from utils.notify import send_email


def check(user, password):
    return user == CONFIG["ADMIN_LOGIN"] and password == CONFIG["ADMIN_PASSWORD"]


@route('/admin')
@auth_basic(check)
def get_admin_page():

    blanks = get_all_blanks()
    moderating_blanks = get_all_blanks('moderating')
    tokens = [blank['token'] for blank in blanks]

    standards = [
        {
            'standards': get_all_standards_by_token(token),
            'token': token
        }
        for token in tokens
    ]

    return template('assets/admin.tpl', blanks=blanks, moderatingBlanks=moderating_blanks, standards=standards)


@route('/admin/new_blank', method="POST")
def create_new_blank():

    data = {
        'forms': request.forms,
        'files': request.files
    }

    token = create_blank(data)

    redirect('/admin/blank/{}'.format(token))


@route('/admin/blank/<token>')
@auth_basic(check)
def get_admin_blank_page(token):

    blank = get_blank_info_by_token(token)
    questions = get_all_questions_by_token(token)
    standards = get_all_standards_by_token(token)
    
    hostname = CONFIG["HOSTNAME"]
    port = CONFIG["PORT"]
    
    return template('assets/blank.tpl', questions=questions, blank=blank, token=token, standards=standards, hostname=hostname, port=port)


@route('/admin/save_blank/<token>', method="POST")
@auth_basic(check)
def save_blank(token):
    questions = request.body.read().decode('utf-8')
    questions = json.loads(questions)
    questions = [json.loads(question) for question in questions]

    mark_competences_as_used(questions, token)


@route('/admin/send_email/<token>')
@auth_basic(check)
def send_notification(token):
    recievers = get_all_users_by_token(token)

    send_email(recievers, token)
    change_blank_state_by_token("sent", token)

    redirect('/admin/blank/{}'.format(token))


@route('/admin/report/<token>')
@auth_basic(check)
def get_admin_report_page(token):
    reports = get_report_by_token(token)
    blank = get_blank_info_by_token(token)
    users = get_all_users_by_token(token)

    questions_amount = len(get_competences_by_token(token))
    user_stat = [
        {
            'user_id': user['user_id'],
            'user_email': user['user_email'],
            'stat': int(len(get_user_answers_by_user_id(user['user_id'])) / questions_amount * 100)
        }
        for user in users
    ]

    return template('assets/report.tpl', reports=reports, blank=blank, users=users, user_stat=user_stat)


@route('/quiz/<token>/<user_id>')
def get_quiz_page(token, user_id):
    questions = get_competences_by_token(token)
    blank_info = get_blank_info_by_token(token)

    state = get_user_state_by_user_id(user_id)

    return template('assets/quiz.tpl', questions=questions, token=token, user_id=user_id, blank=blank_info, state=state)


@route('/quiz/<token>/<user_id>', method='POST')
def write_new_user_answers(token, user_id):
    blank_id = get_blank_id_by_token(token)

    answers = request.body.read().decode('utf-8')
    answers = json.loads(answers)
    answers = [json.loads(answer) for answer in answers]

    add_new_users_answers(answers, blank_id, user_id)

    questions_amount = len(get_competences_by_token(token))
    user_answers_amount = len(get_user_answers_by_user_id(user_id))
    stat = user_answers_amount // questions_amount

    if stat == 1:
        change_user_state_by_user_id("finished", user_id)



def main(_host="localhost"):
    app = bottle.app()
    bottle.run(app=app, host=_host, port=CONFIG["PORT"])


if __name__ == "__main__":
    main(CONFIG["HOSTNAME"])
