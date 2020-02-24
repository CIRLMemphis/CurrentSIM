function [ I_SIM_1, I_SIM_0, I_WF ] = Reconstruction_GUS_Tunable_3DRec( g, h, Pattern_Axial, uc, um, Phase, Angle, w_D0, w_Dpm1, ZCC, dXY, dZ, show, lwidth, fsize )
% Deconvolution based on the Gustaffson (3D) paper 2008
% by Hasti Shabani
%%
[Y X Z Angle_No Ph_No] = size(g);
phi = pi*Phase/180;
theta = pi*Angle/180;
h1 = h.*Pattern_Axial;
h1 = h1./sum(h1(:));
H0 = FT(h);
H1 = FT(h1);

radius = round(uc*X*dXY);
Filter = bead(dXY, dZ, X, Z, radius*dXY, radius*dXY);
%% Preprocessing
for j = 1:Angle_No
    for k = 1: Ph_No
        g(:,:,:,j,k) = g(:,:,:,j,k) - min(min(min(g(:,:,:,j,k))));
        G(:,:,:,j,k) = FT(g(:,:,:,j,k)).*Filter;
    end
end
%% Decomposing of components
M = []; % size(M) is Ph_No by 3, 3 is fixed according to the mask, i.e. we have three component in each recorded image
for k = 1:Ph_No
    M = [M; [1 0.5.*exp(+1i*phi(k)) 0.5.*exp(-1i*phi(k))] ];
end
M_inv = inv(M);

D0 = zeros( Y, X, Z, Angle_No);
D1 = zeros( Y, X, Z, Angle_No);
D2 = zeros( Y, X, Z, Angle_No);

for j = 1:Angle_No
    for k = 1:Ph_No
        D0(:,:,:,j) = D0(:,:,:,j) + G(:,:,:,j,k).*M_inv(1,k);
        D1(:,:,:,j) = D1(:,:,:,j) + G(:,:,:,j,k).*M_inv(2,k);
        D2(:,:,:,j) = D2(:,:,:,j) + G(:,:,:,j,k).*M_inv(3,k);
    end
end

figure;
subplot(4,4, 1); imagesc(squeeze(abs(D0(    :,1+X/2,    :,1)).^0.1));  title( 'D0', 'fontsize',0.7*fsize ); axis image; colormap gray;
subplot(4,4, 2); imagesc(squeeze(abs(D0(    :,    :,1+Z/2,1)).^0.1));  title( 'D0', 'fontsize',0.7*fsize ); axis image; colormap gray;
subplot(4,4, 6); imagesc(squeeze(abs(D0(1+Y/2,    :,    :,1)).^0.1)'); title( 'D0', 'fontsize',0.7*fsize ); axis image; colormap gray;
subplot(4,4, 3); imagesc(squeeze(abs(D1(    :,1+X/2,    :,1)).^0.1));  title( 'D1', 'fontsize',0.7*fsize ); axis image; colormap gray;
subplot(4,4, 4); imagesc(squeeze(abs(D1(    :,    :,1+Z/2,1)).^0.1));  title( 'D1', 'fontsize',0.7*fsize ); axis image; colormap gray;
subplot(4,4, 8); imagesc(squeeze(abs(D1(1+Y/2,    :,    :,1)).^0.1)'); title( 'D1', 'fontsize',0.7*fsize ); axis image; colormap gray;
subplot(4,4, 9); imagesc(squeeze(abs(D2(    :,1+X/2,    :,1)).^0.1));  title( 'D2', 'fontsize',0.7*fsize ); axis image; colormap gray;
subplot(4,4,10); imagesc(squeeze(abs(D2(    :,    :,1+Z/2,1)).^0.1));  title( 'D2', 'fontsize',0.7*fsize ); axis image; colormap gray;
subplot(4,4,14); imagesc(squeeze(abs(D2(1+Y/2,    :,    :,1)).^0.1)'); title( 'D2', 'fontsize',0.7*fsize ); axis image; colormap gray;

figure;
subplot(1,3,1); colormap gray; imshow(squeeze(abs(D0(:,:,1+Z/2,1)).^0.1),[]); title( 'D0', 'fontsize',0.7*fsize );
subplot(1,3,2); colormap gray; imshow(squeeze(abs(D1(:,:,1+Z/2,1)).^0.1),[]); title( 'D1', 'fontsize',0.7*fsize );
subplot(1,3,3); colormap gray; imshow(squeeze(abs(D2(:,:,1+Z/2,1)).^0.1),[]); title( 'D2', 'fontsize',0.7*fsize );

figure,
subplot(131);plot(abs(squeeze(D0(1+Y/2,:,1+Z/2,1))),'r','linewidth',lwidth); axis tight;
subplot(132);plot(abs(squeeze(D1(1+Y/2,:,1+Z/2,1))),'b','linewidth',lwidth); axis tight;
subplot(133);plot(abs(squeeze(D2(1+Y/2,:,1+Z/2,1))),'k','linewidth',lwidth); axis tight;
%% Deconvolution of each component
[yy, xx] = meshgrid(0 : 1 : X-1);
fxx = um*xx*dXY;   % 2fx abscissae
fyy = um*yy*dXY;   % 2fx abscissae
for j = 1 : Angle_No
    xy = repmat( (cos(theta(j)).*fyy + sin(theta(j)).*fxx), [1 1 Z] );
    denD0(:,:,:,j) = abs(H0).^2 + abs(FT(exp(+1i*2*pi*xy).* h1)).^2 + abs(FT(exp(-1i*2*pi*xy).* h1)).^2;    % 3.*abs(H0).^2;
    denD1(:,:,:,j) = abs(H1).^2 + abs(FT(exp(+1i*2*pi*xy).* h)).^2 + abs(FT(exp(+1i*4*pi*xy).* h1)).^2;    
    denD2(:,:,:,j) = abs(H1).^2 + abs(FT(exp(-1i*2*pi*xy).* h)).^2 + abs(FT(exp(-1i*4*pi*xy).* h1)).^2;
end
radius = round((uc+um)*X*dXY);
AD0 = zeros(Y, X, Z, Angle_No);
AD1 = zeros(Y, X, Z, Angle_No);
AD2 = zeros(Y, X, Z, Angle_No);
for j = 1 : Angle_No
    center = [1+Y/2 1+X/2 1+Z/2];
    AD0(:,:,:,j) = apodization( X, Z, radius, center);
    
    center = [1+Y/2 1+X/2 1+Z/2] + round(um*X*dXY*[sin(theta(j)) cos(theta(j)) 0]);
    AD1(:,:,:,j) = apodization( X, Z, radius, center);
    
    center = [1+Y/2 1+X/2 1+Z/2] + round(um*X*dXY*[-sin(theta(j)) -cos(theta(j)) 0]);
    AD2(:,:,:,j) = apodization( X, Z, radius, center);
end

% figure,
% subplot(131);plot(abs(squeeze(A(1+Y/2,:,1+Z/2,1,1))),'r','linewidth',lwidth); axis tight;
% subplot(132);plot(abs(squeeze(A(1+Y/2,:,1+Z/2,1,2))),'b','linewidth',lwidth); axis tight;
% subplot(133);plot(abs(squeeze(A(1+Y/2,:,1+Z/2,1,3))),'k','linewidth',lwidth); axis tight;

for j = 1 : Angle_No
    WFilterD0(:,:,:,j) = conj(H0)./(w_D0.^2+denD0(:,:,:,j));
    WFilterD1(:,:,:,j) = conj(H1)./(w_Dpm1.^2+denD1(:,:,:,j));
    WFilterD2(:,:,:,j) = conj(H1)./(w_Dpm1.^2+denD2(:,:,:,j));
end

for j = 1 : Angle_No
    Dhat0(:,:,:,j) = D0(:,:,:,j).*WFilterD0(:,:,:,j);
    Dhat1(:,:,:,j) = D1(:,:,:,j).*WFilterD1(:,:,:,j);
    Dhat2(:,:,:,j) = D2(:,:,:,j).*WFilterD2(:,:,:,j);
end

for j = 1 : Angle_No
    Dhat0(:,:,:,j) = Dhat0(:,:,:,j).*AD0(:,:,:,j);
    Dhat1(:,:,:,j) = Dhat1(:,:,:,j).*AD1(:,:,:,j);
    Dhat2(:,:,:,j) = Dhat2(:,:,:,j).*AD2(:,:,:,j);
end
%% Shifting the components
% for j = 1:Angle_No
%     Dhat0_ZP(:,:,:,j) = padarray(Dhat0(:,:,:,j),[Y/2 X/2 Z/2]);
%     Dhat1_ZP(:,:,:,j) = padarray(Dhat1(:,:,:,j),[Y/2 X/2 Z/2]);
%     Dhat2_ZP(:,:,:,j) = padarray(Dhat2(:,:,:,j),[Y/2 X/2 Z/2]);
% end
% clear Dhat0; Dhat0 = Dhat0_ZP; clear Dhat0_ZP;
% clear Dhat1; Dhat1 = Dhat1_ZP; clear Dhat1_ZP;
% clear Dhat2; Dhat2 = Dhat2_ZP; clear Dhat2_ZP;
% [Y X Z Angle_No] = size(Dhat0);
%
% [yy, xx, zz] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1, 0 : 1 : Z-1);
% fxx = um*xx*dXY/2;   % 2fx abscissae
% fyy = um*yy*dXY/2;   % 2fx abscissae
% Info = zeros(Y,X,Z,2);
[yy, xx, zz] = meshgrid(0 : 1 : X-1, 0 : 1 : Y-1, 0 : 1 : Z-1);
fxx = um*xx*dXY;   % 2fx abscissae
fyy = um*yy*dXY;   % 2fx abscissae
Info = zeros(Y,X,Z,2);
for j = 1 : Angle_No
    xy = cos(theta(j)).*fyy + sin(theta(j)).*fxx;
    Info(:,:,:,1) = Info(:,:,:,1) + real(IFT(Dhat0(:,:,:,j))./Angle_No);
    Info(:,:,:,2) = Info(:,:,:,2) + real(exp(-1i*2*pi*xy).*IFT(Dhat1(:,:,:,j))) + real(exp(+1i*2*pi*xy).*IFT(Dhat2(:,:,:,j)));
    %     Info(:,:,:,j,2) = abs( exp(-1i*2*pi*xy - 1i*2*pi*fzz).*IFT(Dhat1(:,:,:,j)) + exp(-1i*1*pi*xy + 1i*2*pi*fzz).*IFT(Dhat1(:,:,:,j)) );
    %     Info(:,:,:,j,3) = abs( exp(+1i*2*pi*xy - 1i*2*pi*fzz).*IFT(Dhat2(:,:,:,j)) + exp(+1i*1*pi*xy + 1i*2*pi*fzz).*IFT(Dhat2(:,:,:,j)));
end
figure;
subplot(241); imagesc(abs(squeeze(Info(    :,1+X/2,    :,1))));  title( 'Info1-YZ', 'fontsize',0.7*fsize ); axis image; colormap gray;
subplot(242); imagesc(abs(squeeze(Info(    :,    :,1+Z/2,1))));  title( 'Info1-XY', 'fontsize',0.7*fsize ); axis image; colormap gray;
subplot(246); imagesc(abs(squeeze(Info(1+Y/2,    :,    :,1)))'); title( 'Info1-XZ', 'fontsize',0.7*fsize ); axis image; colormap gray;
subplot(243); imagesc(abs(squeeze(Info(    :,1+X/2,    :,2))));  title( 'Info2-YZ', 'fontsize',0.7*fsize ); axis image; colormap gray;
subplot(244); imagesc(abs(squeeze(Info(    :,    :,1+Z/2,2))));  title( 'Info2-XY', 'fontsize',0.7*fsize ); axis image; colormap gray;
subplot(248); imagesc(abs(squeeze(Info(1+Y/2,    :,    :,2)))'); title( 'Info2-XZ', 'fontsize',0.7*fsize ); axis image; colormap gray;
%% Adding them up
I_WF = Info(:,:,:,1);

ZCC = 1;
I_SIM_1 = ZCC.*Info(:,:,:,1)+Info(:,:,:,2);
ZCC = 0;
I_SIM_0 = ZCC.*Info(:,:,:,1)+Info(:,:,:,2);
%I_SIM(I_SIM<0) = 0;
figure;
subplot(231); colormap gray; imagesc(squeeze(I_WF(    :,    :,1+Z/2)));  axis image;xlabel('X'); ylabel('Y');axis image; title( 'WF', 'fontsize',0.7*fsize ); colorbar; axis off;
subplot(234); colormap gray; imagesc(squeeze(I_WF(1+Y/2,    :,    :))');  axis image;xlabel('Z'); ylabel('Y'); title( 'WF', 'fontsize',0.7*fsize ); colorbar; axis off;
subplot(232); colormap gray; imagesc(squeeze(I_SIM_1(    :,    :,1+Z/2))); axis image;xlabel('X'); ylabel('Y');axis image; title( 'ZCC=1', 'fontsize',0.7*fsize ); colorbar; axis off;
subplot(235); colormap gray; imagesc(squeeze(I_SIM_1(1+Y/2,    :,    :))'); axis image;xlabel('Z'); ylabel('Y');axis image; title( 'ZCC=1', 'fontsize',0.7*fsize ); colorbar; axis off;
subplot(233); colormap gray; imagesc(squeeze(I_SIM_0(    :,    :,1+Z/2))); axis image;xlabel('X'); ylabel('Y');axis image; title( 'ZCC=0', 'fontsize',0.7*fsize ); colorbar; axis off;
subplot(236); colormap gray; imagesc(squeeze(I_SIM_0(1+Y/2,    :,    :))'); axis image;xlabel('Z'); ylabel('Y');axis image; title( 'ZCC=0', 'fontsize',0.7*fsize ); colorbar; axis off;
