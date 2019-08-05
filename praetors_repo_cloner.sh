#!/bin/bash
ERR = "None"

apt -y install figlet
figlet RepoCloner
echo "|-------------------< By Pra3t0r5 >------------------|"

#echo "Ingresa contraseña Github"
#read -s github_password
#echo "Ingresa usuario Bitbucket"
#read bitbucket_username
#echo "Ingresa contraseña Bitbucket"
#read -s bitbucket_password
github_password="Battleship276"
bitbucket_username="falbertengo"
bitbucket_password="fda18992"

read -p "Usar Scripts Adicionales? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    execute_aditionals="1"
fi

script_path=$(readlink -f -- "$0")
dir=${script_path%/*}
config=$dir"/repositories.conf"

if [ ${execute_aditionals}=="1"] then scripts=$dir"/scripts.sh" fi

while read A ; do
    repo_url=$(echo "$A" | awk -F" " '{print $1}');
    repo_host=$(echo "$A" | awk -F/" " '{print $1}');
    
    git clone ${repo_url}
    if [ $? -ne 0 ]; then ERR="Error clonando ${repo_url##*/}"; fi
    
    case $repo_host in
        github.com)
            #expect "password for"
            #send -- "<Your Password>\n"
        ;;
        bitbucket.org)
            expect "Username for 'https://bitbucket.org':"
            send -- "${bitbucket_username}\n"
            expect "Password for 'https://falbertengo@bitbucket.org':"
            send -- "${bitbucket_password}\n"
        ;;
    esac
    interact
    
    if [ ERR != "None"] then
        echo "${ERR}"
        exit
    else
        echo "${repo_url##*/} clonado exitosamente"
    fi
done < $config;
if

exit

