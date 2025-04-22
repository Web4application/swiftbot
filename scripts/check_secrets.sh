# Check if secrets are available

set -x
echo "GITHUB_BASE_REF: ${GITHUB_BASE_REF:-}"
echo "GITHUB_HEAD_REF: ${GITHUB_HEAD_REF:-}"

check_secrets()
{
  # GitHub Actions: Secrets are available if we're not running on a fork.
  # See https://help.github.com/en/actions/automating-your-workflow-with-github-actions/using-environment-variables
  # TODO- Both GITHUB_BASE_REF and GITHUB_HEAD_REF are set in master repo
  # PRs even thought the docs say otherwise. They are not set in cron jobs on master.
  # Investigate how do to distinguish fork PRs from master repo PRs.
  if [[ -n "${GITHUB_WORKFLOW:-}" ]]; then
    return 0
  fi
  return 1
}
