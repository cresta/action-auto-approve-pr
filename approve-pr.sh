#!/bin/bash
set -exuo pipefail
ARGS_TO_EXEC=()

if [ -n "${GITHUB_REPOSITORY}" ]; then
  ARGS_TO_EXEC+=("--repo")
  ARGS_TO_EXEC+=("${GITHUB_REPOSITORY}")
else
  echo "GITHUB_REPOSITORY is not set. Exiting..."
  exit 1
fi

if [ -n "${INPUT_COMMENT}" ]; then
  ARGS_TO_EXEC+=("--comment")
  ARGS_TO_EXEC+=("${INPUT_COMMENT}")
fi

if [ -n "${INPUT_BODY}" ]; then
  ARGS_TO_EXEC+=("--body")
  ARGS_TO_EXEC+=("${INPUT_BODY}")
fi

ARGS_TO_EXEC+=("--approve")

if [ -n "${PR_NUMBER}" ]; then
  ARGS_TO_EXEC+=("${PR_NUMBER}")
else
  # Extract the branch name from the ref
  BRANCH_NAME=$(echo "${GITHUB_REF}" | sed -e "s/refs\/heads\///g")
  # Verify the branch name is not empty
  if [ -z "${BRANCH_NAME}" ]; then
    echo "Branch name could not be determined. Exiting..."
    exit 1
  fi
  # Add branch name to review command
  ARGS_TO_EXEC+=("${BRANCH_NAME}")
fi

gh pr review "${ARGS_TO_EXEC[@]}"