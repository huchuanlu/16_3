function rule = miningrule(para,imname)

k = para.k;
dict_size = para.dictionarySize;
pos = (dict_size-1) * k + k + 1;
appFile = './appFile.txt';
if ~exist(appFile,'file')
    fid = fopen(appFile,'w');
    fprintf(fid,'in\n');
    fprintf(fid,'%d out',pos);
end
    
fprintf('Mining rule...\n')
numRow = 0;
rr = 1;
tranacName = fullfile(para.transacdir,[imname(1:end-4) '.txt']);
while numRow <= para.minrule && rr<=length(para.suppset) 
    supp = para.suppset(rr);
    inputFile = tranacName;
    outputFile = fullfile(para.ruledir,[imname(1:end-4) '.mat']);
    options = ['/home/iiau/Desktop/apriori/apriori/src/apriori -tr -s',num2str(supp),' -m',num2str(para.minLength),' -n',num2str(para.maxLength),' -c',num2str(para.confid),' -R',appFile];
    system([options,' ',inputFile,' ',outputFile]);
    
    %% use rule back to test image
    fprintf('********\n');
    fprintf('Extracting rule\n');
    fid = fopen(fullfile(para.ruledir,[imname(1:end-4),'.mat']),'r');
    C = textscan(fid,'%s','delimiter','\n');
    numRow = length(C{1});
    rr = rr+1;
end
    
rule = cell(numRow,1);
fclose(fid);
fid = fopen(fullfile(para.ruledir,[imname(1:end-4),'.mat']),'r');
for hh = 1:numRow
    line = fgetl(fid);
    en = strfind(line,'(');
    st = strfind(line,' ');
    substr = line(st(2)+1:en-1);
    rule{hh} = str2num(substr);
end
fclose(fid);
