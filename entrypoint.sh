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
number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")


echo "${pull_request}"

update_review_request() {
  curl -sSL \
    -H "Content-Type: application/json" \
    -H "${AUTH_HEADER}" \
    -H "${API_HEADER}" \
    -X $1 \
    -d "{\"assignees\":[\"guillaumevalverde\"]}" \
    "https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${number}/assignees"
}

if [[ "$action" == "review_requested" ]]; then
  update_review_request 'POST'
elif [[ "$action" == "review_request_removed" ]]; then
  update_review_request 'DELETE'
else
  echo "Ignoring action ${action}"
  exit 0
fi
