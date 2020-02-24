function cleanOb = Glio2PostProcess(reconOb, mid, omegaXYPxl, deltaPxl, colorSetting)
if (nargin < 5)
    colorSetting = 'jet';
end

reconFT = FT(reconOb);
mask    = zeros(size(reconFT));
x = 0:(2*deltaPxl);
y = repmat(gaussmf(x,[15 deltaPxl]), [size(reconFT,1), 1, size(reconFT,3)]);
figure; plot(x,1-y(50,:,60));
mask(:, mid-omegaXYPxl-deltaPxl:mid-omegaXYPxl+deltaPxl, :) = y;
mask(:, mid+omegaXYPxl-deltaPxl:mid+omegaXYPxl+deltaPxl, :) = y;

mask(:, mid-omegaXYPxl*2-deltaPxl:mid-omegaXYPxl*2+deltaPxl, :) = y;
mask(:, mid+omegaXYPxl*2-deltaPxl:mid+omegaXYPxl*2+deltaPxl, :) = y;

mask(:, mid-omegaXYPxl*3-deltaPxl:mid-omegaXYPxl*3+deltaPxl, :) = y;
mask(:, mid+omegaXYPxl*3-deltaPxl:mid+omegaXYPxl*3+deltaPxl, :) = y;

mask(:, mid-omegaXYPxl*4-deltaPxl:mid-omegaXYPxl*4+deltaPxl, :) = y;
mask(:, mid+omegaXYPxl*4-deltaPxl:mid+omegaXYPxl*4+deltaPxl, :) = y;

mask = 1-mask;
reconFT = reconFT.*mask;
figure;
subplot(2,1,1); imagesc(log(abs(squeeze(reconFT(513, :, :))'))); axis image;  colormap(colorSetting); xlabel('u'); ylabel('w'); title('Before post-processing');
subplot(2,1,2); imagesc(log(abs(squeeze(reconFT(513, :, :))'))); axis image;  colormap(colorSetting); xlabel('u'); ylabel('w'); title('After post-processing');
cleanOb = abs(IFT(reconFT));
end