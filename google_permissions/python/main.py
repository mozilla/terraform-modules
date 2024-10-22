import functions_framework
import os
import base64
import json

from slack_sdk.webhook import WebhookClient # type: ignore
from slack_sdk.errors import SlackApiError # type: ignore
import time
import random

DEBUG_FLAG = False

def incr_sleep(base):
    time.sleep((2 ** base) + (random.randint(0, 1000) / 1000))

# message type variables to be used in external files
msg_info = "info"
msg_error = "error"

# emojis that map to message type
info_emoji = "information_source"
error_emoji = "x"

def _pad_string(s, length):
    # pad the string with spaces to make it length characters long
    return s + " " * (length - len(s))

def send_slack_msg(msg, extra_dict, webhook_url, type="info"):
    #url = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
    webhook = WebhookClient(webhook_url)

    padlen = 20 # arbitrary based on current keys

    # convert the extra_dict to a list of elements (dicts) for the slack message
    elements = []
    for k, v in extra_dict.items():
        elements.append(
        {
            "type": "rich_text_section",
            "elements": [
                {
                    "type": "text",
                    "text": _pad_string("{}:".format(k), padlen),
                    "style": { "code": True}
                },
                {
                    "type": "text",
                    "text": "{}".format(v),
                    "style": { "code": True}
                }
            ]
		}
        )

    blocks_struct = [
     	{	
			"type": "divider"
		},
		{
			"type": "rich_text",
			"elements": [
				{
					"type": "rich_text_section",
					"elements": [
                        {
                            "type": "emoji",
                            "name": info_emoji if type == "info" else error_emoji
                        },
						{
							"type": "text",
							"text": msg,
                            "style": { "bold": True}
						}
					]
				}
			]
		},
     	{	
			"type": "divider"
		},
        {
			"type": "rich_text",
			"elements": [
                {
                    "type": "rich_text_list",
                    "style": "bullet",
                    "elements": elements
                },
            ]
        },
     	{	
			"type": "divider"
		},
       ]   

    max_retries = 5
    send_succeeded=False
    for i in range(max_retries):
        try:
            response = webhook.send( blocks = blocks_struct )
            if response.status_code == 200:
                send_succeeded=True
                break
        except SlackApiError as e:
            print_debug(f"attempt #{i} error sending slack message: {e.response.status_code}")
            incr_sleep(i)

    if not send_succeeded:
        print("FAILED: sending slack message: {}".format(response.status_code), response.body)

def print_debug(*args):
    global DEBUG_FLAG
    if DEBUG_FLAG:
        arg_string_list = map(str, args)
        print(' '.join(arg_string_list))

def parse_cloud_event(cloud_event):
    # Parse the CloudEvent and extract the asset name
    # from the event payload
    ret_dict = {}
    data = cloud_event["asset"]["resource"]["data"]
    print_debug("grant event data: ", data)
    ret_dict["justification"] =data["justification"]["unstructuredJustification"]
    resource_full = data["name"].split("/")
    ret_dict["resource"] = "/".join(resource_full[0:2])
    ret_dict["requester"] = data["requester"]
    ret_dict["duration"] = data["requestedDuration"]
    state = data["state"]
    if state == "ENDED":
        ret_dict["state"] = state
        ret_dict["event_time"] = data["auditTrail"]["accessRemoveTime"]
    elif state == "ACTIVE":
        ret_dict["state"] = state
        ret_dict["event_time"] = data["auditTrail"]["accessGrantTime"]
    else: # we'll probably discard these but we'll send them for now
        ret_dict["state"] = state
        ret_dict["event_time"] = data["createTime"] # use the event time
    return ret_dict

def main(event_data):
    global DEBUG_FLAG
    DEBUG_FLAG = os.environ.get('DEBUG_FLAG')
    if DEBUG_FLAG:
        DEBUG_FLAG = True
    else:
        DEBUG_FLAG = False

    webhook_url = os.environ.get('SLACK_WEBHOOK_URL')

    if not webhook_url:
        raise ValueError("SLACK_WEBHOOK_URL environment variable not set")

    json_data = json.loads(event_data)
    event_dict = parse_cloud_event(json_data)
    msg = f"Grant entered state: {event_dict['state']} on project {event_dict['resource']}"
    send_slack_msg(msg, event_dict, webhook_url)

# Register a CloudEvent function with the Functions Framework
@functions_framework.cloud_event
def cloudevent_handler(cloud_event):
    print_debug("Received: ", cloud_event)
    cloud_data = base64.b64decode(cloud_event.data["message"]["data"])
    main(cloud_data)

def use_test_files(testdir):
    # Use test files to test the function
    # This is useful for local testing
    # get list of files in the test directory
    test_files = os.listdir(testdir)
    webhook_url = os.environ.get('SLACK_WEBHOOK_URL')
    import json
    for test_file in test_files:
        with open(f"{testdir}/{test_file}", "r") as f:
            json_data = json.load(f)
            event_dict = parse_cloud_event(json_data)
            msg = f"Grant entered state: {event_dict['state']} on project {event_dict['resource']}"
            send_slack_msg(msg, event_dict, webhook_url)
            break

if __name__ == "__main__":
    use_test_files("../test_msg")