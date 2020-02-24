close all; clear; clc;
run("../CIRLSetup.m");
x   = -2:0.01:2;
fx1 = (exp(+1i*2*pi*.1*x));
fx2 = (exp(+1i*2*pi*.1*x).*exp(-1i*(2*pi*3*x + 0.1)));
fx1FT = FT(fx1);
fx2FT = FT(fx2);
% figure;
% plot(x,fx1);
% hold on; plot(x,fx2);
figure;
plot(x,abs(fx1FT));
hold on; plot(x,abs(fx2FT));

real(sum(xcorr(fx1FT, fx2FT)))

reFx2 = (exp(+1i*2*pi*3*x).*fx2);
reFx2FT = FT(reFx2);
real(sum(xcorr(fx1FT, reFx2FT)))
figure;
plot(x,abs(fx1FT));
hold on; plot(x,abs(reFx2FT));
