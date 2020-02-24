clear
load('curImg.mat')
%load('CurEnv.mat')
load('CurEnv_temp.mat')

%%
zBF    = 129;
envBF  = reshape(env(:,zBF), [1 512]);
tmpImg = curImg./envBF;
figure
subplot(121); imagesc(curImg); axis square; colormap jet; title('o(x,z)env(x,z)');
subplot(122); imagesc(tmpImg); axis square; colormap jet; title('o(x,z)');

%%
figure;
for zInd = 1:256
    envBF = reshape(env(:,zInd), [1 512]);
    tmpImg = curImg./envBF;
    subplot(121); imagesc(curImg); axis square; colormap jet; title('before');
    subplot(122); imagesc(tmpImg); axis square; colormap jet; title('after');
end


%%
figure;
for zInd = 129:129
    envBF = reshape(env(:,zInd), [1 512]);
    for shiftInd = 1:2:200
        envBF  = circshift(envBF, 1);
        tmpImg = curImg./envBF;
        subplot(121); imagesc(curImg); axis square; colormap jet; title('before');
        subplot(122); imagesc(tmpImg); axis square; colormap jet; title('after');
    end
end