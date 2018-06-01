function creatTransactionFile(colist,fid,para,f)

dict_size = para.dictionarySize;
k = para.k;
pos = (dict_size-1) * k + k + 1;
neg = (dict_size-1) * k + k + 2;
for i = 1 : size(colist,1)
    x = (colist{i,1}.words);
    [d,v] = hist(x,1:1:dict_size);  
    p = find(d);
    v = d(p);
    for u = 1 : size(p,2)
        fprintf(fid, '%d ', (( p(1,u)-1 ) * k + v(1,u) ) );
    end        
    if f <= para.multiscalenum
        fprintf(fid, '%d', pos);
    else if f > para.multiscalenum
            fprintf(fid, '%d', neg);
        end
    end
    fprintf(fid, '\n'); 
end   