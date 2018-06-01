% Demo for paper "Pattern Mining Saliency" 
% by Yuqiu Kong, Lijun Wang, Xiuping Liu, Huchuan Lu, Xiang Ruan
% To appear the 14th European Conference on Computer Vision (ECCV 2016),
% Amsterdam, Netherlands, 2016

clc;clear;
addpath others;
addpath others/refine;
addpath others/refine/Pc;
addpath others/refine/vgg;

%% initialization
ini_joint;

images = dir(para.imagepath);
imNum = length(images);
suffix = cell(para.multiscalenum,1);

for ii = 1 : imNum
    fprintf('Saliency computing: %d/%d\n',ii,imNum);

    %% read image
    imname = images(ii).name;
    input_im = imread([para.imagepath(1:end-5) imname]);
    [oh,ow,oc] = size(input_im);
    
    if oc~=3
        input_im = cat(3,input_im,input_im,input_im);
    end 
    
    [ input_im,width ] = cutframe( input_im );
    input_im = uint8(input_im);
    
    % segment image into 3 scales
    segim = segmentimage(para,input_im,imname);
    
    imlab = rgb2lab(im2double(input_im));
    [ih,iw,ic] = size(imlab);
    imrgb = reshape(im2double(input_im),[ih*iw,ic]);
    imlab = reshape(imlab,[ih*iw,ic]);
    imlab = colornormalize(imlab);
    
    %% extract superpixel rgb of each scale  
    segrgb = cell(para.multiscalenum,1);
    for jj = 1 : para.multiscalenum
        seg = segim{jj};
        spn = max(seg(:));
        rp = regionprops(seg,'PixelIdxList');
        temprgb = zeros(spn,3);
        templab = zeros(spn,3);
        for kk = 1 : spn
            pix = rp(kk).PixelIdxList;
            temprgb(kk,:) = mean(imrgb(pix,:));
        end
        segrgb{jj} = temprgb;
    end
    %% extrack positive/negtive samples
    % read initial map
    methodnum = length(para.mapdir);
    posind_all = [];
    negind_all = [];
    posfea_all = [];
    negfea_all = [];
    for jj = 1 : methodnum
        mapname = fullfile(para.mapdir{jj},[imname(1:end-4),para.suffix{jj}]);
        initialmap = im2double(imread(mapname));
        [posfea,negfea,posind,negind] = getsamplefea(para,segim,segrgb,initialmap);
        posind_all = [posind_all;posind];
        negind_all = [negind_all;negind];
        posfea_all = [posfea_all;posfea];
        negfea_all = [negfea_all;negfea];
    end
    sampleind = [posind_all;negind_all];
    samplefea = [posfea_all;negfea_all];
    %% create dictionary
    samplefea1 = [segrgb{1};samplefea];
    dictionary = CalculateDictionary(samplefea,para);
    
    %% creat visual word
    % for original image
    % focus on 300-segim
    stats = regionprops(segim{1},'Centroid');
    center = round(vertcat(stats(:).Centroid));
    [texton] = BuildHistograms(para,center,segrgb{1},dictionary);
    oricolist = createVisualWord(center,texton,para);
    oritransaction = creatTransaction(oricolist,para.dictionarySize,para.k);        
    
    % for mining image set
    TransactionFileName = fullfile(para.transacdir,[imname(1:end-4),'.txt']);
    fid = fopen(sprintf(TransactionFileName),'w');   
    nn = length(sampleind)/para.multiscalenum;
    id = repmat([1 2 3],[1,nn]);
    for f = 1:length(samplefea)
        stats = regionprops(segim{id(f)},'Centroid');
        center = round(vertcat(stats(:).Centroid));
        centertemp = center(sampleind{f},:);
        [texton] = BuildHistograms(para,centertemp,samplefea{f},dictionary);
        colist = createVisualWord(centertemp,texton,para);
        creatTransactionFile_mul(colist,fid,para,f,methodnum);        
    end   
    fclose(fid);
    
    %% mine rules
    rule = miningrule(para,imname);
    
    fprintf('Finding saliency patterns /%d\n',ii);
    rulenum = length(rule);
    pos = (para.dictionarySize-1) * para.k + para.k;
    ruleMatrix = zeros(rulenum,pos);
    for jj = 1 : rulenum
        temprule = rule{jj};
        temprule(temprule == pos+1) = [];
        temprule(temprule == pos+2) = [];
        tempvec = getvector(temprule,pos);
        ruleMatrix(jj,:) = tempvec;
    end
    oritrannum = length(oritransaction);
    oritranMatrix = zeros(oritrannum,pos);
    for jj = 1 : oritrannum
        temptran = oritransaction{jj};
        tempvec = getvector(temptran,pos);
        oritranMatrix(jj,:) = tempvec;
    end
    
    matMatrix = ruleMatrix*oritranMatrix';
    rulelength = sum(ruleMatrix,2);
    quaryrule = repmat(rulelength,[1,oritrannum]);
    tempquary = quaryrule - matMatrix;
    tempquary1 = zeros(size(tempquary,1),size(tempquary,2));
    ind = find(tempquary==0);
    tempquary1(ind) = 1;
    binode = sum(tempquary1);
    node = find(binode);
    stats = regionprops(segim{1},'Centroid');
    center = round(vertcat(stats(:).Centroid));
    nodecenter = center(node,:);
    
    %% find saliency seed labels
    % segment image
    spnum = max(segim{1}(:));
    regions_pixel = regionprops(segim{1},'PixelIdxList');
    lbp_vals = computeLBP(input_im,regions_pixel,spnum);
    lbp_vals = (lbp_vals-min(lbp_vals(:)))/(max(lbp_vals(:))-min(lbp_vals(:)));
    seglab = zeros(spnum,ic);
 
    for jj = 1 : spnum
        index = find(segim{1}==jj);
        seglab(jj,:) = sum(imlab(index,:))/length(index);
    end
    % get the seeds position map
    fprintf('Finding saliency seed labels.../%d\n',ii);
    seedlabel = findseedlabel(para,imname,segim{1},node,nodecenter,ih,iw);
    
%     load(fullfile(para.seedlabeldir,[imname(1:end-4),'.mat'])); % seedlabel
    salseednum = length(seedlabel);
    salseedpos = center(seedlabel,:);

    %% delete outlier in salseeds
    fprintf('delete outlier in salseeds.../%d\n',ii)  %% ini_SOD;
    [seedlabel,salseednum] = deleteoutlier(segim{1},seedlabel,salseednum,seglab,para);
    
    %% propagate in lab color space
    fprintf('propagate in lab color space.../%d\n',ii)
    diffaversal = propogationprocess_mul(para,imname,oh,ow,width,segim{1},seglab,seedlabel);  %% ini_SOD
    
    %% propagate in lbp texture space
    fprintf('propagate in lbp texture space.../%d\n',ii)
    diffaversal_lbp = propogationprocess_mul(para,imname,oh,ow,width,segim{1},lbp_vals,seedlabel);  %% ini_SOD
    
    %% refine
    diffaversal1 = normalize(diffaversal);
    diffaversal_lbp1 = normalize(diffaversal_lbp);
    segsal = (diffaversal1+diffaversal_lbp1)/2;
    
    propSal = descendPropagation(seglab,segsal,spnum,3);
    Salpix = computemask1(segim{1},propSal,regions_pixel);
    Sal = refinement(imname,Salpix);
  
    [PC, or, ft, T] = phasecongmono(input_im);
    F = RF(Salpix, 60, 0.4, 5,PC);
    F = normalize(F);
    F1 = (Sal+F)/2;

    finalmask = zeros(oh,ow);
    finalmask(width+1:oh-width,width+1:ow-width) = F1;
    outname = fullfile(para.saliencymap,[imname(1:end-4) '.png']);
    imwrite(finalmask,outname);
end