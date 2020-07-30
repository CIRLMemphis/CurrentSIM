function [scale01, scaleMicron] = Pixel2Micron(X, dXY)
if (mod(X, 2) ~= 0)
    error('X has to be even!');
end
pxPerMicron   = round(1/dXY);
micronScale01 = pxPerMicron/X;
mid           = 0.5;
scale01       = [0, (mid - 2*micronScale01), (mid -   micronScale01), (mid - micronScale01/2), mid,...
                    (mid + micronScale01/2), (mid +   micronScale01), (mid + 2*micronScale01), 1]*X;
scaleMicron   = round([ -X/2, -2*pxPerMicron,    -pxPerMicron,   -pxPerMicron/2, 0,...
                               pxPerMicron/2,  pxPerMicron, 2*pxPerMicron, X/2-1]*dXY, 1);
end