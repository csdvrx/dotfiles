#!/bin/bash

# for i in `find -maxdepth 1 -type f ; do echo "cat > /mnt/$i << 'EOF'" ; cat  $i ; echo EOF ; echo ; done

FILES=`cat $1 | strings |grep ^cat|grep EOF |grep "<<"|sed -e 's/.*>//g'`

# also echo to stderr to check quickly
FILESNONL=`echo $FILES|tr -d '\n' `
>&2 echo "# refresh-with: $0 $FILESNONL" 
echo "# refresh-with: $0 $FILESNONL" 
# WONTFIX: could gzip/bas64 but it would reduce visibility
for i in $FILES ; do
 echo
 # escaped \EOF or quoted 'EOF', otherwise variables are evaluated and backticks executed 
 echo "cat << 'EOF' > $i"
 cat $i
 echo "EOF"
done
