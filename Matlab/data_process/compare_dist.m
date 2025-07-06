function [ax, fig] = compare_dist(datas, legends, bandw)
% this function is for plotting distributions 
% Attentions:
%            datas must have dimension M*N, where each column contains a
%            group of data
[~, nc] = size(datas);

if nargin == 1
    legends = {};
    for ii = 1:nc
        legends{end+1} = ['data_', num2str(ii)];
    end
    bandw = 'normal-approx';
elseif nargin == 2
    bandw = 'normal-approx';
end

if nc ~= length(legends)
    error('please provide correct number of legend strings')
end

fig = figure;
set(gcf, 'position', [1 1 1600 600])
hold on 
for ii = 1:nc
    datai = datas(:, ii);
    [f, x] = ksdensity(datai, 'Bandwidth', bandw, 'NumPoints', 500);
    plot(x, f, 'LineWidth', 1.5);
end
legend(legends, 'Location', 'best');
legend('boxoff');

ax = gca;
ax.FontSize = 20;
ax.LineWidth = 3;
% ax.YLim = [0 1];