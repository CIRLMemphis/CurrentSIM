function gradOb = GradientNoDup(diff, h, im, jm)
[Y, X, Z, Nthe, Nphi, Nm] = size(jm);
gradOb = zeros(Y, X, Z);
for l = 1:Nthe
    for k = 1:Nphi
        if (k == 1 && l > 1)
            continue;
        end
        for m = 1:Nm
            gradOb = gradOb + conj(jm(:,:,:,l,k,m)).* ...
                     IFT( conj(FT(h.*im(:,:,:,l,k,m))) .* FT(diff(:,:,:,l,k)) );
        end
    end
end
gradOb = -real(2.*gradOb);
end