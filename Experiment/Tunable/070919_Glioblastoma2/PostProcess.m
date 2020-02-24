run('../../../CIRLSetup.m');
%load(CIRLDataPath + "\Results\071719Glio\201912151756_ExpTunableOptMB071719GlioNoDouble_SR100mw2500msAber5\201912151756_ExpTunableOptMB071719GlioNoDouble_SR100mw2500msAber5.mat", 'retVars');
%load(CIRLDataPath + "\Results\071719Glio\201912152100_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5Reg1e4\201912152100_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5Reg1e4.mat", 'retVars');
%load(CIRLDataPath + "\Results\071719Glio\201912152057_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5\201912152057_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5.mat", 'retVars');
load(CIRLDataPath + "\Results\071719Glio\201912160937_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5Reg1e3\201912160937_ExpTunableOptMBPC071719GlioNoDouble_SR100mw2500msAber5Reg1e3.mat", 'retVars');

%%
iterInd = 8;
reconOb = retVars{iterInd};
reconOb(reconOb < 0) = 0;

reconFT = FT(reconOb);
reconFT(:, 350:385, :) = 0;
reconFT(:, 130:160, :) = 0;
reconFT(:, 472:482, :) = 0;
reconFT(:,  32:42 , :) = 0;
cleanRecon = abs(IFT(reconFT));

%%
zInd = 127;
figure;
subplot(221); imagesc(reconOb   (:,:,zInd)); axis square;xlabel('x');ylabel('y');
subplot(222); imagesc(cleanRecon(:,:,zInd)); axis square;xlabel('x');ylabel('y');
subplot(223); imagesc(squeeze(reconOb   (257,:,:))'); axis image ;xlabel('x');ylabel('z');
subplot(224); imagesc(squeeze(cleanRecon(257,:,:))'); axis image ;xlabel('x');ylabel('z');

%%
figure;
subplot(211); imagesc(reconOb        (:,:,zInd)) ; axis square;xlabel('x');ylabel('y');
subplot(212); imagesc(squeeze(reconOb(257,:,:))'); axis image ;xlabel('x');ylabel('z');