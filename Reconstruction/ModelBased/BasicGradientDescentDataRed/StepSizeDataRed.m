function curStepSize = StepSizeDataRed(diff, d, h, im, jm)
[Y, X, Z, Npt, Nm] = size(jm);
bot  = 0;
top  = 0;
A    = zeros(Y, X, Z);
for lk = 1:Npt
    A(:) = 0;
    for m = 1:Nm
        A = A + real(IFT( FT(d.*jm(:,:,:,lk,m)) .* FT(h.*im(:,:,:,lk,m)) ));
    end
    diffkl = squeeze(diff(:,:,:,lk));
    bot    = bot + dot(A(:), A(:));
    top    = top + dot(A(:), diffkl(:));
end

curStepSize = top/bot;
end