
% setup non cartisan processing toolbox
matlab_root = '/home/ziwen_ubuntu/Ziwen/Matlab_tools';
non_carisan_toolbox_setup_pth = fullfile(matlab_root, "non_cartisan_processing/irt/setup.m");
run(non_carisan_toolbox_setup_pth);

addpath(fullfile(matlab_root, 'data_process'))

%
% add coder toolbox, which has been installed but not ad