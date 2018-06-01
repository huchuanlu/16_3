function diffaversal1 = randomwalk(segim,seglab,seedlabel,aversal,theta,mu)

spnum = max(max(segim));
W = geodesicaffmtx(segim,seglab,theta);
dd = sum(W); 
D = sparse(1:spnum,1:spnum,dd);
L = D-0.99*W;
L2 = L^(2);
label = 1:1:spnum;
[c,ia,ib] = intersect(label,seedlabel);
label(ia) = [];
baclabel = label;
salseednum = length(seedlabel);
Lu = L(baclabel,baclabel);
L2u = L2(baclabel,baclabel);
B = L(seedlabel,baclabel);
Pm = ones(salseednum,1);
Yu = aversal(baclabel);
inver = (Lu+mu*eye(spnum-salseednum))\eye(spnum-salseednum);
Pu = inver*(-B'*Pm + mu*Yu);
diffaversal = zeros(spnum,1);
diffaversal(seedlabel) = 1;
diffaversal(baclabel) = Pu;

inver2 = (L2+eye(spnum))\eye(spnum);
diffaversal1 = inver2*diffaversal;