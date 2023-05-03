#!/bin/bash
set -exuo pipefail
ARGS_TO_EXEC=()

if [ -n "${GITHUB_REPOSITORY-}" ]; then
  ARGS_TO_EXEC+=("--repo")
  ARGS_TO_EXEC+=("${GITHUB_REPOSITORY}")
else
  echo "GITHUB_REPOSITORY is not set. Exiting..."
  exit 1
fi

if [ -n "${INPUT_BODY}" ]; then
  ARGS_TO_EXEC+=("--body")
  ARGS_TO_EXEC+=("${INPUT_BODY}")
fi

ARGS_TO_EXEC+=("--approve")

if [ -n "${PR_NUMBER}" ]; then
  ARGS_TO_EXEC+=("${PR_NUMBER}")
else
  # If the branch name looks like "refs/pull/ID/merge", extract the ID part
  PR_NUMBER=$(echo "${GITHUB_REF}" | sed -n -e "s/refs\/pull\/\([0-9]*\)\/merge/\1/p")
  # Verify the PR number is not empty
  if [ -z "${PR_NUMBER}" ]; then
    echo "PR number could not be determined. Exiting..."
    exit 1
  fi
  # Add the PR number to the args
  ARGS_TO_EXEC+=("${PR_NUMBER}")
fi

gh pr review "${ARGS_TO_EXEC[@]}"