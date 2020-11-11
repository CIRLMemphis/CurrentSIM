function g2 = PadZeroTransform(g)
% zero-padding to all
[Y, X, Z, Nthe, Nphi] = size(g);
if mod(Z,2) == 1
    Z2 = 2*Z - 1;
else
    Z2 = Z*2;
end
g2    = zeros(Y*2, X*2, Z2, Nthe, Nphi);
for l = 1:Nthe
    for k = 1:Nphi
        g2(:,:,:,l,k) = abs(IFT(padarray(FT(g(:,:,:,l,k)),[Y/2 X/2 floor(Z/2)])));
    end
end
end