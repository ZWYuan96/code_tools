# For matlab
export zwroot="$HOME/Ziwen"

export PATH="$zwroot/matlab_2024/bin:$PATH"
export matlabtoolpth="$zwroot/code_tools/Matlab"
export matlabpth=$(which matlab)
if [ $?==0 ];then
    alias matlab="$matlabpth -nosplash -sd "$matlabtoolpth""
else
    echo 'Warning: Matlab path is not correctly set! Check .bashrc and .bash_aliases'
fi
alias gits='git status'
