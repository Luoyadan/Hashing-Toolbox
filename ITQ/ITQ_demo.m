function [B,tB] = ITQ_demo(traindata,testdata,nbits),
addpath('./eval/');
addpath('./PCAH/');
fprintf('......%s start...... \n\n', 'PCA-ITQ');
ITQparam.nbits = nbits;
% ITQparam =  trainPCAH(double([traindata;testdata]), ITQparam);
%ITQparam =  trainPCAH(train_data, ITQparam);
ITQparam = trainITQ(double([traindata;testdata]), ITQparam);
[~, B] = compressITQ(traindata, ITQparam);
[~, tB] = compressITQ(testdata, ITQparam);
%[B_db, ~] = compressITQ(db_data, ITQparam);
end