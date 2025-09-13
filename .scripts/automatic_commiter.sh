FROM=\0
TO=\0

Emojis=(
  "😀" "😃" "😄" "😁" "😆" "😅" "😂" "🤣"
  "🙂" "🙃" "😉" "😎" "🤓" "🤯" "😤" "😡"
  "😱" "🤔" "🤨" "😏" "😴" "😪" "😵" "🤐"
  "🤑" "🤠" "🤡" "👻" "💀" "🤖" "👾" "🐵"
  "🙈" "🙉" "🙊" "👋" "🤚" "✋" "🖖" "🤌"
  "🤙" "👍" "👎" "👊" "✊" "🤛" "🤜" "🙌"
  "👏" "👐" "🫱" "🫲" "🫳" "🫴" "🦾" "🦿"
  "🦵" "🦶" "🦷" "🦴" "🧠" "🦹" "🦸" "🧙"
)
emojis_length=$(( ${#Emojis[@]} - 1 ))

do_change() {
  random_idx=$(( RANDOM % $emojis_length ))
  emoji=${Emojis[$random_idx]}

  sed -i '' "/<!--START_SECTION:emoji-->/,/<!--END_SECTION:emoji-->/c\\
  <!--START_SECTION:emoji-->\\
  ${emoji}\\
  <!--END_SECTION:emoji-->\\
" README.md
}

commit_dates=()

while getopts "f:t:" opt; do
  case $opt in
    f)
      FROM=${OPTARG}
      ;;
    t)
      TO=${OPTARG}
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND - 1))

from_days=$(gdate -d $FROM +"%-d")
to_days=$(gdate -d $TO +"%-d")

diff=$(($to_days - $from_days))
i=0

while [ $i -le $diff ]; do
  new_date=$(gdate -d "$FROM +$i days" +"%FT12:00:00")
  commit_dates+=("$new_date -0300")
  
  ((i++))
done

for d in "${commit_dates[@]}"; do
  do_change
  git add README.md
  git commit -m 'Update README.md'
  GIT_COMMITTER_DATE="$d" git commit --amend --no-edit --date "$d"
done

exit 0
