function gradOb = GradientDataRed(diff, h, im, jm)
[Y, X, Z, Npt, Nm] = size(jm);
gradOb = zeros(Y, X, Z);
for lk = 1:Npt
    for m = 1:Nm
        gradOb = gradOb + conj(jm(:,:,:,lk,m)).* ...
                 IFT( conj(FT(h.*im(:,:,:,lk,m))) .* FT(diff(:,:,:,lk)) );
    end
end
gradOb = -real(2.*gradOb);
end