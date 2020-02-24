function vec = OtfToVector( w, h, d, kx, ky, ...
                            vals, ...
                            cutOffLateral, cutOffAxial, ...
                            samplesLateral, samplesAxial, ...
                            vecCyclesPerMicronLateral, vecCyclesPerMicronAxial,...
                            pxlCycleX, pxlCycleZ)
vec = zeros(w,h,d);
for zi = 1:d
    zh      = abs(zi - d/2);
    cyclax  = zh  * pxlCycleZ;
    if (cyclax > cutOffAxial )
        vec(:,:,zi) = 0;
    else
        for yi = 1:h
            for xi = 1:w
                %rad = sqrt((xh - kx)^2 + (yh - ky)^2);
                rad = sqrt((xi - w/2)^2 + (yi - h/2)^2);
                cycllat = rad * pxlCycleX;
                if ( cycllat > cutOffLateral || cyclax > cutOffAxial )
                    vec(xi,yi,zi) = 0;
                else
                    vec(xi,yi,zi) = conj(GetOTFVal(vals, cycllat, cyclax,...
                                                   cutOffLateral, cutOffAxial,...
                                                   samplesLateral, samplesAxial,...
                                                   vecCyclesPerMicronLateral, vecCyclesPerMicronAxial));
                end
            end
        end
    end
end
end