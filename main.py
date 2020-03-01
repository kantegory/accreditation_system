import bottle
from bottle import request, response, route, template, static_file
import json


@route('/admin')
def get_admin_page():
    return template('assets/admin.tpl')


@route('/admin/blank/')
def get_admin_blank_page():
    return template('assets/blank.tpl')


@route('/admin/report/')
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
