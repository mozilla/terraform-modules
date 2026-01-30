#!/usr/bin/env python3
"""
Access Event Processor - Kubernetes Version

This script runs in Kubernetes and pulls messages from the
Pub/Sub subscription created by the mozilla_access_event_consumer module.
"""

import base64
import json
import logging
import os
import sys
from typing import Dict, Any

from google.cloud import pubsub_v1

# Configure logging
logging.basicConfig(
    level=os.getenv("LOG_LEVEL", "INFO"),
    format="%(asctime)s [%(levelname)s] %(message)s",
)
logger = logging.getLogger(__name__)

# Configuration from environment variables
PROJECT_ID = os.getenv("PROJECT_ID")
SUBSCRIPTION_ID = os.getenv("SUBSCRIPTION_ID")  # Full path: projects/{project}/subscriptions/{name}
MAX_MESSAGES = int(os.getenv("MAX_MESSAGES", "100"))
ACK_DEADLINE_SECONDS = int(os.getenv("ACK_DEADLINE_SECONDS", "60"))


def process_exit_event(exit_data: Dict[str, Any]) -> None:
    """
    Process a single access event.

    Args:
        exit_data: Parsed access event data with schema:
                   - event_type: Type of event (e.g., "employee_exit")
                   - event_time: ISO 8601 timestamp (nullable)
                   - employee_email: Employee email (nullable)
                   - employee_name: Employee name (nullable)
                   - publish_time: ISO 8601 timestamp
                   - event_data: Event-specific data (nullable object)
    """
    # Validate event type
    event_type = exit_data.get("event_type")
    if event_type != "employee_exit":
        logger.warning(f"Ignoring unsupported event type: {event_type}")
        return

    employee_email = exit_data.get("employee_email")
    employee_name = exit_data.get("employee_name")
    event_time = exit_data.get("event_time")
    event_data = exit_data.get("event_data") or {}
    manager_email = event_data.get("manager_email")

    # Extract date from event_time if available
    exit_date = event_time.split("T")[0] if event_time else "Unknown"

    logger.info(
        f"Processing employee_exit event for {employee_email} ({employee_name}) "
        f"on {exit_date} (manager: {manager_email})"
    )

    # TODO: Implement your application-specific exit logic here:
    # - Disable user in your application
    # - Revoke database access
    # - Delete user-specific resources
    # - Send notifications
    # - Update audit logs

    # Example: Call your application's user management API
    # disable_user(employee_email)
    # revoke_database_access(employee_email)
    # delete_user_resources(employee_email)

    logger.info(f"Successfully processed exit for {employee_email}")


def pull_and_process_messages() -> int:
    """
    Pull messages from Pub/Sub subscription and process them.

    Returns:
        Number of messages processed
    """
    subscriber = pubsub_v1.SubscriberClient()

    logger.info(f"Pulling up to {MAX_MESSAGES} messages from {SUBSCRIPTION_ID}")

    # Pull messages
    response = subscriber.pull(
        request={
            "subscription": SUBSCRIPTION_ID,
            "max_messages": MAX_MESSAGES,
        },
        timeout=30,
    )

    if not response.received_messages:
        logger.info("No messages to process")
        return 0

    logger.info(f"Received {len(response.received_messages)} messages")

    ack_ids = []
    processed_count = 0

    for received_message in response.received_messages:
        try:
            # Decode message
            message_data = base64.b64decode(received_message.message.data)
            exit_data = json.loads(message_data)

            # Process the exit event
            process_exit_event(exit_data)

            # Add to ACK list
            ack_ids.append(received_message.ack_id)
            processed_count += 1

        except json.JSONDecodeError as e:
            logger.error(f"Failed to decode message: {e}")
            # ACK invalid messages so they don't get retried
            ack_ids.append(received_message.ack_id)

        except Exception as e:
            logger.error(f"Error processing exit event: {e}", exc_info=True)
            # Don't ACK - message will be retried
            continue

    # Acknowledge successfully processed messages
    if ack_ids:
        subscriber.acknowledge(
            request={"subscription": SUBSCRIPTION_ID, "ack_ids": ack_ids}
        )
        logger.info(f"Acknowledged {len(ack_ids)} messages")

    return processed_count


def main() -> int:
    """Main entry point."""
    if not PROJECT_ID or not SUBSCRIPTION_ID:
        logger.error("PROJECT_ID and SUBSCRIPTION_ID must be set")
        return 1

    logger.info("Starting employee exit processor")
    logger.info(f"Project: {PROJECT_ID}, Subscription: {SUBSCRIPTION_ID}")

    try:
        processed = pull_and_process_messages()
        logger.info(f"Processed {processed} exit events")
        return 0

    except Exception as e:
        logger.error(f"Fatal error: {e}", exc_info=True)
        return 1


if __name__ == "__main__":
    sys.exit(main())
