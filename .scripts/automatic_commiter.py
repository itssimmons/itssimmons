import argparse
from datetime import datetime, timedelta
import os
import random
import re
import subprocess
from zoneinfo import ZoneInfo

arg_parser = argparse.ArgumentParser(
    description="Automatically commit changes to a git repository."
)
arg_parser.add_argument(
    "-b",
    "--begin",
    type=str,
    required=True,
    help="The start date in YYYY-MM-DD format.",
)
arg_parser.add_argument(
    "-u",
    "--until",
    type=str,
    required=True,
    help="The end date in YYYY-MM-DD format.",
)
arg_parser.add_argument(
    "-tz",
    "--timezone",
    type=str,
    required=False,
    default="UTC",
    help="The end date in YYYY-MM-DD format.",
)


def do_change(new_date: datetime = None):
    # fmt: off
    EMOJIS=[
        "😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣",
        "🙂", "🙃", "😉", "😎", "🤓", "🤯", "😤", "😡",
        "😱", "🤔", "🤨", "😏", "😴", "😪", "😵", "🤐",
        "🤑", "🤠", "🤡", "👻", "💀", "🤖", "👾", "🐵",
        "🙈", "🙉", "🙊", "👋", "🤚", "✋", "🖖", "🤌",
        "🤙", "👍", "👎", "👊", "✊", "🤛", "🤜", "🙌",
        "👏", "👐", "🫱", "🫲", "🫳", "🫴", "🦾", "🦿",
        "🦵", "🦶", "🦷", "🦴", "🧠", "🦹", "🦸", "🧙",
    ]
    # fmt: on
    random_idx = random.randrange(len(EMOJIS))

    content = ""
    with open("README.md", "r", encoding="utf-8") as f:
        content = f.read()

    new_content = re.sub(
        r"(?s)<!--START_SECTION:emoji-->.*?<!--END_SECTION:emoji-->",
        f"<!--START_SECTION:emoji-->\n{EMOJIS[random_idx]}\n<!--END_SECTION:emoji-->",
        content,
    )

    with open("README.md", "w", encoding="utf-8") as f:
        f.write(new_content)


def do_commit(d: datetime):
    subprocess.run(["git", "add", "README.md"])
    subprocess.run(["git", "commit", "-m", "Automatic commit"])
    if d:
        date_str = d.strftime("%Y-%m-%d %H:%M:%S %z")
        env = os.environ.copy()
        env["GIT_COMMITTER_DATE"] = date_str
        env["GIT_AUTHOR_DATE"] = date_str
        subprocess.run(
            [
                "git",
                "commit",
                "--amend",
                "--no-edit",
                "--date",
                date_str,
            ],
            env=env,
        )


args = arg_parser.parse_args()

desired_tz = ZoneInfo(args.timezone)
start_date = datetime.strptime(args.begin, "%Y-%m-%d")
start_date = start_date.replace(tzinfo=desired_tz)
stop_date = datetime.strptime(args.until, "%Y-%m-%d")
stop_date = stop_date.replace(tzinfo=desired_tz)

if start_date > stop_date:
    raise ValueError("We cannot go back in time!")

i = 0
while True:
    delta = timedelta(days=i)
    next_date = start_date + delta

    i += 1

    do_change(next_date)
    do_commit(next_date)

    if next_date >= stop_date:
        break
