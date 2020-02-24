run('../../CIRLSetup.m');

%% load the forward images
FileTif      = 'C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\NikonData\U383-004.tif';
InfoImage    = imfinfo(FileTif);
mImage       = InfoImage(1).Width;
nImage       = InfoImage(1).Height;
NumberImages = length(InfoImage);
chNo         = 2;
nd2Imgs      = zeros(nImage,mImage,NumberImages/2,chNo,'uint16');
for i = 1:NumberImages/2
    nd2Imgs(:,:,i,1) = imread(FileTif,'Index',2*(i-1)+1);
    nd2Imgs(:,:,i,2) = imread(FileTif,'Index',2*(i-1)+2);
end

%% make forward images
Nthe = 3;
Nphi = 5;
X    = nImage/Nthe;
Y    = mImage/Nphi;
Z    = NumberImages/2;
g    = zeros(X,Y,Z, Nthe, Nphi, chNo);
for chInd = 1:chNo
    for ind = 1:Z
        currentImg = nd2Imgs(:,:,ind,chInd);
        for l = 1:Nthe
            for k = 1:Nphi
                g(:,:,ind,l,k,chInd) = currentImg((X*(l-1)+1):X*l, (Y*(k-1)+1):Y*k);
            end
        end
    end
end

%% check the fourier transform of the forward images
gFT = zeros(X,Y,Z,Nthe,Nphi,chNo);
for chInd = 1:chNo
    for l = 1:Nthe
        for k = 1:Nphi
            gFT(:,:,:,l,k,chInd) = abs(FT(g(:,:,:,l,k,chInd)));
        end
    end
end

%%
lThe  = 1;
chInd = 1;
zInd  = round(Z/2);
for k = 1:Nphi
    fig = figure; 
    fig.WindowState = 'maximized';
    subplot(1,2,1); imagesc(      g(:,:,zInd,lThe,k,chInd)) ; axis square; colormap jet; xlabel('x'); ylabel('y');
    title(char("forward image at phase " + k + ", orientation " + lThe));
    subplot(1,2,2); imagesc(log(gFT(:,:,zInd,lThe,k,chInd))); axis square; colormap jet; xlabel('u'); ylabel('v');
    title(char("log(FT(...)) at phase " + k + ", orientation " + lThe));
    saveas(fig, char("U383_003_" + lThe + "_" + k + ".jpg"));
end



%% load the reconstruction results
FileTif      = 'C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\NikonData\U383-004_Reconstructed.tif';
InfoImage    = imfinfo(FileTif);
mImage       = InfoImage(1).Width;
nImage       = InfoImage(1).Height;
NumberImages = length(InfoImage);
chNo         = 2;
imgs         = zeros(nImage,mImage,NumberImages/2,chNo,'uint16');
for i = 1:NumberImages/2
    imgs(:,:,i,1) = imread(FileTif,'Index',2*(i-1)+1);
    imgs(:,:,i,2) = imread(FileTif,'Index',2*(i-1)+2);
end

fig = figure; 
fig.WindowState = 'maximized';
imagesc(imgs(:,:,zInd,chInd)); axis square; colormap jet; xlabel('x'); ylabel('y');
title(char("Nikon reconstructed result at slice " + zInd));
saveas(fig, char("U383_003_recon_slice" + zInd + ".jpg"));