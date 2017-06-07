% This is the main script for evaluate the performance with respect to mean Average 
% Precision (mAP), Precision and Recall.
% Version control:
%     V1.0 2015/06/10

% Author:
%     AdaLuo
%     github: https://github.com/Luoyadan

close all; clear all; clc;
addpath('./utils/');
addpath('../../../datasets');
db_name = 'cifar_10_gist';   % choose one database for evaluation
param.choice = 'evaluation';
loopnbits = [32];   % hash codes length
runtimes = 1;    % modify it more times such as 8 to make the rusult more precise

% load dataset
if strcmp(db_name, 'AR_Maxminnorm_caffe')
    load AR_Maxminnorm_caffe.mat;
    
elseif strcmp(db_name, 'cifar_10_gist')
    load cifar_10_gist.mat;
    
elseif strcmp(db_name, 'FLICKR_25k_caffe_MaxminNorm')
    load FLICKR_25k_caffe_MaxminNorm.mat;

elseif strcmp(db_name, 'cnn_1024d_Caltech-256')
    load cnn_1024d_Caltech-256.mat;
end

param.Ntrain = size(traindata,1);    % define the size of training data 
hashmethods = {'SDH','RDH','KSH', 'ITQ'};    % choose comparing methods
nhmethods = length(hashmethods);

result.mAP = zeros(nhmethods,length(loopnbits)); 
result.Precision = zeros(nhmethods,length(loopnbits));
result.Recall = zeros(nhmethods,length(loopnbits));
result.F1 = zeros(nhmethods,length(loopnbits));

% evaluation begins
for k = 1:runtimes
    fprintf('The %d run time\n\n', k);
    fprintf('Constructing data finished\n\n');
    for i =1:length(loopnbits)
        fprintf('======start %d bits encoding======\n\n', loopnbits(i));
        param.nbits = loopnbits(i);
        for j = 1:nhmethods
             [B, tB] = demo(traindata, testdata, traingnd, testgnd, hashmethods{1, j}, param,cateTrainTest);
             [result.mAP(j,i), result.Precision(j,i), result.Recall(j,i), result.F1(j,i)] = evaluation(B,tB,cateTrainTest)
             result.mAP
             result.Precision
        end
    end
end

% computer average MAP
for j = 1:nhmethods
    for i =1: length(loopnbits)
        tmp = zeros(size(mAP{1, 1}{i, j}));
        for k =1:runtimes
            tmp = tmp+mAP{1, k}{i, j};
        end
        MAP{i, j} = tmp/runtimes;
    end
    clear tmp;
end
     
 
% save result
result_name = ['evaluations_' db_name '_result' '.mat'];
save(result_name, 'precision', 'recall', 'rec', 'MAP', 'mAP', ...
     'hashmethods', 'nhmethods', 'loopnbits');
 
