import json
import logging
from os import environ
import urllib.request
from urllib.parse import urlencode

LOG = logging.getLogger()
LOG.setLevel('DEBUG')

PUSHOVER_API = 'https://api.pushover.net/1/messages.json'


def send_msg_to_pushover(token, userkey, title, payload):
    """Send payload as message to Pushover API."""
    data = urlencode({
        'token': token,
        'user': userkey,
        'message': payload,
        'title': title,
    }).encode()

    req = urllib.request.Request(url=PUSHOVER_API, data=data, method='POST')
    return urllib.request.urlopen(req)


def contact_us(body):
    LOG.info("Processing payload %s" % body)

    try:
        body = json.loads(body)
        msg = 'Name: %(name)s\nMail: %(email)s\nDesc: %(description)s\n' % body

    except (TypeError, json.JSONDecodeError) as error:
        msg = 'JSON body is malformatted: %s' % error
        LOG.fatal(msg)
        return json.dumps({"error": msg}), 400

    except KeyError as error:
        msg = 'Key missing: %s' % error
        LOG.fatal(msg)
        return json.dumps({'error': msg}), 400

    token = environ.get('PUSHOVER_TOKEN')
    userkey = environ.get('PUSHOVER_USERKEY')

    if not (token and userkey):
        msg = 'Missing Pushover enviroment variables'
        LOG.fatal(msg)
        return json.dumps({'error': msg}), 500

    try:
        LOG.info('Delivering message via Pushover')
        send_msg_to_pushover(token=token,
                             userkey=userkey,
                             title='New /contact_us submission received',
                             payload=msg)
        LOG.info('Message delivered successfully')
        return json.dumps({"message": "message delivered"}), 200

    except Exception as error:
        LOG.fatal('Something went wrong: %s' % error)
        return json.dumps({'error': str(error)}), 500


def lambda_handler(event, context):
    # ref: https://docs.aws.amazon.com/apigateway/latest
    #   /developerguide/set-up-lambda-proxy-integrations.html
    response = {
        "body": json.dumps({"message": ""}),
        "headers": {
            "Access-Control-Allow-Origin": "*"
        },
        "statusCode": 405,
        "isBase64Encoded": False,
    }

    path, method = event.get('path'), event.get('httpMethod')
    body = event.get('body')

    if not (path and method):
        msg = "Missing API Gateway event data"
        LOG.fatal(msg)
        response["body"] = json.dumps({"error": msg})
        return response

    LOG.info('Received HTTP %s request for path %s' % (method, path))

    if (path == '/contact_us' and method == 'POST'):
        response["body"], response["statusCode"] = contact_us(body)

    else:
        msg = '%s %s not allowed' % (method, path)
        response["statusCode"] = 405
        response["body"] = json.dumps({"error": msg})
        LOG.error(msg)

    return response
