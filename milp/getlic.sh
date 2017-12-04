#!/bin/bash
for dir in $(ls)
do 
	echo $dir
	cd $dir
	for i in *.m # or whatever other pattern...
	do
  		echo $i
		if ! grep -q Copyright $i
  		then
  			cat ../copyright.txt $i >$i.new && mv $i.new $i
  		fi
	done
	cd ..
done
