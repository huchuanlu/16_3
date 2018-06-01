function vector = getvector(rule, dictionarysize)

vector = zeros(1,dictionarysize);
vector(rule) = 1;
