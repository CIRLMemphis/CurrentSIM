% add the 2D-GWF restored image
FileTif      = 'C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\Results\3Dp4S6StarNew\Sim3W3Dp4S6StarNew256SNR15dB_FairSIM.tif';
InfoImage    = imfinfo(FileTif);
mImage       = InfoImage(1).Width;
nImage       = InfoImage(1).Height;
NumberImages = length(InfoImage);
reconOb      = zeros(nImage,mImage,NumberImages+floor(NumberImages/2)*2,'uint16');
for i = 1:NumberImages
    reconOb(:,:,2*(i-1)+1) = imread(FileTif,'Index',i);
end
for i = 2:2:size(reconOb,3)
    if (i+1 <= size(reconOb,3))
        reconOb(:,:,i) = (reconOb(:,:,i-1) + reconOb(:,:,i+1))/2;
    else
        reconOb(:,:,i) = reconOb(:,:,i-1);
    end
end
reconOb    = double(reconOb);


%%
figure;
subplot(121); imagesc(squeeze(reconOb(:,:,257)) ); axis square;
subplot(122); imagesc(squeeze(reconOb(257,:,:))'); axis square;