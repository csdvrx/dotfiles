#!/bin/bash

# for i in `find -maxdepth 1 -type f ; do echo "cat > /mnt/$i << 'EOF'" ; cat  $i ; echo EOF ; echo ; done

echo "# refresh-with: $0 $* "
# wontfix: could gzip/base64 but it would reduce visibility
for i in $* ; do
 echo
 # escaped \EOF or quoted 'EOF', otherwise variables are evaluated and backticks executed 
 echo "cat << 'EOF' > $i"
 cat $i
 echo "EOF"
done
