#!/bin/bash
n=0
while [ $n -le 5 ]
do
  echo $n
  ((n++))
done

# OR

#!/bin/bash

N=3
i=1
sum=0
while [ $i -le $N ]
do
  sum=$((sum + i)) #sum+=num
  i=$((i + 1))
done
echo “Sum is $sum”