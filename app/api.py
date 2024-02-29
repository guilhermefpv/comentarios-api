# -*- coding: utf-8 -*-

from flask import Flask
from flask import jsonify
from flask import request

import requests

from datetime import datetime
from random import randrange

app_name = 'comentarios'
app = Flask(app_name)
app.debug = True

comments = {}


@app.route('/')
def hello():
	return "Working OK"

@app.route("/healthcheck/")
def healthcheck():

    now = datetime.now()
    request_time = now.strftime(
        "%d %B %Y %I:%M:%S %p"
    )
    response = {
            'status': 'SUCCESS',
            'message': 'Working OK',
            'container': 'comentarios-api',
            'timestamp': request_time
        }
    return jsonify(response)


@app.route('/api/comment/new', methods=['POST'])
def api_comment_new():
    request_data = request.get_json()

    email = request_data['email']
    comment = request_data['comment']
    content_id = '{}'.format(request_data['content_id'])

    new_comment = {
            'email': email,
            'comment': comment,
            }

    if content_id in comments:
        comments[content_id].append(new_comment)
    else:
        comments[content_id] = [new_comment]

    message = 'comment created and associated with content_id {}'.format(content_id)
    response = {
            'status': 'SUCCESS',
            'message': message,
            }
    return jsonify(response)


@app.route('/api/comment/list/<content_id>')
def api_comment_list(content_id):
    content_id = '{}'.format(content_id)

    if content_id in comments:
        return jsonify(comments[content_id])
    else:
        message = 'content_id {} not found'.format(content_id)
        response = {
                'status': 'NOT-FOUND',
                'message': message,
                }
        return jsonify(response), 404



# Generate Error for Test openTelemetry
@app.route("/generate-error/")
def generate_error():
    """Generate Error for Test openTelemetry."""
    if randrange(10) % 2:
        response = requests.get("https://guilhermefpv.free.beeceptor.com/todos")
        response.close()
        listf = []
    elif randrange(10) % 2:
        listf()
    elif randrange(10) % 2:
        map[x] = "e23"
        for x in range(0, 3):
            map[x] = 3
            print(x)
    else:
        a3 = 100 / 0
        print(a3)
