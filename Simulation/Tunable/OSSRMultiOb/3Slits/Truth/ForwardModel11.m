% see section [TODO] in the documentation
function g = ForwardModel11( ob, h, im, jm)
[X, Y, ~, Nthe, Nphi, Nm] = size(jm);
Z = size(ob, 3);
g = zeros(X,Y,Z);
for l = 1:1
    for k = 1:1
        G = zeros(X,Y,Z);
        for m = 1:Nm
            G = G + FT(ob.*jm(:,:,:,l,k,m)).*FT(h.*im(:,:,:,l,k,m));
        end
        g(:,:,:,l,k) = real(IFT(G));
    end
end
