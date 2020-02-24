run("../../CIRLSetup.m");
colormapSet = 'jet';
colorScale  = [0 1.0];
shouldScale = 0;
xzRegionX   = 450:650;
xzRegionZ   =   1:50;
xyRegionX   = 300:800;
xyRegionY   = 300:600;
yBest       = 512;
zBest       = 5;

%% load the reconstruction results
FileTif      = 'C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\FairSIMData\OMX_LSEC_Actin_525nm_SIF.tif';
InfoImage    = imfinfo(FileTif);
mImage       = InfoImage(1).Width;
nImage       = InfoImage(1).Height;
NumberImages = length(InfoImage);
reconOb      = zeros(nImage,mImage,NumberImages,'uint16');
for i = 1:NumberImages
    reconOb(:,:,i) = imread(FileTif,'Index',i);
end

reconOb    = double(reconOb);
figure; imagesc(reconOb(513:end,513:end,6)); axis square; colormap jet; xlabel('x'); ylabel('y');

%% load the reconstruction results
FileTif      = 'C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\FairSIMData\OMX_LSEC_Actin_525nm_Denom.tif';
InfoImage    = imfinfo(FileTif);
mImage       = InfoImage(1).Width;
nImage       = InfoImage(1).Height;
NumberImages = length(InfoImage);
reconOb      = zeros(nImage,mImage,NumberImages,'uint16');
for i = 1:NumberImages
    reconOb(:,:,i) = imread(FileTif,'Index',i);
end

reconOb    = double(reconOb);
figure; imagesc(reconOb(513:end, 513:end, 5)); axis square; colormap hot;


%% load the reconstruction results
FileTif      = 'C:\Users\cvan\OneDrive - The University of Memphis\CIRLData\FairSIMData\OMX_LSEC_Actin_525nm_Shifted.tif';
InfoImage    = imfinfo(FileTif);
mImage       = InfoImage(1).Width;
nImage       = InfoImage(1).Height;
NumberImages = length(InfoImage);
reconOb      = zeros(nImage,mImage,NumberImages,'uint16');
for i = 1:NumberImages
    reconOb(:,:,i) = imread(FileTif,'Index',i);
end

reconOb    = double(reconOb);
figure; imagesc(reconOb(513:end, 513:end, 5)); axis square; colormap hot;


%%
filename = 'C:\Users\cvan\Documents\fairSIM3D\invFullResult.dat';
delimiterIn = '\n';
A = importdata(filename,delimiterIn);
ACplx = complex(zeros(length(A)/2, 1),0);
for i = 1:length(A)/2
    ACplx(i) = A(2*i-1) + 1i*A(2*i);
end
reconOb = real(reshape(ACplx, [1024, 1024, 7]));
temp = reconOb(513:end,513:end,6);
tempFlip = flip(temp, 2);
tempFlip(tempFlip < 0) = 0;
figure; imagesc(tempFlip); axis square;


%%
filename = 'C:\Users\cvan\Documents\fairSIM3D\APO.dat';
delimiterIn = '\n';
A = importdata(filename,delimiterIn);
ACplx = complex(zeros(length(A)/2, 1),0);
for i = 1:length(A)/2
    ACplx(i) = A(2*i-1) + 1i*A(2*i);
end
reconOb = real(fftshift(reshape(ACplx, [1024, 1024, 7])));

%%
temp = reconOb(:,:,4);
tempFlip = flip(temp, 2);
tempFlip(tempFlip < 0) = 0;
figure; imagesc(tempFlip); axis square;





%% OTFs
filename = 'C:\Users\cvan\Documents\fairSIM3D\OTF0.dat';
A = load(filename);
ACplx = complex(A(1:2:end), A(2:2:end));
reconOb = real(fftshift(reshape(ACplx, [1024, 1024, 7])));

%%
temp = reconOb(:,:,4);
tempFlip = flip(temp, 2);
figure; imagesc(tempFlip); axis square;



%% load HR OTFs from files
Hn2 = zeros(1024,1024,7,5);
for ind = 1:5
    filename = char("C:\Users\cvan\Documents\fairSIM3D\HROTF" + (ind-1) + ".dat");
    A = load(filename);
    ACplx = complex(A(1:2:end), A(2:2:end));
    Hn2(:,:,:,ind) = fftshift(reshape(ACplx, [1024, 1024, 7]));
end

%% load LR OTFs from files with 13 slices
Hn = zeros(512,512,13,5);
for ind = 1:5
    filename = char("C:\Users\cvan\Documents\fairSIM3D\LROTF" + (ind-1) + ".dat");
    A = load(filename);
    ACplx = complex(A(1:2:end), A(2:2:end));
    Hn(:,:,:,ind) = fftshift(reshape(ACplx, [512, 512, 13]));
end
save('FairSIMGreenLRHn_512_512_13', 'Hn');

for ind = 1:5
    filename = char("C:\Users\cvan\Documents\fairSIM3D\HROTF" + (ind-1) + ".dat");
    A = load(filename);
    ACplx = complex(A(1:2:end), A(2:2:end));
    Hn(:,:,:,ind) = fftshift(reshape(ACplx, [512, 512, 13]));
end
save('FairSIMGreenHRHn_512_512_13', 'Hn');