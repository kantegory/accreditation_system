import bottle
from bottle import request, response, route, template, static_file, auth_basic, FormsDict
from utils.db_helper import create_blank
from utils.db_manage import get_all_blanks, get_all_questions_by_token, \
    add_new_user, get_blank_id_by_token, add_new_users_answers, \
    get_blank_info_by_token
import json


def check(user, password):
    return user == "kant" and password == "eter"


@route('/admin')
@auth_basic(check)
def get_admin_page():
    return template('assets/admin.tpl', blanks=get_all_blanks(), moderatingBlanks=get_all_blanks('moderating'))


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
    return template('assets/blank.tpl', questions=questions, blank=blank, token=token)


@route('/admin/report/')
@auth_basic(check)
def get_admin_report_page():
    return template('assets/report.tpl')


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
