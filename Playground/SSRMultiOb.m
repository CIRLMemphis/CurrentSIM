%% load the original high resolution object
factr = 4;
X     = 256*factr;
Y     = 256*factr;
Z     = 256*factr;
dXY   = 0.025/factr;
dZ    = 0.025/factr;
SSROb = SSRMultiObject(X, Z, dXY, dZ);
figure; plot(SSROb(1+Y/2, :, 1+Z/2));