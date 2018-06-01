function dictionary = CalculateDictionary(samplefea,para)

%% parameters
dictionary_flag=1;

if(dictionary_flag)
    %% k-means clustering
    
    nimages=length(samplefea);      % number of traning images in data set, we must make sure the fist nimages is for trarning
    
    niters=100;                     %maximum iterations
    data = samplefea{end};
    data = [data;samplefea{end-1}];
    if size(data,1)<para.dictionarySize
        data = [data;samplefea{end-2}];
    end
    
    if size(data,1)<para.dictionarySize
        data = [data;samplefea{end-3}];
    end
  
    centres = zeros(para.dictionarySize, size(data,2));
    [ndata, data_dim] = size(data);
    [ncentres, dim] = size(centres);
    
    %% initialization
    
    perm = randperm(ndata);
    perm = perm(1:ncentres);
    centres = data(perm, :);
    
    num_points=zeros(1,para.dictionarySize);
    old_centres = centres;
    
    for n=1:niters
        % Save old centres to check for termination
        e2=max(max(abs(centres - old_centres)));
        
        inError(n)=e2;
        old_centres = centres;
        tempc = zeros(ncentres, dim);
        num_points=zeros(1,ncentres);
        
        for f = 1:nimages
            data = samplefea{f};
            [ndata, data_dim] = size(data);   
            id = eye(ncentres);
            d2 = EuclideanDistance(data,centres);
            % Assign each point to nearest centre
            [minvals, index] = min(d2', [], 1);
            post = id(index,:); % matrix, if word i is in cluster j, post(i,j)=1, else 0;
            
            num_points = num_points + sum(post, 1);
            
            for j = 1:ncentres
                tempc(j,:) =  tempc(j,:)+sum(data(find(post(:,j)),:), 1);
            end
            
        end
        
        for j = 1:ncentres
            if num_points(j)>0
                centres(j,:) =  tempc(j,:)/num_points(j);
            end
        end
        if n > 1
            % Test for termination
            
            %Threshold
            ThrError=0.009;
            
            if max(max(abs(centres - old_centres))) <0.009
                dictionary= centres;
                break;
            end
            
        end
        
    end
        
end
end
