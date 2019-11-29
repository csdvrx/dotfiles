while /bin/true; do echo -n `date -u +%Y%m%d_%H%M%S ; echo ";" ; cat /proc/loadavg |awk '{ print $1 " " $2 " " $4}'` ; echo; sleep 30 ; done
