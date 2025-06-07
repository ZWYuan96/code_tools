fprintf('Welcome! \nIt is now %s \n', string(datetime))

fprintf('\n++++++++++++++++ Loading starts ++++++++++++++++++\n')
cp = mfilename('fullpath');
[a, b, c] = fileparts(cp);

% setup irt
[~, setup_pth] = system('find . -type f -wholename "*non_cartisan_processing/irt/setup.m"');
run(setup_pth(1:end-1))

% add customized functions
addpath(genpath(fullfile(a, 'data_process')))

fprintf('All custom functions are added to path.\n')


fprintf('++++++++++++++++ Loading ends ++++++++++++++++++\n')