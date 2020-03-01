import bottle
from bottle import request, response, route, template, static_file, auth_basic, FormsDict
from utils.db_helper import create_blank
from utils.db_manage import get_all_blanks
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


@route('/admin/blank/')
@auth_basic(check)
def get_admin_blank_page():
    return template('assets/blank.tpl')


@route('/admin/report/')
@auth_basic(check)
def get_admin_report_page():
    return template('assets/report.tpl')


@route('/quiz')
def get_quiz_page():
    return template('assets/quiz.tpl')


def main(_host="localhost"):
    app = bottle.app()
    bottle.run(app=app, host=_host, port=8082)


if __name__ == "__main__":
    main()
