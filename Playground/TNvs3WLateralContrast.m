y       = 0:0.01:5;
omegaXY = 2;
iTN     = 1 + cos(2*pi*omegaXY*y);
i3W     = 1 + 2/3*cos(2*pi*omegaXY*y) + 4/3*cos(2*pi*omegaXY*y/2);
figure;
plot(y,iTN,'DisplayName','Tunable');
hold on;
plot(y,i3W,'DisplayName','3W');
legend;

iTNFT = abs(fftshift(fft(iTN)));
i3WFT = abs(fftshift(fft(i3W)));
figure;
plot(y,iTNFT,'DisplayName','Tunable FT');
hold on;
plot(y,i3WFT,'DisplayName','3W FT');
legend;

%%
uniOb = y.^2;
iTNOb = conv(iTN, uniOb, 'same');
i3WOb = conv(i3W, uniOb, 'same');
figure;
plot(y, iTNOb,'DisplayName','Tunable*Ob');
hold on;
plot(y, i3WOb,'DisplayName','3W*Ob');
legend;

%%
iTNObFT = abs(fftshift(fft(iTNOb)));
i3WObFT = abs(fftshift(fft(i3WOb)));
figure;
plot(y,iTNObFT,'DisplayName','Tunable*Ob FT');
hold on;
plot(y,i3WObFT,'DisplayName','3W*Ob FT');
legend;