# For matlab
export zwroot="$HOME/Ziwen"

export PATH="$zwroot/Matlab/bin:$PATH"
export matlabtoolpth="$zwroot/code_tools/Matlab"
export matlabpth=$(which matlab)
if [ $?==0 ];then
    alias matlab="$matlabpth -sd "$matlabtoolpth""
else
    echo 'Warning: Matlab path is not correctly set! Check .bashrc and .bash_aliases'
fi

# For git
alias gits='git status'

# For globus
alias globus="source $HOME/Ziwen/Globus/globusconnectpersonal"
