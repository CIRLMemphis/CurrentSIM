function g = BackgroundRemove(g, radius)
[Y, X, Z, Nthe, Nphi] = size(g);
SE   = strel('disk', radius);
for l = 1:Nthe
    for k = 1:Nphi
        g(:,:,:,l,k) = g(:,:,:,l,k) - imopen(g(:,:,:,l,k), SE);
    end
end
end