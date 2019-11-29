#!/bin/sh

# printf for no newline
echo -n "C:"
/bin/df -h /|/usr/bin/awk 'END{ printf $4 }'
echo -n " S:"
/bin/df -h /s|/usr/bin/awk 'END{ printf $4 }'
