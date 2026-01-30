"""
Access Event Processor Cloud Function Example

This is a minimal example showing how to process access event notifications.
Customize this for your application's specific needs.
"""

import base64
import json
import logging
import os
from typing import Dict, Any

import functions_framework
from cloudevents.http import CloudEvent

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuration from environment variables
PROJECT_ID = os.environ.get("PROJECT_ID", "")
APPLICATION_NAME = os.environ.get("APPLICATION_NAME", "")
DRY_RUN = os.environ.get("DRY_RUN", "false").lower() == "true"
API_ENDPOINT = os.environ.get("API_ENDPOINT", "")
# Example: Access secret mounted as environment variable
# DATABASE_PASSWORD is provided via Secret Manager (see main.tf)
DATABASE_PASSWORD = os.environ.get("DATABASE_PASSWORD", "")


@functions_framework.cloud_event
def process_exit(cloud_event: CloudEvent) -> None:
    """
    Process an access event notification from Pub/Sub.

    Args:
        cloud_event: The CloudEvent containing the Pub/Sub message
    """
    try:
        # Decode the Pub/Sub message
        pubsub_message = base64.b64decode(cloud_event.data["message"]["data"]).decode()
        exit_data = json.loads(pubsub_message)

        # Validate required fields
        required_fields = ["event_type", "publish_time"]
        for field in required_fields:
            if field not in exit_data:
                logger.error(f"Missing required field: {field}")
                raise ValueError(f"Missing required field: {field}")

        # Validate event type
        event_type = exit_data.get("event_type")
        if event_type != "employee_exit":
            logger.warning(f"Ignoring unsupported event type: {event_type}")
            return

        employee_email = exit_data.get("employee_email")
        logger.info(f"Processing employee_exit event for: {employee_email}")

        # Extract event information
        employee_name = exit_data.get("employee_name", "Unknown")
        event_time = exit_data.get("event_time")
        event_data = exit_data.get("event_data") or {}
        manager_name = event_data.get("manager_name")
        manager_email = event_data.get("manager_email")

        # Extract date from event_time if available
        exit_date = event_time.split("T")[0] if event_time else "Unknown"

        logger.info(
            f"Exit details - Email: {employee_email}, "
            f"Name: {employee_name}, Date: {exit_date}, Manager: {manager_email}"
        )

        # Process the exit
        if DRY_RUN:
            logger.info(f"DRY RUN: Would process exit for {employee_email}")
        else:
            handle_employee_exit(exit_data)

        logger.info(f"Successfully processed exit for {employee_email}")

    except json.JSONDecodeError as e:
        logger.error(f"Failed to decode JSON message: {e}")
        # Don't raise - invalid messages shouldn't retry
        return
    except ValueError as e:
        logger.error(f"Invalid message format: {e}")
        # Don't raise - invalid messages shouldn't retry
        return
    except Exception as e:
        logger.error(f"Error processing exit notification: {e}", exc_info=True)
        # Raise to trigger retry for transient errors
        raise


def handle_employee_exit(exit_data: Dict[str, Any]) -> None:
    """
    Perform application-specific exit processing.

    Customize this function for your application's needs.

    Args:
        exit_data: Dictionary containing access event information with schema:
                   - event_type: Type of event (e.g., "employee_exit")
                   - event_time: ISO 8601 timestamp (nullable)
                   - employee_email: Employee email (nullable)
                   - employee_name: Employee name (nullable)
                   - publish_time: ISO 8601 timestamp
                   - event_data: Event-specific data (nullable object)
    """
    employee_email = exit_data.get("employee_email")
    if not employee_email:
        logger.warning("Missing employee_email, skipping processing")
        return

    event_time = exit_data.get("event_time")
    event_data = exit_data.get("event_data") or {}
    manager_email = event_data.get("manager_email")

    # Extract date from event_time if available
    exit_date = event_time.split("T")[0] if event_time else None

    logger.info(f"Handling exit for {employee_email}")

    # TODO: Implement your application-specific logic here:

    # Example 1: Disable user in your application
    # disable_user(employee_email)

    # Example 2: Revoke database access
    # revoke_database_access(employee_email)

    # Example 3: Delete user-specific resources
    # delete_user_resources(employee_email)

    # Example 4: Send notifications
    # if exit_date:
    #     send_notification_to_team(employee_email, exit_date, manager_email)

    # Example 5: Update audit log
    # log_exit_action(employee_email, exit_date, "processed")

    logger.info(f"Exit processing completed for {employee_email}")


def disable_user(email: str) -> bool:
    """
    Disable a user in your application.

    Args:
        email: User's email address

    Returns:
        True if successful
    """
    logger.info(f"Disabling user: {email}")
    # TODO: Implement your user disable logic
    # Example: Call your application's API
    # response = requests.post(f"{API_ENDPOINT}/users/{email}/disable")
    # return response.status_code == 200
    return True


def revoke_database_access(email: str) -> bool:
    """
    Revoke database access for a user.

    Args:
        email: User's email address

    Returns:
        True if successful
    """
    logger.info(f"Revoking database access for: {email}")
    # TODO: Implement database access revocation
    # Example: Connect to database and revoke user permissions
    # The DATABASE_PASSWORD secret from Secret Manager would be used here:
    # import psycopg2
    # conn = psycopg2.connect(
    #     host="db-host",
    #     database="mydb",
    #     user="admin",
    #     password=DATABASE_PASSWORD  # Secret from environment variable
    # )
    # cursor = conn.cursor()
    # cursor.execute(f"REVOKE ALL PRIVILEGES ON DATABASE mydb FROM {email}")
    # conn.commit()
    return True


def delete_user_resources(email: str) -> bool:
    """
    Delete user-specific resources (files, configs, etc.).

    Args:
        email: User's email address

    Returns:
        True if successful
    """
    logger.info(f"Deleting resources for: {email}")
    # TODO: Implement resource cleanup
    # Examples:
    # - Delete user's GCS buckets/objects
    # - Delete user's configuration files
    # - Remove user-specific database entries
    return True


def send_notification_to_team(email: str, exit_date: str = None, manager_email: str = None) -> None:
    """
    Notify the team about the exit.

    Args:
        email: User's email address
        exit_date: Date of exit (nullable)
        manager_email: Manager's email address (nullable)
    """
    date_str = exit_date if exit_date else "Unknown date"
    logger.info(f"Notifying team about exit: {email} on {date_str}")
    if manager_email:
        logger.info(f"Manager to notify: {manager_email}")
    # TODO: Implement team notification
    # Examples:
    # - Send Slack message
    # - Create JIRA ticket
    # - Send email to team
    pass


# For local testing
if __name__ == "__main__":
    # Create a test event with new schema
    test_data = {
        "event_type": "employee_exit",
        "event_time": "2026-01-26T00:00:00Z",
        "employee_email": "test@mozilla.com",
        "employee_name": "Test User",
        "publish_time": "2026-01-28T19:02:25.123456Z",
        "event_data": {
            "manager_name": "Test Manager",
            "manager_email": "manager@mozilla.com",
        },
    }

    test_event = {
        "data": {
            "message": {
                "data": base64.b64encode(json.dumps(test_data).encode()).decode()
            }
        }
    }

    class TestCloudEvent:
        def __init__(self, data):
            self.data = data

    print("Running local test...")
    os.environ["DRY_RUN"] = "true"
    try:
        process_exit(TestCloudEvent(test_event["data"]))
        print("✅ Test passed!")
    except Exception as e:
        print(f"❌ Test failed: {e}")
