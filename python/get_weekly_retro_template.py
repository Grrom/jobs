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
    if len(sys.argv) != 3:
        print(
            "Usage: python get_weekly_retro_template.py <summary.json> <recommendations.json>"
        )
        sys.exit(1)

    summary_json = sys.argv[1]
    recommendations_json = sys.argv[2]

    summary_data = load_json(summary_json)
    recommendations_data = load_json(recommendations_json)

    merged_summary_data = "\n".join(summary_data)
    merged_recommendations_data = "\n".join(recommendations_data)

    summary = []
    recommendations = []

    for line in merged_summary_data.split("\n"):
        if line.startswith("*"):
            summary.append(
                {"type": "bulleted_list", "content": line[1:].strip().replace("*", "")}
            )
        else:
            recommendations.append({"type": "text", "content": line})
    for line in merged_recommendations_data.split("\n"):
        if line.startswith("*"):
            recommendations.append(
                {
                    "type": "bulleted_list",
                    "content": line[1:].strip().replace("*", ""),
                }
            )
        else:
            recommendations.append({"type": "text", "content": line})

    template = [
        {"type": "header", "content": "Weekly Retro"},
        {"type": "text", "content": "\n"},
        {"type": "sub_header", "content": "Summary"},
        *summary,
        {"type": "text", "content": "\n"},
        {"type": "sub_header", "content": "Recommendations"},
        *recommendations,
        {"type": "text", "content": "\n"},
        {"type": "text", "content": "\n"},
        {"type": "sub_header", "content": "How to improve"},
        {"type": "text", "content": "your own input"},
    ]

    print(json.dumps(template, indent=4))


if __name__ == "__main__":
    main()
