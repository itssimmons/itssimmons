dates=(
  "2025-08-27T15:00:00 -0300"
  "2025-08-28T15:00:00 -0300"
  "2025-08-29T15:00:00 -0300"
  "2025-08-30T15:00:00 -0300"
  "2025-08-31T15:00:00 -0300"
  "2025-09-01T15:00:00 -0300"
  "2025-09-02T15:00:00 -0300"
)

for d in "${dates[@]}"; do
  GIT_COMMITTER_DATE="$d" git commit --amend --no-edit --date "$d"
  git rebase --continue || break
done
