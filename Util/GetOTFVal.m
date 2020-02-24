function val = GetOTFVal(vals, xyCycl, zCycl, ...
                         cutOffLateral, cutOffAxial, ...
                         samplesLateral, samplesAxial, ...
                         cyclesPerMicronLateral, cyclesPerMicronAxial)
if (xyCycl >= cutOffLateral || zCycl >= cutOffAxial )
    val = 0;
else
    xpos = xyCycl / cyclesPerMicronLateral;
	zpos = zCycl  / cyclesPerMicronAxial;
    
    if ( ceil(xpos) >= samplesLateral || ceil(zpos) >= samplesAxial )
        val = 0;
    else
        lxPos = floor(xpos);
        hxPos = ceil( xpos);
        fx    = xpos - lxPos;
        lzPos = floor(zpos);
        hzPos = ceil( zpos);
        fz    = zpos - lzPos;
        
        r1  = vals(lxPos+1, lzPos+1)*(1-fx);
        r2  = vals(hxPos+1, lzPos+1)*fx;
        r3  = vals(lxPos+1, hzPos+1)*(1-fx);
        r4  = vals(hxPos+1, hzPos+1)*fx;
        r5  = (r1 + r2)*(1-fz);
        r6  = (r3 + r4)*fz;
        val = r5 + r6;
    end
end
end