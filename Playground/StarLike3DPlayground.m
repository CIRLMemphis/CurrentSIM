dxyz = 0.02;
x = -2:dxyz:2;
z = -1:dxyz:1;
[xx,yy,zz] = meshgrid(x, x, z);
X = size(xx,1);
Y = size(xx,2);
Z = size(xx,3);
fxx = zeros(size(xx));

Nx  = 9;
xpi = zeros(Nx,1);
for j = 1:Nx
    xpi(j) = (j-1)*pi/(Nx-1);
end

Nz  = 8;
zpi = zeros(Nz,1);
for j = 1:Nz
    zpi(j) = (j-1)*pi/(Nz-1);
end

xamp  = 200;
zamp  = 200;
xRad = 1.5;
zRad = 0.7;
for xi = 1:X
    for yi = 1:Y
        for zi = 1:Z
            xxi = xx(xi,yi,zi);
            yyi = yy(xi,yi,zi);
            zzi = zz(xi,yi,zi);
            
            r = sqrt(xxi^2 + yyi^2 + zzi^2);
            if (yyi^2 + zzi^2 <= xxi^2/xamp && r <= xRad )
                fxx(xi,yi,zi) = 1;
            end
            
            for j = 2:length(zpi)-1
                a   = tan(zpi(j));
                x0  = (xxi + zzi*a)/(1+a^2);
                z0  = a*x0;
                if (yyi^2 + (xxi - x0)^2 + (zzi - z0)^2 <= (x0^2 + z0^2)/zamp &&...
                        r <= zRad )
                    fxx(xi,yi,zi) = 1;
                end
            end
            for j = 1:length(xpi)
                a   = tan(xpi(j));
                x0  = (xxi + yyi*a)/(1+a^2);
                y0  = a*x0;
                if ((yyi - y0)^2 + (xxi - x0)^2 + zzi^2 <= (x0^2 + y0^2)/xamp &&...
                        r <= xRad )
                    fxx(xi,yi,zi) = 1;
                end
            end
        end
    end
end

backupfxx = fxx;

%% smoothing
%Fil_size = 2+1; sd = 0.6; fxx = smooth3(backupfxx, 'gaussian',Fil_size,sd);
fxx = backupfxx;

xvec = [];
yvec = [];
zvec = [];
fvec = [];
for xi = 1:X
    for yi = 1:Y
        for zi = 1:Z
            xxi = xx(xi,yi,zi);
            yyi = yy(xi,yi,zi);
            zzi = zz(xi,yi,zi);
            if (fxx(xi,yi,zi) > 0.1)
                xvec(end+1) = xxi;
                yvec(end+1) = yyi;
                zvec(end+1) = zzi;
                fvec(end+1) = fxx(xi,yi,zi);
            end
        end
    end
end

figure; imagesc(fxx(:,:,round(Z/2))); axis square;
figure; imagesc(squeeze(fxx(round(X/2),:,:))'); axis square;

figure;
subplot(1,2,1); imagesc(fxx(:,:,round(Z/2))); xlabel('x'); ylabel('y'); axis square;
subplot(1,2,2); imagesc(squeeze(fxx(round(X/2),:,:))'); xlabel('x'); ylabel('z'); axis image;

figure;
scatter3(xvec, yvec, zvec, [], fvec, 'filled'); colorbar;
xlim([min(x) max(x)]); ylim([min(x) max(x)]); zlim([min(z) max(z)]);
xlabel('x'); ylabel('y'); zlabel('z');