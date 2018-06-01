function colist = createVisualWord(center,texton,para)

k = para.k;
if size(center,1)<=k
    k = round(size(center,1)/2);
end
word_indexes = texton.data;
x = center(:,1);
y = center(:,2);
num_Key_Points = size(word_indexes,1);
locations = [x y];
colist = cell(num_Key_Points,1);
for i = 1 : num_Key_Points
     nnb = kNearestNeighbors(locations,locations(i,:),k); 
     mainWord = word_indexes(i);
     tempnearestWords = word_indexes(nnb);
     nearestWords = [];
     for j = 1 : length(tempnearestWords)
         nearestWords = [nearestWords tempnearestWords{j}];
     end
     colist{i}.words=nearestWords;
     colist{i}.mainword = mainWord;
end