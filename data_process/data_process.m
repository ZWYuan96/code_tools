classdef data_process < dynamicprops
    properties
        % project -> experiment -> data
        base; % where data object is stored
        project_name; % object file name
        experiments = struct;
        multi_e = 0; % toggle to allow adding duplicated file paths

        % data_paths = {'Init'};
    end

    methods
        %% Class file admin section
        function obj = data_process(obj_path, namei)
            obj.base = obj_path; 
            obj.project_name = namei;
            if ~exist([fullfile(obj_path, namei), '.mat'], "file")
                obj.resave
            else
                warning('Object has been constructed before, loading into the old object ... ')
                a = load([fullfile(obj_path, namei), '.mat']);
                obj = a.obj;
            end
        end

        function resave(obj)
            if exist(obj.base, 'dir') == 0 
                mkdir(obj.base)
            end
            save([fullfile(obj.base, obj.project_name), '.mat'], 'obj');
        end
        
        %% Data path and load ing section
        function obj = append_all(obj, exp_name, data_name, data_path)
            if nargin == 1
                fprintf('Nothing happend! Saving data object ... \n');
                obj.resave;
                return
            elseif nargin == 2
                if ischar(exp_name) || isstring(exp_name)
                    exp_name = char(exp_name);
                    if ~isfield(obj.experiments, exp_name)
                        obj.experiments.(exp_name) = struct;
                    end
                    return
                    
                else
                    error('Experiment needs to be a string or char!')
                end
            elseif nargin == 3
                assert(isa(exp_name, 'string') + isa(exp_name, 'char'));
                assert(isa(data_name, 'string') + isa(data_name, 'char'));
                if ~isfield(obj.experiments, exp_name)
                    obj.experiments.(exp_name) = struct;
                end
                if isfield(obj.experiments.(exp_name), data_name)
                    inp = input('The data structure is existing, do you want to override? Type 0 for No, 1 for Yes: \n');
                    if inp 
                        obj.experiments.(exp_name).(data_name) = struct('data_path', {1}, 'data_content', [1]);
                        obj.experiments.(exp_name).(data_name).data_path = {};
                        obj.experiments.(exp_name).(data_name).data_content = {};
                    end
                else
                    obj.experiments.(exp_name).(data_name) = struct('data_path', {1}, 'data_content', [1]);
                    obj.experiments.(exp_name).(data_name).data_path = {};
                    obj.experiments.(exp_name).(data_name).data_content = {};
                end
            elseif nargin == 4
                assert(isa(exp_name, 'string') + isa(exp_name, 'char'));
                assert(isa(data_name, 'string') + isa(data_name, 'char'));
                assert(isa(data_path, 'string') + isa(data_path, 'char') + isa(data_path, 'cell'));
                % adding data_path
                if ~isfield(obj.experiments, exp_name)
                    obj = obj.append_all(exp_name, data_name);
                end
                if ~isfield(obj.experiments.(exp_name), data_name)
                    obj = obj.append_all(exp_name, data_name);
                end

                obj = obj.append_paths(data_path, exp_name, data_name);
            end            
        end

        function obj = append_dat(obj, exp_name, case_name)
        % this only work when experiment is added and case is not added
            assert(isfield(obj.experiments, exp_name))
            obj.experiments.(exp_name).(case_name) = struct('data_path', 1, 'data_content', 1);
            obj.experiments.(exp_name).(case_name).data_path = {};
            obj.experiments.(exp_name).(case_name).data_content = {};
        end
        
        function obj = append_paths(obj, data_paths, exp, dat)
            assert(isfield(obj.experiments, exp))
            assert(isfield(obj.experiments.(exp), dat))

            if ischar(data_paths) || length(data_paths) == 1
                if iscell(data_paths)
                    data_paths = data_paths{1};
                end
                duplicate_e = sum(strcmp(obj.experiments.(exp).(dat).data_path, data_paths));
                check_e = obj.multi_e*duplicate_e;
                if  check_e || ~duplicate_e
                    obj.append_one_path(data_paths, exp, dat);
                    return
                else
                    warning("The following path does not exist: %s ..... skipping it ... \n", data_paths);
                    return
                end
            else 
                n_item = length(data_paths);
                for ii = 1:n_item
                    pathi = data_paths{ii};
                    if ~exist(pathi)
                        warning("The following path does not exist: %s ..... skipping it ... \n", pathi);
                        continue
                    else
                        % check if added
                        duplicate_e = sum(strcmp(obj.experiments.(exp).(dat).data_path, pathi));
                        if  duplicate_e == 1 && obj.multi_e == 0
                            warning('The following path is duplicated: %s ..... skipping it ... \n', pathi);
                            continue
                        else
                            obj.append_one_path(pathi, exp, dat);
                        end
                    end
                end
            end
        end

        function obj = append_one_path(obj, data_pths, exp, dat)

            % if nargin == 1
            %    error('++++++++++++++++++Please provide the paths that you want to keep track of ++++++++++++++++++++') 
            % elseif nargin > 2
            %     error('+++++++++++++++++Please fold your paths into a cell array ++++++++++++++++++++++++')
            % end
            if iscell(data_pths)
                assert(length(data_pths) == 1) 
                data_pths = data_pths{1};
            end
            assert(isa(data_pths, 'char')+isa(data_pths, 'string'))    
            if ~exist(data_pths)
                error('Please provide a valid path!')
            end
            data_pths = char(data_pths);
            dataf = strcmp(obj.experiments.(exp).(dat).data_path, data_pths);
            if isempty(obj.experiments.(exp).(dat).data_path)
                obj.experiments.(exp).(dat).data_path{end+1, 1} = data_pths;
                obj.resave
                return
            end

            if sum(dataf)
                warning('Data path is already added!')
                obj.resave;
                return
            else
                obj.experiments.(exp).(dat).data_path{end+1, 1} = data_pths;
                obj.resave
                return
            end

            % elseif iscell(data_pths)
            %     exist_e = cellfun(@exist, data_pths);
            %     if ~all(exist_e)
            %         error('Provided pathes have non-existing item: %s \n', data_pths{~exist_e})
            %     else
            %         if isempty(obj.data_paths)
            %             obj.data_paths(1:length(data_pths), 1) = data_pths;
            %             obj.resave
            %             return
            %         end
            % 
            %         % check if has been added
            %         double_e = cellfun(@obj.check_path, data_pths);
            %         double_e = [double_e{:}]';
            %         if any(double_e)
            %             warning('These paths have previously been added: %s \n', data_pths{double_e})
            %         end
            %         add_e = ~double_e;
            %         if ~isempty(find(add_e, 1)) 
            %             obj.data_paths(end+1:end+length(find(add_e, 1))) = data_pths(add_e);
            %         end
            %     end
            

        end

        % function e = check_path(obj, pathi)
        %     ff = strfind(obj.data_paths, pathi);
        %     e = any([ff{:}]');
        % end
        function obj = append_content(obj, contents, exp, dat)
            obj.experiments.(exp).(dat).data_content = contents;
        end

        function obj = table_generate(obj, exp, dat)
            obj.experiments.(exp).(dat).out_table = table;
            for ii = 1:length(obj.experiments.(exp).(dat).data_content)
                targeti = obj.experiments.(exp).(dat).data_content{ii};
                targeti0 = strrep(targeti, '.', '-');
                obj.experiments.(exp).(dat).out_table.(targeti0) = obj.load_data(obj.experiments.(exp).(dat).data_path, ...
                    targeti);
            end
        end

        function readout = load_data(obj, paths, target_exps)
            % input a cell array of paths and extract targetted fields
            % stored in matlab mat file
            % target_exps example: a.b.c.d
            % target_name = strrep(target_exps, '.', '-');
            
            readout = cell(size(paths));
            for ii = 1:length(readout)
                readi = obj.load_one_data(paths{ii}, target_exps);
                readout{ii} = readi;
            end

        end

        function readout = load_one_data(obj, single_path, target_exp)
            % currently only supports matlab mat file loading
            readin = load(single_path);
            targets = split(target_exp, '.');
            readi = readin.(targets{1});
            for ii = 2:length(targets)
                if isfield(readi, targets{ii})
                    readi = readi.(targets{ii});
                else
                    readout = NaN;
                    return
                end
            end
            readout = readi;
            
        end
        
        %% Plotting section
        

    end

end

