function h = ApodizationPixel ( XY, Z, dXY, dZ , radius, center )
% radius is in pixels (on XY plane)
ZApo      = ceil(Z*dZ/dXY);
center(3) = round(center(3)*dZ/dXY);
ADPxl     = apodization(XY, ZApo, radius, center); % in 3D
[XApoMesh, YApoMesh, ZApoMesh] = meshgrid(1:XY, 1:XY, 1:ZApo);
[XMesh   , YMesh   , ZMesh   ] = meshgrid(1:XY, 1:XY, (1:Z)*ZApo/Z);
h     = interp3(XApoMesh, YApoMesh,ZApoMesh,ADPxl,XMesh,YMesh,ZMesh,'cubic');
end