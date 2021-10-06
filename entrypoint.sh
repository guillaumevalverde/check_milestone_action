#!/bin/bash
set -eu

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

if [[ -z "$GITHUB_EVENT_NAME" ]]; then
  echo "Set the GITHUB_EVENT_NAME env variable."
  exit 1
fi

if [[ -z "$GITHUB_EVENT_PATH" ]]; then
  echo "Set the GITHUB_EVENT_PATH env variable."
  exit 1
fi

API_HEADER="Accept: application/vnd.github.v3+json; application/vnd.github.antiope-preview+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

action=$(jq --raw-output .action "$GITHUB_EVENT_PATH")
pull_request=$(jq --raw-output .pull_request "$GITHUB_EVENT_PATH")
milestone=$(jq --raw-output .pull_request.milestone "$GITHUB_EVENT_PATH")

echo "pr :"
echo "${pull_request}"
echo "milestone :"
echo "${pull_request}"

pr=`  curl -sSL \
    -H "Content-Type: application/json" \
    -H "${AUTH_HEADER}" \
    -H "${API_HEADER}" \
    -X "GET" \
"https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${number}"`

milestone=`echo "${pr}" | jq '.milestone'`

if [[ "$pr" == null ]]; then
  echo "milestone should be set up"
  exit 1
else
  echo "Ignoring action ${action}"
  exit 0
fi
