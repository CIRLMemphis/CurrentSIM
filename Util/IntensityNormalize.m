function g = IntensityNormalize(g)
[Y, X, Z, Nthe, Nphi] = size(g);
meanArr = zeros(Nthe, Nphi);
stdArr  = zeros(Nthe, Nphi);
for l = 1:Nthe
    for k = 1:Nphi
        meanArr(l,k) = mean(reshape(g(:,:,:,l,k), Y*X*Z, 1));
         stdArr(l,k) =  std(reshape(g(:,:,:,l,k), Y*X*Z, 1));
    end
end
maxMean = max(meanArr(:));
maxStd  = max( stdArr(:));
for l = 1:Nthe
    for k = 1:Nphi
        g(:,:,:,l,k) = (g(:,:,:,l,k) - meanArr(l,k)).*(maxStd/stdArr(l,k)) + maxMean;
    end
end
end