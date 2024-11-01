#!/bin/bash
# Example message
# ./send-to-pubsub.sh -p mydas-stuff -t discord-alert -m "{\"channel-name\": \"alerts\", \"message\": \"from the scripto\", \"link\": \"https://www.youtube.com/watch?v=dQw4w9WgXcQ\"}"

# Function to send a message to Pub/Sub
send_to_pubsub() {
    local project_id="$1"
    local topic="$2"
    local message="$3"

    gcloud pubsub topics publish "$topic" --project="$project_id" --message="$message" --format="json"
    echo "Message sent to Pub/Sub topic $topic in project $project_id"
}


# Parse flags
while getopts "p:t:m:" opt; do
    case $opt in
        p) PROJECT_ID="$OPTARG"
        ;;
        t) TOPIC_NAME="$OPTARG"
        ;;
        m) MESSAGE="$OPTARG"
        ;;
        \?) echo "Invalid option -$OPTARG" >&2
        ;;
    esac
done

# Check if all required flags are provided
if [ -z "$PROJECT_ID" ] || [ -z "$TOPIC_NAME" ] || [ -z "$MESSAGE" ]; then
    echo "Usage: $0 -p <project_id> -t <topic_name> -m <message>"
    exit 1
fi


echo "Sending message to Pub/Sub topic $TOPIC_NAME in project $PROJECT_ID"
echo "Message: $MESSAGE"
send_to_pubsub "$PROJECT_ID" "$TOPIC_NAME" "$MESSAGE"