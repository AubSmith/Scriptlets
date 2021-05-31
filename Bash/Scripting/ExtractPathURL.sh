FILE=/home/user/src/prog.c
echo ${FILE#/*/}  # ==> user/src/prog.c
echo ${FILE##/*/} # ==> prog.c
echo ${FILE%/*}   # ==> /home/user/src
echo ${FILE%%/*}  # ==> nil
echo ${FILE%.c}   # ==> /home/user/src/prog

echo
echo
echo

URL=http://myurl.com/app/home/user/src/prog.c
echo ${URL/app#/*/}  # ==> 
echo ${URL##/*/} # ==> 
echo ${URL%/*}   # ==> 
echo ${URL%%/*}  # ==> nil
echo ${URL%.c}   # ==> 