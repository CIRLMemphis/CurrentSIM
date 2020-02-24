run("Sim3WOSSRMultiOb512Setup.m");
matFile = CIRLDataPath + "/Simulation/3W/Sim3WOSSRMultiOb256.mat";
load(matFile);

FileTif = char(CIRLDataPath + "/Simulation/3W/Sim3WOSSRMultiOb256.tif");
[Y, X, Z, Nalp, Nphi] = size(g);
for j = 1:Nalp
    for k = 1:Z
        for i = 1:Nphi
            imwrite(g(:,:,k,j,i)', FileTif, 'WriteMode', 'append');
        end
    end
end