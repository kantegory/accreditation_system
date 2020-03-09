import bottle
from bottle import request, response, route, template, auth_basic
from utils.db_helper import create_blank
from utils.db_manage import get_all_blanks, get_all_questions_by_token, \
    add_new_user, get_blank_id_by_token, add_new_users_answers, \
    get_blank_info_by_token, get_report_by_token, get_all_standards_by_token
import json


def check(user, password):
    return user == "" and password == ""


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

    create_blank(data)

    response.status = 200
    return response


@route('/admin/blank/<token>')
@auth_basic(check)
def get_admin_blank_page(token):
    blank = get_blank_info_by_token(token)
    questions = get_all_questions_by_token(token)
    standards = get_all_standards_by_token(token)
    return template('assets/blank.tpl', questions=questions, blank=blank, token=token, standards=standards)


@route('/admin/report/<token>')
@auth_basic(check)
def get_admin_report_page(token):
    reports = get_report_by_token(token)
    blank = get_blank_info_by_token(token)
    return template('assets/report.tpl', reports=reports, blank=blank)


@route('/quiz/<token>')
def get_quiz_page(token):
    questions = get_all_questions_by_token(token)
    return template('assets/quiz.tpl', questions=questions, token=token)


@route('/quiz/<token>/', method='POST')
def write_new_user_answers(token):
    user_id = add_new_user(token)
    blank_id = get_blank_id_by_token(token)

    answers = request.body.read().decode('utf-8')
    answers = json.loads(answers)
    answers = [json.loads(answer) for answer in answers]

    add_new_users_answers(answers, blank_id, user_id)
    print('answers', answers)
    print('type', type(answers))


def main(_host="localhost"):
    app = bottle.app()
    bottle.run(app=app, host=_host, port=8082)


if __name__ == "__main__":
    main()
