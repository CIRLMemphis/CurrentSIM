% see section [TODO] in the documentation
function g = ForwardModelDataRed( ob, h, im, jm)
[X, Y, ~, Npt, Nm] = size(jm);
Z = size(ob, 3);
g = zeros(X,Y,Z,Npt);

for lk = 1:Npt
    G = zeros(X,Y,Z);
    for m = 1:Nm
        G = G + FT(ob.*jm(:,:,1,lk,m)).*FT(h.*im(1,1,:,lk,m));
    end
    g(:,:,:,lk) = real(IFT(G));
end
end