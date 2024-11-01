#!/usr/bin/env python3

import json
import sys


def load_json(file_path):
    try:
        with open(file_path, "r") as file:
            data = json.load(file)
            return data
    except Exception as e:
        print(f"Error loading JSON file: {e}")
        sys.exit(1)


def main():
    if len(sys.argv) != 5:
        print(
            "Usage: python get_weekly_retro_template.py <summary_json> <organization> <database_id> <view_id>"
        )
        sys.exit(1)

    summary_json = sys.argv[1]
    organization = sys.argv[2]
    database_id = sys.argv[3]
    view_id = sys.argv[4]

    summary_data = load_json(summary_json)

    merged_summary_data = "\n".join(summary_data)

    summary = []

    for line in merged_summary_data.split("\n"):
        if line.startswith("*") and line.endswith("*"):
            summary.append(
                {
                    "type": "sub_header",
                    "content": line[1:].strip().replace("*", ""),
                }
            )
        elif line.startswith("*"):
            summary.append(
                {"type": "bulleted_list", "content": line[1:].strip().replace("*", "")}
            )
        else:
            summary.append({"type": "text", "content": line})

    children = [
        {"type": "header", "content": "Weekly Retro"},
        {"type": "text", "content": "\n"},
        {"type": "sub_header", "content": "Summary"},
        *summary,
        {"type": "text", "content": "\n"},
        {"type": "sub_header", "content": "How to improve"},
        {"type": "text", "content": "your own input"},
    ]

    template = {
        "organization": organization,
        "database-id": database_id,
        "view-id": view_id,
        "properties": [{"key": "Name", "value": "Weekly Retrospective"}],
        "children": children,
    }

    print(json.dumps(template, indent=4))


if __name__ == "__main__":
    main()
