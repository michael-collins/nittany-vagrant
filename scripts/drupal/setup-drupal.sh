#!/usr/bin/sh
# go to web root
cd /var/www/html/
# vagrant user or passed in
if [ -z $1 ]; then
    owner='vagrant'
  else
    owner=$1
fi
# email address to use or example
if [ -z $2 ]; then
    email='example@example.example'
  else
    email=$2
fi
# find all files that are bash scripts here
IFS=$'\r\n' GLOBIGNORE='*' :; files=($(find /vagrant/scripts/drupal/distros/*.sh))
echo $files
# render the menu options
menuitems() {
  echo "Available options:"
  for i in ${!files[@]}; do
   val=`sed -n '2p' ${files[i]}`
    echo $((i+1)) "$val"
  done
  [[ "$msg" ]] && echo "" && echo "$msg"; :
}

# prompt the user
prompt="Type the number of the option you'd like to run: "
while menuitems && read -rp "$prompt" num && [[ "$num" ]]; do
  (( num > 0 && num <= ${#files[@]} )) || {
      msg="Invalid option: $num"; continue
  }
  # if we got here it means we have valid input
  ((num--)); choice="${files[num]}"
  bash $choice $email
  bash /vagrant/scripts/drupal/drupal-cleanup.sh
  exit
done
