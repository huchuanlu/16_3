function diffaversal = randomwalk_new(segim,seglab,seedlabel,aversal,alpha,beta,theta)

spnum = max(max(segim));
W = geodesicaffmtx(segim,seglab,theta);
dd = sum(W); 
D = sparse(1:spnum,1:spnum,dd);
L = D-0.99*W;
L2 = L^(2);
I = eye(spnum);
M = L + alpha*L2 + beta*I;
salseednum = length(seedlabel);
label = 1:1:spnum;
[c,ia,ib] = intersect(label,seedlabel);
label(ia) = [];
baclabel = label;
M_uu = M(baclabel,baclabel);
M_ul = M(baclabel,seedlabel);
Y_u = aversal(baclabel);
f_l = ones(salseednum,1);
inver = M_uu\eye(length(baclabel));
f_u = inver*(-M_ul*f_l + beta*Y_u);

diffaversal = zeros(spnum,1);
diffaversal(seedlabel) = 1;
diffaversal(baclabel) = f_u;
