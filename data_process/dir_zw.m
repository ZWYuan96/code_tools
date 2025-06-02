function paths_out = dir_zw(path_exp)
    paths = {dir(path_exp).name}';
    fn_out = paths(~(strcmp(paths, '.') + strcmp(paths, '..')));
    paths_out = cell(size(fn_out));
    [a,b,c] = fileparts(path_exp);
    for ii = 1:length(fn_out)
        paths_out{ii} = fullfile(a, fn_out{ii});
    end
end