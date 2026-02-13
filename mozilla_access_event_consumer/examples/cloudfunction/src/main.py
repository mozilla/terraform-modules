"""
Access Event Processor Cloud Function

Processes access event notifications delivered via Pub/Sub push subscription
to an HTTP-triggered Cloud Function.
"""

import base64
import json
import os
import sys

import functions_framework
from flask import Request
from mozlog import structuredlog, handlers, formatters

# Configure mozlog structured JSON logging to stdout
logger = structuredlog.StructuredLogger("access-event-processor")
logger.add_handler(handlers.StreamHandler(sys.stdout, formatters.JSONFormatter()))

DRY_RUN = os.environ.get("DRY_RUN", "false").lower() == "true"

# Secrets from Secret Manager are exposed as environment variables via
# function_secret_environment_variables in main.tf. For example:
# DATABASE_PASSWORD = os.environ.get("DATABASE_PASSWORD", "")


@functions_framework.http
def process_access_event(request: Request) -> tuple[str, int]:
    """
    Process an access event notification from a Pub/Sub push subscription.

    Returns:
        Tuple of (response body, HTTP status code).
        2xx acknowledges the message; non-2xx triggers retry.
    """
    try:
        envelope = request.get_json(silent=True)
        if not envelope:
            logger.error("No JSON payload received")
            return "Bad Request: no JSON payload", 400

        if "message" not in envelope:
            logger.error("Missing 'message' key in payload")
            return "Bad Request: missing 'message' key", 400

        # Decode the Pub/Sub message data
        message_data = envelope["message"].get("data", "")
        pubsub_message = base64.b64decode(message_data).decode()
        access_event = json.loads(pubsub_message)

        # Validate required fields
        required_fields = ["event_type", "publish_time"]
        for field in required_fields:
            if field not in access_event:
                logger.error(f"Missing required field: {field}")
                return f"Invalid message: missing {field}", 200

        event_type = access_event.get("event_type")
        if event_type != "employee_exit":
            logger.warning(f"Ignoring unsupported event type: {event_type}")
            return "Ignored: unsupported event type", 200

        employee_email = access_event.get("employee_email")
        logger.info(f"Processing employee_exit event for: {employee_email}")

        if DRY_RUN:
            logger.info(f"DRY RUN: Would process access event for {employee_email}")
        else:
            # TODO: Implement your application-specific access event processing here.
            pass

        logger.info(f"Successfully processed access event for {employee_email}")
        return "OK", 200

    except json.JSONDecodeError as e:
        logger.error(f"Failed to decode JSON message: {e}")
        return "Invalid JSON", 200
    except Exception as e:
        logger.error(f"Error processing access event notification: {e}", exc_info=True)
        return "Internal Server Error", 500
