run('../../../CIRLSetup.m')
s    = xml2struct(char(CIRLDataPath + '/FairSimData/Actin3D.xml'));
data = s.fairsim.otf3d.data;
temp = {data.band_dash_0, data.band_dash_1, data.band_dash_2};
vec = zeros(257,257,129,5);
for ind = 1:length(temp)
    tmp  = swapbytes(typecast(matlab.net.base64decode(temp{ind}.Text(9:end-8)), 'single'));
    XY   = str2num(s.fairsim.otf3d.data.samples_dash_lateral.Text);
    inZ  = str2num(s.fairsim.otf3d.data.samples_dash_axial.Text);

    assert(length(tmp) == 2*XY*inZ);

    otfPolar = zeros(XY, inZ);
    cnt      = 0;
    for z = 1:inZ
        for xy = 1:XY
            otfPolar(xy,z) = tmp(2*cnt+1) + 1i*tmp(2*cnt+2);
            cnt = cnt+1;
        end
    end
    
    otf3D = zeros(XY*2-1, XY*2-1, inZ*2-1);
    for x = 1:(XY*2-1)
        for y = 1:(XY*2-1)
            rad = round(sqrt(((x - XY)*(x - XY) + (y - XY)*(y - XY))/2))+1;
            if (rad <= XY)
                otf3D(x,y,1:inZ)   = otfPolar(rad, end:-1:1);
                otf3D(x,y,inZ:end) = otfPolar(rad, :);
            end
        end
    end
    
    if (ind == 1)
        vec(:,:,:,1) = otf3D;
    elseif (ind == 2)
        vec(:,:,:,2) = otf3D;
        vec(:,:,:,5) = otf3D;
    else
        vec(:,:,:,3) = otf3D;
        vec(:,:,:,4) = otf3D;
    end
end

%%
H0 = vec(:,:,:,1);
H1 = vec(:,:,:,2);
H0(:,:,1:40) = 0;
H1(:,:,1:40) = 0;
H0(:,:,90:end) = 0;
H1(:,:,90:end) = 0;
figure;
subplot(1,2,1); imagesc((squeeze((abs(H0(129,:,:)))))'); axis image; xlabel('u'); ylabel('w'); title('H0');
subplot(1,2,2); imagesc((squeeze((abs(H1(129,:,:)))))'); axis image; xlabel('u'); ylabel('w'); title('H1');

h0 = real(IFT(H0));
h1 = real(IFT(H1));

figure;
subplot(2,1,1); imagesc(squeeze(h0(129,:,:))'); axis image; xlabel('x'); ylabel('z'); title('h0');
subplot(2,1,2); imagesc(squeeze(h1(129,:,:))'); axis image; xlabel('x'); ylabel('z'); title('h1');
suptitle('Experimental PSFs of the first and second bands.');

figure; 
subplot(2,2,1); plot(squeeze(h0(129, 129, :))); xlabel('z'); title('h0');
subplot(2,2,2); plot(squeeze(h1(129, 129, :))); xlabel('z'); title('h1');
vz = squeeze(h1(129,129,:)./h0(129, 129, :));
subplot(2,2,3); plot(vz); xlabel('z'); title('v(z) = h1/h0');
fftVn = abs(fft(vz));
subplot(2,2,4); plot(fftVn); xlabel('w'); title('fft(v(z))');

%%
[X_ref, Y_ref, Z_ref] = size(H0);
 dW_ref = str2num(s.fairsim.otf3d.data.cycles_dash_axial.Text);
dUV_ref = str2num(s.fairsim.otf3d.data.cycles_dash_lateral.Text);
% 
% midX_ref = round(X_ref/2);
% midY_ref = round(Y_ref/2);
% midZ_ref = round(Z_ref/2);
% 
% Hn0_ref = H0(midX_ref:end, midY_ref:end, midZ_ref:end);
% Hn1_ref = H1(midX_ref:end, midY_ref:end, midZ_ref:end);
% [X_ref, Y_ref, Z_ref] = size(Hn0_ref);

X   = 512*2;
Y   = 512*2;
%Z   = 7+6;
Z   = 43;
dXY = 0.08/2;
dZ  = 0.125/2;
dUV = 1/X/dXY;
dW  = 1/Z/dZ;
midX = 1+round(X/2);
midY = 1+round(Y/2);
midZ =   round(Z/2);

%% manual interpolation
% Hn0 = zeros(X,Y,Z);
% for Xind = 1:X
%     Xind
%     for Yind = 1:Y
%         for Zind = 1:Z
%             Udist = abs(Xind - midX)*dUV;
%             Vdist = abs(Yind - midY)*dUV;
%             Wdist = abs(Zind - midZ)*dW;
%             Upxl  = Udist/dUV_ref;
%             Vpxl  = Vdist/dUV_ref;
%             Wpxl  = Wdist/dW_ref;
%              lowU = floor(Upxl)+1;
%             highU =  ceil(Upxl)+1;
%              lowV = floor(Vpxl)+1;
%             highV =  ceil(Vpxl)+1;
%              lowW = floor(Wpxl)+1;
%             highW =  ceil(Wpxl)+1;
%             
%             if (Udist > dUV_ref*(X_ref - 1) || ...
%                 Vdist > dUV_ref*(Y_ref - 1) || ...
%                 Wdist >  dW_ref*(Z_ref - 1) || ...
%                 lowU < 0 || highU > X_ref || ...
%                 lowV < 0 || highV > Y_ref || ...
%                 lowW < 0 || highW > Z_ref)
%             else
%                 % formulas from
%                 % https://en.wikipedia.org/wiki/Trilinear_interpolation
%                 x0   = lowU;
%                 y0   = lowV;
%                 z0   = lowW;
%                 c000 = Hn0_ref(lowU, lowV, lowW);
%                 c001 = Hn0_ref(lowU, lowV, highW);
%                 c010 = Hn0_ref(lowU, highV, lowW);
%                 c011 = Hn0_ref(lowU, highV, highW);
%                 c100 = Hn0_ref(highU, lowV, lowW);
%                 c101 = Hn0_ref(highU, lowV, highW);
%                 c110 = Hn0_ref(highU, highV, lowW);
%                 c111 = Hn0_ref(highU, highV, highW);
%                 
%                 xd = Upxl - x0;
%                 yd = Vpxl - y0;
%                 zd = Wpxl - z0;
%                 c00 = c000*(1 - xd) + c100*xd;
%                 c01 = c001*(1 - xd) + c101*xd;
%                 c10 = c010*(1 - xd) + c110*xd;
%                 c11 = c011*(1 - xd) + c111*xd;
%                 
%                 c0 = c00*(1-yd) + c10*yd;
%                 c1 = c01*(1-yd) + c11*yd;
%                 Hn0(Xind, Yind, Zind) = c0*(1-zd) + c1*zd;
%             end
%         end
%     end
% end

%% interpolation using interp3
Xcor = X/2;
Ycor = Y/2;
Zcor = round(Z/2);

midX_ref = round(X_ref/2);
midY_ref = round(Y_ref/2);
midZ_ref = round(Z_ref/2);

[xx_ref, yy_ref, zz_ref] = meshgrid(-(midX_ref-1)*dUV_ref:dUV_ref:(midX_ref-1)*dUV_ref, ...
                                    -(midY_ref-1)*dUV_ref:dUV_ref:(midY_ref-1)*dUV_ref, ...
                                    -(midZ_ref-1)*dW_ref : dW_ref:(midZ_ref-1)*dW_ref);
[xx, yy, zz] = meshgrid(-(Xcor-1)*dUV:dUV:Xcor*dUV, ...
                        -(Ycor-1)*dUV:dUV:Ycor*dUV, ...
                        -(Zcor-1)*dW :dW:(Zcor-1)*dW);
Hn0 = interp3(xx_ref, yy_ref, zz_ref, H0(:,:,:), xx, yy, zz, 'spline', 0.0);
Hn1 = interp3(xx_ref, yy_ref, zz_ref, H1(:,:,:), xx, yy, zz, 'spline', 0.0);

%%
figure;
subplot(121); imagesc(squeeze(abs(H0 (:,:,midZ_ref)))); axis square;
subplot(122); imagesc(squeeze(abs(Hn0(:,:,midZ    )))); axis square;
figure; 
subplot(121); imagesc(squeeze(abs(H1 (midY_ref,:,:)))'); axis image;
subplot(122); imagesc(squeeze(abs(Hn1(midY    ,:,:)))'); axis image;

%% Apply IFT to get the PSF and pattern
h   = real(IFT(Hn0));
hn1 = real(IFT(Hn1));
vz  = hn1(midX,midY,:)./h(midX,midY,:);

%%
figure; imagesc(h(:,:,midZ)); axis square;
figure; plot(squeeze(vz))

%% check experimental alignment
hz = squeeze(h (midY,midX,:));
hz = hz./max(hz(:));
figure;  plot(squeeze(vz), 'DisplayName', 'v(z)'); 
hold on; plot(hz, 'DisplayName', 'h(z)'); 
xlabel('z'); ylabel('value'); suptitle("Visibility and PSF"); legend; axis square;

%% drop the middle part of h and vz
newZ    = 13;
midNewZ = round(newZ/2);
hNew    = h(:,:,Zcor-midNewZ+1:Zcor+midNewZ-1);
hzNew   = squeeze(hNew(midY,midX,:));
hzNew   = hzNew./max(hzNew(:));
vzNew   = vz(:,:,Zcor-midNewZ+1:Zcor+midNewZ-1);
figure;  plot(squeeze(vzNew), 'DisplayName', 'v(z)'); 
hold on; plot(hzNew, 'DisplayName', 'h(z)'); 
xlabel('z'); ylabel('value'); suptitle("Visibility and PSF"); legend; axis square;

%%
h  = hNew;
vz = vzNew;
save(char(CIRLDataPath + "/FairSimOTFs/splinePSF_" + X + "_" + Y + "_" + newZ + ".mat"), 'h');
save(char("LSECActin_vz.mat"), 'vz');

%%
Hn = zeros(X, Y, Z, 5);
Hn(:,:,:,1) = Hn0;
Hn(:,:,:,2) = Hn1;
Hn(:,:,:,3) = Hn1;
Hn(:,:,:,4) = Hn0;
Hn(:,:,:,5) = Hn0;
save(char(CIRLDataPath + "/FairSimOTFs/splineOTF_" + X + "_" + Y + "_" + Z + "_5.mat"), 'Hn', '-v7.3');