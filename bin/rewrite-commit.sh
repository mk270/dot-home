# rewrite_commit_date(commit, date_timestamp)
#
# !! Commit has to be on the current branch, and only on the current branch !!
# 
# Usage example:
#
# 1. Set commit 0c935403 date to now:
#
#   rewrite_commit_date 0c935403
#
# 2. Set commit 0c935403 date to 1402221655:
#
#   rewrite_commit_date 0c935403 1402221655
#
rewrite_commit_date () {
    local commit="$1" date_timestamp="$2"
    local date temp_branch="temp-rebasing-branch"
    local current_branch="$(git rev-parse --abbrev-ref HEAD)"

    if [[ -z "$commit" ]]; then
        date="$(date -R)"
    else
        date="$(date -R --date "@$date_timestamp")"
    fi

    git checkout -b "$temp_branch" "$commit"
    GIT_COMMITTER_DATE="$date" git commit --amend --date "$date" \
		--reuse-message=$commit
    git checkout "$current_branch"
    git rebase "$commit" --onto "$temp_branch"
    git branch -d "$temp_branch"
}