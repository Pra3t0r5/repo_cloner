#!/bin/bash
ERR="None"

apt -y install figlet
figlet RepoCloner
echo "|-------------------< By Pra3t0r5 >------------------|"

echo "Ingresa usuario Github"
read github_username
echo "Ingresa contraseña Github"
read -s github_password
echo "Ingresa usuario Bitbucket"
read bitbucket_username
echo "Ingresa contraseña Bitbucket"
read -s bitbucket_password

read -p "Usar Scripts Adicionales? (Y/N) " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
    execute_aditionals="0"
else
    execute_aditionals="1"
fi

script_path=$(readlink -f -- "$0")
dir=${script_path%/*}
config=$dir"/repositories.conf"
custom_scripts=$dir/"customscripts"

while read -r A ; do
    repo_url=$(echo "$A" | awk -F" " '{print $1}');
    repo_host=$(echo "$A" | awk -F/" " '{print $1}');
    repo_name="${repo_url##*/}"
    
    case "$repo_host" in
        *github.com*)
            username="${github_username}"
            password="${github_password}"
            host="github.com"
            git clone https://"${username}":"${password}"@"${host}"/"${username}"/"${repo_name}"
        ;;
        *bitbucket.org*)
            username="${bitbucket_username}"
            password="${bitbucket_password}"
            host="bitbucket.org"
            file_path=$(echo ${repo_url} | cut -d@ -f2 | cut -d/ -f2- | cut -d? -f1)
            git clone https://"${username}":"${password}"@bitbucket.org/"${file_path}"
        ;;
    esac
    
    if [ $? -ne 0 ] ; then ERR="ERROR CLONANDO '${repo_url##*/}'" ; fi
    
    if [ "$ERR" != "None" ] ; then
        echo "${ERR}"
    else
        echo "${repo_url##*/} CLONADO EXITOSAMENTE" ;
    fi
done < "$config";

if [ ${execute_aditionals} == "1" ] ; then
    for each in ${custom_scripts}/*.* ; do bash $each ; done
else
    echo "NO SE EJECUTARAN SCRIPTS ADICIONALES"
fi

echo "FINALIZADO"

exit

