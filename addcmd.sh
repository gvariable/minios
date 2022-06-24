#! /bin/zsh
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
DEFAULT='\033[0m'

wd=$(pwd)
echo "Current Working Directory is ${BLUE}$wd${DEFAULT}"

if [[ ! -e lib64/ld-linux-x86-64.so.2 ]];then
  echo "Dynamic linker ${GREEN}ld-linux-x86-64.so.2${DEFAULT} doesn't exist in ${BLUE}${wd}/lib64${DEFAULT}, copying it into ${BLUE}${wd}/lib64${DEFAULT}!"
  mkdir "${wd}/lib64"
  cp /lib64/ld-linux-x86-64.so.2 ${wd}/lib64
fi

# Add dependencies to working directory and keep original fs format!
add_dep2wd() {
  # copying cmd to working directory
  echo "Copying ${BLUE}$1${DEFAULT} to Working Directory ${BLUE}$wd$1${DEFAULT}"
  dirname=`dirname $wd$1`
  if [[ ! -d $dirname ]];then
    echo "Directory ${BLUE}$dirname${DEFAULT} ${RED}DOES NOT EXIST${DEFAULT}, create one instead!"
    mkdir -p $dirname
  fi
  cp $1 $wd$1

	dependencies=$(ldd $1 | awk '{if($3 != "") print $3}') # get dependencies for cmd $1
	if [[ $? == 0 ]]; then # no errors occur then continue
		echo "Dependencies for ${BLUE}$1${DEFAULT} is: \n${PURPLE}$dependencies${DEFAULT}"
		dependencies=($(echo $dependencies))

		for dep in ${dependencies[@]}; do
			dirname=$(echo $wd$(dirname $dep))
			basename=$(echo $wd$dep)
			if [[ ! -d $dirname ]]; then
				echo "Directory ${BLUE}$dirname${DEFAULT} ${RED}DOES NOT EXIST${DEFAULT}, create one instead!"
				mkdir -p $dirname
			fi

			if [[ ! -e $basename ]]; then
				echo "Copying ${PURPLE}$dep${DEFAULT} to ${BLUE}$dirname${DEFAULT}"
				cp $dep $dirname
			fi
		done
	fi
}

for cmd in "$@"; do
	cmd_path=$(/usr/bin/which $cmd)
	if [[ $? == 0 ]]; then
		echo "Processing cmd ${GREEN}$cmd${DEFAULT} at path ${BLUE}$cmd_path${DEFAULT}"
		add_dep2wd $cmd_path
	else
		echo "Error occurred when processing cmd ${GREEN}$cmd${DEFAULT}, cmd ${GREEN}$cmd${DEFAULT} ${RED}NOT FOUND${DEFAULT}, SKIP INSTEAD!"
	fi
done

