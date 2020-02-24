% this script load the experimental OTFs and generate the 
% PSF and patterns of the desired sizes
run('../../CIRLSetup.m');

%% desired sizes
X = 512;
Y = 512;
Z = 53;

%%
load(CIRLDataPath + "/FairSimOTFs/FairSIMGreenHRHn_512_512_7.mat");
[XHn, YHn, ZHn, Nphi] = size(Hn);
Hn = padarray(Hn, [(X - XHn)/2, (Y - YHn)/2, (Z - ZHn)/2, 0]);

%%
figure; 
subplot(2,2,1); imagesc(abs(Hn(:,:, round(Z/2),1))); axis image;
subplot(2,2,2); imagesc(abs(Hn(:,:, round(Z/2),2))); axis image;
subplot(2,2,3); imagesc(abs(squeeze(Hn(1+X/2,:, :,1))'));  axis square;
subplot(2,2,4); imagesc(abs(squeeze(Hn(1+X/2,:, :,2))'));  axis square;

%% Apply IFT to get the PSF and pattern
hn = zeros(X,Y,Z,Nphi);
for k = 1:Nphi
    hn(:,:,:,k) = real(IFT(Hn(:,:,:,k)));
end
h  = abs(hn(:,:,:,1));
vn = hn(1,1,:,2)./hn(1,1,:,1);

%%
figure; imagesc(log(h(:,:,round(Z/2)))); axis square;
figure; plot(squeeze(vn))