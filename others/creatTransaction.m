function transaction = creatTransaction(colist,dict_size,k)    
transaction = cell(size(colist,1),1);
for i = 1 : size(colist,1)
    x = (colist{i,1}.words);
    [d,v] = hist(x,1:1:dict_size);  
    p = find(d);
    v = d(p);
    temp = zeros(1,size(p,2));
    for u = 1 : size(p,2)
        temp(u) = ( p(1,u)-1 ) * k + v(1,u);
    end        
    transaction{i} = temp;
end