function [anchor_set] = prepare_dataset(traindata, testdata, an)
% dataset is stored in a row-wise matrix
%%
traindata = double(traindata);
testdata = double(testdata);

% an = [400,1000];
for ix = 1 : length(an)
    n_anchors = an(ix);
    anchor_nm = ['anchor_' num2str(n_anchors)];
    eval(['[~,' anchor_nm '] = litekmeans(traindata, n_anchors, ''MaxIter'', 10);']);
%     eval(['[~,' anchor_nm ',~, sumD, D] = litekmeans(traindata, n_anchors, ''MaxIter'', 10);']);
    eval(['anchor_set.' anchor_nm '= ' anchor_nm, ';']);
%     eval(['anchor_set.' anchor_nm '_Dis = D;']);
end


end
