#Add the terminfo sources to .terminfo and /etc/terminfo:
#rm -fr $HOME/.terminfo/s $HOME/.terminfo/t $HOME/.terminfo/x $HOME/.terminfo/73 $HOME/.terminfo/74 $HOME/.terminfo/78
for i in $HOME/.terminfo.src/sixel-tmux* ; do \
        tic -o $HOME/.terminfo $i ; 
        tic $i ;  done
