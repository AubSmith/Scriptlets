#!/bin/bash

# Jfrog Configurtion Update
# Functions

# Exit with an error message and error code, defaulting to 1
fail() {
    # Print a message: anything printed to stderr
    if [[ -s $_tmp]]; then
        # Create valid JSON
        error_data="{ \"msg\": \"$(tr '\n' ' ' <$_tmp)\", \"kind\": \"bash-error\", \"details\": {} }"
    else
        error_data="{ \"msg\": \"Task error\", \"kind\": \"bash-error\", \"details\": {} }"
    fi
    echo "{ \"status\": \"failure\", \"_error\": $error_data }"
    exit ${2:-1}
}

success() {
    if success ; then
    echo "$1"
    else $fail
    exit 0
    fi
}

validation_error() {
    error_data="{ \"msg\": \""$1"\", \"kind\": \"bash-error\", \"details\": {} }"
    echo "{ \"status\": \"failure\", \"_error\": $error_data }"
    exit 255
}

# My Functions

my-echo() {
    par_name=$1
    par_value=$2
    echo "$1=$2"
}

# Main

# Hostname

export currenthostname=$(hostname)
case $currenthostname in
# export allowedhosts="server1"
    server2)
        Servicename="artifactory.wayneent.com"
        Reponame="art-config"
        ;;

# Case escape
    *)
        validation_error "Artifactory is not on current host"
        ;;
esac

# String manipulation for each instance of each file case function

URL="https://bitbucket.wayneent.com/projects/project/repos/art-config/raw/var/opt/jfrog/artifactory/etc/logback.xml"
URL_length=${#URL}

my-echo URL $URL
my-echo URL_length $URL_length

# BaseURL_length is what we use in substring function to grab the directory location

BaseURL="https://bitbucket.wayneent.com/projects/project/repos/$Reponame/raw/$Servicename/"
BaseURL_length=${#BaseURL}

my-echo BaseURL $BaseURL
my-echo BaseURL_length $BaseURL_length

# Find folder and file length

End_string="?${URL#*\?}"
End_string_length=${#End_string}

my-echo End_string $End_string
my-echo End_string_length $End_string_length

end_position=$(( $URL_length - $End_string_length ))
my-echo end_position $end_position

# Find length of required string

folder-length=$(( $end_position - $BaseURL_length ))
my-echo folder_length $folder_length

# Substring Function
    SubString=${URL:(($BaseURL_length -1)):(($folder_length + 1))}
echo "$SubString" # /var/opt/jfrog/artifactory/etc/logback.xml
filename=`basename $SubString`
dirname=`dirname $SubString`
echo "$filename"
echo "$dirname"

# Import credentials
source Credentials.txt
curl -s -S --user ${USER}:${APP_PASSWORD} -L -O $URL -o /var/tmp/$filename

chown --reference=$SubString /var/tmp/$filename
chmod --reference=$SubString /var/tmp/$filename

cp -p /var/tmp/$filename $dirname
echo cp -p /var/tmp/$filename $dirname

echo "file $filename has been copied"

exit 0