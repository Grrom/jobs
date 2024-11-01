#!/bin/bash
# example usage: ./save-to-notion.sh -o grrom -d 24d0eb3e477d410d9aa863e86fb5fc9e -v 502c0d0a4c7d4784a1b6819beaf01b72 -p properties.json -c children.json
# Function to send a message to Pub/Sub notion
create_notion_params() {
    local organization="$1"
    local database_id="$2"
    local view_id="$3"
    @param properties A JSON file containing the properties to be saved to Notion.
    local properties="$4"
    @param children A JSON file containing the children to be saved to Notion.
    local children="$5"

    echo "{
        \"organization\": \"$organization\",
        \"database-id\": \"$database_id\",
        \"view-id\": \"$view_id\",
        \"properties\": $(jq -c . $properties),
        \"children\": $(jq -c . $children)
    }"
}

# Parse flags
while getopts "o:d:v:p:c:" opt; do
    case $opt in
        o) ORGANIZATION="$OPTARG"
        ;;
        d) DATABASE_ID="$OPTARG"
        ;;
        v) VIEW_ID="$OPTARG"
        ;;
        p) PROPERTIES="$OPTARG"
        ;;
        c) CHILDREN="$OPTARG"
        ;;
        \?) echo "Invalid option -$OPTARG" >&2
        ;;
    esac
done

# Check if all required flags are provided
if [ -z "$ORGANIZATION" ] || [ -z "$DATABASE_ID" ] || [ -z "$VIEW_ID" ] || [ -z "$PROPERTIES" ] || [ -z "$CHILDREN" ]; then
    echo "Usage: $0 -o <organization> -d <database_id> -v <view_id> -p <properties> -c <children>"
    exit 1
fi

NOTION_PARAMS=$(create_notion_params "$ORGANIZATION" "$DATABASE_ID" "$VIEW_ID" "$PROPERTIES" "$CHILDREN")

echo $NOTION_PARAMS



