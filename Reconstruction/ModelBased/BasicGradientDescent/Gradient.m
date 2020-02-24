function gradOb = Gradient(diff, h, im, jm)
[Y, X, ~, Nthe, Nphi, Nm] = size(jm);
Z      = size(diff, 3);
gradOb = zeros(Y, X, Z);
for l = 1:Nthe
    for k = 1:Nphi
        for m = 1:Nm
            gradOb = gradOb + conj(jm(:,:,:,l,k,m)).* ...
                     IFT( conj(FT(h.*im(:,:,:,l,k,m))) .* FT(diff(:,:,:,l,k)) );
        end
    end
end
gradOb = -real(2.*gradOb);
end