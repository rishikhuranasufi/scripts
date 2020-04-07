#!/bin/bash
if [ $# -ne 2 ]
then
    echo "Usage is: $0: <board> <title>"
    echo "For example: sredemo 'Some fucntionality is not working'"
    exit 1
fi

if [ $1 != 'sredemo' -a $1 != 'testing' -a $1 != 'test' ]
then
  echo 'Bad board Name'
  exit 1
fi


if [ $1 = 'sredemo' ]
then
#  listid='5e898dd591be4f25dcf19aad'
   listid='5e898e06dbb51c73a6823ce4'
fi

if [ $1 = 'testing' ]
then
  listid='kdjqlkdhj23o2kj2lq;edjk2edkj2'
fi

if [ $1 = 'test' ]
then
  listid='ekjwlekfjeqlkwelk293294829348'
fi

echo 'List ID as '$listid

# replace spaces in name with + (or else http call will fail)
name=$2
name_with_date="$(date)"
safe_name=$(echo 'AUTOMATED: ' $name ', Created at: ' $name_with_date|tr ' ' '+')
#safe_name=$(echo '$safename $now')
data="name="$safe_name"&due=null&idList="$listid"&token=YOURTOKEN&key=YOURKEY"

# The following curl will throw away response json, and display just status code (200 == two thumbs up!)

curl --data $data https://api.trello.com/1/cards > output.json
cat output.json
shortLink=`cat output.json | jq ".shortLink"`
echo "Short link of card is "$shortLink
id=$(echo $shortLink | sed 's/"//g')
echo "Updated Link is "$id
txt_to_cmt="Issue+has+been+resolved+Sucessfully !!"
safe_comment=$(echo $txt_to_cmt|tr ' ' '+')
echo "Comment is "$txt_to_cmt
curl --data data="id=$id&token=YOURTOKEN&key=Key&text=$safe_comment" https://api.trello.com/1/cards/$id/actions/comments > commentUpdated.json
#last_executed_cmd_op=`cat output.txt`
#echo "Result of executed command "$last_executed_cmd_op
#if [ $last_executed_cmd_op == '200' ]
#then
#       echo 'Card created successfully with code'$last_executed_cmd_op
#else
#       echo 'Automated card creatio failed with error code '$last_executed_cmd_op
#fi
