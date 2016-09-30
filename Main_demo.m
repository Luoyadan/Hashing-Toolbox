% This is the main script for evaluate the performance with respect to mean Average 
% Precision (mAP), Precision and Recall.
% Version control:
%     V1.0 2015/06/10

% Author:
%     AdaLuo
%     github: https://github.com/Luoyadan

close all; clear all; clc;
addpath('./utils/');
addpath ../dataset
% db_name = 'cifar_10_gist';
%db_name = 'AR_Maxminnorm_caffe';
%db_name = 'FLICKR_25k_caffe_MaxminNorm';
%db_name = 'gist_512d_Caltech-256';
db_name = 'UQ';
param.choice = 'evaluation';
result.rec =[];
result.pre =[];
loopnbits = [32 64 96 128];
%32 64 96 128
runtimes = 1;    % modify it more times such as 8 to make the rusult more precise

choose_times = 1;    % k is the times of run times to show for evaluation



% load dataset
if strcmp(db_name, 'AR_Maxminnorm_caffe')
    load AR_Maxminnorm_caffe.mat;
    
elseif strcmp(db_name, 'cifar_10_gist')
    load cifar_10_gist.mat;
    
elseif strcmp(db_name, 'videohash')
    load videohash.mat;
elseif strcmp(db_name, 'FLICKR_25k_caffe_MaxminNorm')
    load FLICKR_25k_caffe_MaxminNorm.mat;
 
elseif strcmp(db_name, 'cnn_1024d_Caltech-256')
    load cnn_1024d_Caltech-256.mat;
elseif strcmp(db_name, 'UQ')
    load UQ_label.mat;    

elseif strcmp(db_name, 'Vine')
    load Vine.mat;

end
% ix=randsample(10000:size(traindata,1),size(traindata,1)-10000);
% traindata = traindata(ix,:);
% traingnd = traingnd(ix,:);
%  cateTrainTest = bsxfun(@eq,traingnd, testgnd');

param.Ntrain = size(traindata,1);    % The number of retrieved samples: Recall-The number of retrieved samples curve
% wSELVE can be added to hashmethods, but it need run in matlab12 or blow
hashmethods = {'LSH','ITQ','IMH','SGH'};
%,'LSH','ITQ','IMH','SGH'
nhmethods = length(hashmethods);

% result.mAP = zeros(nhmethods,length(loopnbits));
% % result.Precision = zeros(nhmethods,length(loopnbits));
% % result.Recall = zeros(nhmethods,length(loopnbits));
% result.F1 = zeros(nhmethods,length(loopnbits));

profile on

for k = 1:runtimes
    fprintf('The %d run time\n\n', k);
    fprintf('Constructing data finished\n\n');
    for i =1:length(loopnbits)
        fprintf('======start %d bits encoding======\n\n', loopnbits(i));
        param.nbits = loopnbits(i);
        for j = 1:nhmethods
             [B, tB] = demo(traindata, testdata, traingnd, testgnd, hashmethods{1, j}, param,cateTrainTest);
             [result.PreTopK{j,i},result.mAP{j,i}, result.Precision{j,i}, result.Recall{j,i}, result.F1{j,i} ] = evaluation(B,tB,cateTrainTest);
            
             result.mAP
             result.PreTopK
        end
    end
end

profile report
% % average MAP
% for j = 1:nhmethods
%     for i =1: length(loopnbits)
%         tmp = zeros(size(mAP{1, 1}{i, j}));
%         for k =1:runtimes
%             tmp = tmp+mAP{1, k}{i, j};
%         end
%         MAP{i, j} = tmp/runtimes;
%     end
%     clear tmp;
% end
    

% save result
 result_name = ['evaluations_' db_name '_result' '.mat'];
 save(result_name, 'result', ...
     'hashmethods', 'nhmethods', 'loopnbits');
% 
% % plot attribution
% line_width = 2;
% marker_size = 8;
% xy_font_size = 14;
% legend_font_size = 12;
% linewidth = 1.6;
% title_font_size = xy_font_size;
% 
% %% show precision vs. recall , i is the selection of which bits.
% figure('Color', [1 1 1]); hold on;
% 
% for j = 1: nhmethods
%     p = plot(recall{choose_times}{choose_bits, j}, precision{choose_times}{choose_bits, j});
%     color = gen_color(j);
%     marker = gen_marker(j);
%     set(p,'Color', color)
%     set(p,'Marker', marker);
%     set(p,'LineWidth', line_width);
%     set(p,'MarkerSize', marker_size);
% end
% 
% str_nbits =  num2str(loopnbits(choose_bits));
% h1 = xlabel(['Recall @ ', str_nbits, ' bits']);
% h2 = ylabel('Precision');
% title(db_name, 'FontSize', title_font_size);
% set(h1, 'FontSize', xy_font_size);
% set(h2, 'FontSize', xy_font_size);
% axis square;
% hleg = legend(hashmethods);
% set(hleg, 'FontSize', legend_font_size);
% set(hleg,'Location', 'best');
% set(gca, 'linewidth', linewidth);
% box on; grid on; hold off;
% 
% %% show recall vs. the number of retrieved sample.
% figure('Color', [1 1 1]); hold on;
% %posEnd = 8;
% for j = 1: nhmethods
%     pos = param.pos;
%     recc = rec{choose_times}{choose_bits, j};
%     %p = plot(pos(1,1:posEnd), recc(1,1:posEnd));
%     p = plot(pos(1,1:end), recc(1,1:end));
%     color = gen_color(j);
%     marker = gen_marker(j);
%     set(p,'Color', color)
%     set(p,'Marker', marker);
%     set(p,'LineWidth', line_width);
%     set(p,'MarkerSize', marker_size);
% end
% 
% str_nbits =  num2str(loopnbits(choose_bits));
% set(gca, 'linewidth', linewidth);
% h1 = xlabel('The number of retrieved samples');
% h2 = ylabel(['Recall @ ', str_nbits, ' bits']);
% title(db_name, 'FontSize', title_font_size);
% set(h1, 'FontSize', xy_font_size);
% set(h2, 'FontSize', xy_font_size);
% axis square;
% hleg = legend(hashmethods);
% set(hleg, 'FontSize', legend_font_size);
% set(hleg,'Location', 'best');
% box on; grid on; hold off;
% 
% %% show precision vs. the number of retrieved sample.
% figure('Color', [1 1 1]); hold on;
% posEnd = 8;
% for j = 1: nhmethods
%     pos = param.pos;
%     prec = pre{choose_times}{choose_bits, j};
%     %p = plot(pos(1,1:posEnd), recc(1,1:posEnd));
%     p = plot(pos(1,1:end), prec(1,1:end));
%     color = gen_color(j);
%     marker = gen_marker(j);
%     set(p,'Color', color)
%     set(p,'Marker', marker);
%     set(p,'LineWidth', line_width);
%     set(p,'MarkerSize', marker_size);
% end
% 
% str_nbits =  num2str(loopnbits(choose_bits));
% set(gca, 'linewidth', linewidth);
% h1 = xlabel('The number of retrieved samples');
% h2 = ylabel(['Precision @ ', str_nbits, ' bits']);
% title(db_name, 'FontSize', title_font_size);
% set(h1, 'FontSize', xy_font_size);
% set(h2, 'FontSize', xy_font_size);
% axis square;
% hleg = legend(hashmethods);
% set(hleg, 'FontSize', legend_font_size);
% set(hleg,'Location', 'best');
% box on; grid on; hold off;
% 
% %% show mAP. This mAP function is provided by Yunchao Gong
% figure('Color', [1 1 1]); hold on;
% for j = 1: nhmethods
%     map = [];
%     for i = 1: length(loopnbits)
%         map = [map, MAP{i, j}];
%     end
%     p = plot(log2(loopnbits), map);
%     color=gen_color(j);
%     marker=gen_marker(j);
%     set(p,'Color', color);
%     set(p,'Marker', marker);
%     set(p,'LineWidth', line_width);
%     set(p,'MarkerSize', marker_size);
% end
% 
% h1 = xlabel('Number of bits');
% h2 = ylabel('mean Average Precision (mAP)');
% title(db_name, 'FontSize', title_font_size);
% set(h1, 'FontSize', xy_font_size);
% set(h2, 'FontSize', xy_font_size);
% axis square;
% set(gca, 'xtick', log2(loopnbits));
% set(gca, 'XtickLabel', {'8', '16', '32', '64', '128'});
% set(gca, 'linewidth', linewidth);
% hleg = legend(hashmethods);
% set(hleg, 'FontSize', legend_font_size);
% set(hleg, 'Location', 'best');
% box on; grid on; hold off;
