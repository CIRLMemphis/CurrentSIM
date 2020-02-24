% use exact parameters and setup.
run("ExpTunable071719BeadSetup.m");
matFile = CIRLDataPath + "/TunableData/071719_3slit_6umBead/FSIM_071719_3S_6umBead_SR100mw64ms.mat";
load(matFile)

%%
x = 0:1:X-1;
for k = 1:size(g,5)
    gCur = g(1+X/2,:,1+Z/2,1,k);
    gCur = gCur/max(gCur(:));
    y = cos(2*pi*omegaXY(k)*x*dXY + phi(k)*pi/180);
    figure; plot(gCur);
    hold on; plot((y+1)/10+0.8)
end