function bead = GaussianBead(xc, yc, zc, baseRad, amplitude, xRange, shouldPlot)
if (nargin < 7)
    shouldPlot = 0;
end
[xx, yy, zz] = meshgrid(xRange, xRange, xRange);
c    = baseRad/(2*sqrt(3)); % the denominator of c is determined analytically
bead = amplitude*exp(-((xx - xc).^2 + (yy - yc).^2 + (zz - zc).^2)/(2*c^2));

if (shouldPlot)
    figure; imagesc(bead(:,:,round(size(yy,2)/2))); axis square;
    figure; plot(xRange, bead(:,round(size(yy,2)/2),round(size(zz,2)/2)));
end
end

