varname=value
echo $varname

# export to export to subshell

env
su - user

echo $user

color=red
echo $color

bash

echo $color
exit
export color=blue
echo $color

bash
echo $color