% initialization

para.omrootdir = './input/initialmap/';
para.methodname = 'CA';
para.omdir{1} = 'CA';
para.suffix{1} = '.jpg';
para.mapdir{1} = fullfile(para.omrootdir,para.omdir{1});

para.rootdir = '../PMcode/';
para.datadir = './DATA/';
if ~exist(para.datadir)
    mkdir(para.datadir);
end
para.transacdir = fullfile(para.datadir,para.methodname,'transaction');
if ~exist(para.transacdir)
    mkdir(para.transacdir);
end
para.ruledir = fullfile(para.datadir,para.methodname,'rule');
if ~exist(para.ruledir)
    mkdir(para.ruledir);
end
para.seedlabeldir = fullfile(para.datadir,para.methodname,'seedlabel');
if ~exist(para.seedlabeldir)
    mkdir(para.seedlabeldir);
end
para.saliencymap = fullfile(para.datadir,para.methodname,'saliencymap');
if ~exist(para.saliencymap)
    mkdir(para.saliencymap);
end

para.numTopActivation = 20;

para.imagepath = './input/testimage/*.jpg';

run /media/iiau/linux_file/kyq/retrivel_saliency/PMcode_final/vlfeat-0.9.20-bin/vlfeat-0.9.20/toolbox/vl_setup

para.multiscalenum = 3;
para.seg = [300 20;
            400 25;
            500 30];
para.segdir = './segment/';
if ~exist(para.segdir)
    mkdir(para.segdir);
end
for i = 1 : para.multiscalenum
    segoutdir = fullfile(para.segdir,num2str(i));
    if ~exist(segoutdir)
        mkdir(segoutdir)
    end
end
para.posnum = 20;
para.negnum = 40;

para.thresh1 = 0.5;
para.thresh2 = 0.3;

para.suppset = [1 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1 0.08 0.06 0.04 0.02 0.01];

para.confid = 90;
para.minrule = 1000;
para.minLength = 3;
para.maxLength = 6;
para.dictionarySize = 300;
para.neighborscale = 5;

para.d_min = 100;
para.lamda = 0.5;
para.theta = 10;
para.k = 20;
para.wordnum = 1;
para.thickness = 5;