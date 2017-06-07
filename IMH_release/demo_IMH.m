function [H,tH] = demo_IMH(traindata,testdata,nbits),
addpath ./tSNE
%% settings
codeLen = nbits; %number of hash bits
hammRadius = 2;
m = length(codeLen);

isgnd =1;
anchor_numbers = 400;   %[400,1000];
%% uncommnet the follwing tow lines for the first run
%display('prepare datasets...');
anchor_set = prepare_dataset(traindata,testdata, anchor_numbers);

display([dataset ': ']);
%load(['testbed/',dataset]);


n_anchors = 400;
anchor_nm = ['anchor_' num2str(n_anchors)];
eval(['anchor = anchor_set.' anchor_nm ';']);


%% Initialization
method = 'IMH-tSNE';  % 'IMH-LE'
display([method ': ']);
options = InitOpt(method);


for i = 1 : m
    display(['learn ' num2str(codeLen(i)) ' bits...']);
    options.nbits = codeLen(i);
    options.maxbits = codeLen(i);
    %% hashing
    switch method
        case 'IMH-LE'
            [Embedding,Z_RS,sigma] = InducH(anchor, traindata, options);
            EmbeddingX = Z_RS*Embedding;
            H = EmbeddingX > 0;
            [tZ] = get_Z(testdata, anchor, options.s, sigma);
            tEmbedding = tZ*Embedding;
            tH = tEmbedding > 0;
            clear EmbeddingS EmbeddingX tEmbedding Z_RS tZ;
        case 'IMH-tSNE'
            % get embedding for anchor points
            options.nbits = codeLen(i);
            [Embedding] = tSNEH(anchor, options);
            [Z,~, sigma] = get_Z(traindata, anchor, options.s, options.sigma);
            EmbeddingX = Z*Embedding;
            H = EmbeddingX > 0;
            [tZ] = get_Z(testdata, anchor,  options.s, sigma);
            tEmbedding = tZ*Embedding;
            tH = tEmbedding > 0;
            clear Embedding EmbeddingX tEmbedding Z tZ;
    end
end








