run("Sim3W3Dp4S6StarNew512Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3W3Dp4S6StarNew256SNR15dB.mat";
load(matFile);

%% rescale noisy data (due to scaling factor while adding noises)
g = g/max(g(:));

FileTif = char(CIRLDataPath + "/Simulation/3W/Sim3W3Dp4S6StarNew256SNR15dB.tif");
[Y, X, Z, Nalp, Nphi] = size(g);
for j = 1:Nalp
    for k = 1:Z
        for i = 1:Nphi
            imwrite(g(:,:,k,j,i)', FileTif, 'WriteMode', 'append');
        end
    end
end