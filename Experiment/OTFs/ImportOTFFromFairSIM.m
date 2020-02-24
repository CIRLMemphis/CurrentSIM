%% load LR OTFs from txt files from FairSIM3D
Z  = 53;
Hn = zeros(512,512,Z,5);
for ind = 1:5
    filename = char("C:\Users\cvan\Documents\fairSIM3D\LROTF" + (ind-1) + ".dat");
    A = load(filename);
    ACplx = complex(A(1:2:end), A(2:2:end));
    Hn(:,:,:,ind) = fftshift(reshape(ACplx, [512, 512, Z]));
end
save(char("FairSIMGreenLRHn_512_512_" + Z), 'Hn');

for ind = 1:5
    filename = char("C:\Users\cvan\Documents\fairSIM3D\HROTF" + (ind-1) + ".dat");
    A = load(filename);
    ACplx = complex(A(1:2:end), A(2:2:end));
    Hn(:,:,:,ind) = fftshift(reshape(ACplx, [512, 512, Z]));
end
save(char("FairSIMGreenHRHn_512_512_" + Z), 'Hn');