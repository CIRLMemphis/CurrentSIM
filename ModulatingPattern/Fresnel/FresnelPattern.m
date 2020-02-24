function I0Signal = FresnelPattern(eta, N_Slits, X, Z, dXY, dZ, lambda, n, delta, x0, fL1, fL2, fMO)
% eta                   % mm position of biprism from source
% N_Slits               % number of slits
% lambda = 488 * 10^-6;   % mm wavelength of source
% n      = 1.515;         % Refractive Index of biprism
% delta  = 2.5*pi/180;    % (in degree) radians biprism angle
% x0     = .100;          % mm slit seperation
% %DELTA  = 0.070;        % mm slit width
% fL1      = 100;         % mm focal length of converging lens
% fL2      = 250;         % mm focal length of converging lens
% fMO      = 8;           % mm focal length of converging lens
FresnelComp = @(t) fresnelc(t) + 1i*fresnels(t);

u0 = (n-1)*tan(delta)/lambda;   % mm^-1
ML = @(z) z./fL1;

% Therotical axial and lateral frwequency calcualtion (Eq. 3-1 and 3-2) from Chris thesis.
umx_theory = 2*eta*u0/fL1; %from equation (2) Doblas. x is normalized by (2*pi)/p. theroretical calculation
umx_theory = (2*eta*u0*fL2)*10^-3/(fL1*fMO); % l/um

%p = (lambda*f) / (2*eta*(n-1)*tan(delta)) % lateral period
zTheoreticalPeriod = 2 *(fL1/x0)*1/(2*u0)*(fL1/eta); %theroretical calculation
umz_theory = 1/zTheoreticalPeriod; %theroretical calculation
umz_theory = (umx_theory*x0*fL2)/(2*fMO*fL1); % l/um

%X and Z Scaling
xscale = (eta/fL1) * (X/2) * dXY; % (scaling ratio for biprism position) * (inverse scaling factor for Doblas normalization) * (mm/pixel)
xscale = ((eta*fL2)/(fL1*fMO)) * dXY; 

zscale = (eta/fL1) * dZ; % mm/pixel
zscale = ((eta*(fL2.^2)*x0)/((fL1*fMO).^2)) * dZ; % mm/pixel

% Create XZ Domain Space and U Frequency space
z = linspace(1,zscale*Z,Z);
x = linspace(-1*xscale*(X/2),1*xscale*(X/2),X); %x is normalized from -1 to 1

% setup grid
z = repmat(z,size(x,2),1);
x = repmat(x(:),1,size(z,2));

% %The slit width transfer function is a rect in space domain (sinc in
% %frequency domain)
% T = (DELTA*z/f) ; %  * f/eta *.01
% FTSlitWidthTransferFunction = 1/mmPerPixel*T.* sinc(T.*u ); %1/mmPerPixel*T.* %broken 2/8/16,
% % setting a small DELTA (<.005) will make this function = 1, thus not
% % affecting the simulation
% % FTSlitWidthTransferFunction = (DELTA*ML(z)).*(xdim/2).*sinc(DELTA*ML(z).*u); alternate

%Irradiance Signal (Doblas, Eq. 10)
beta = fL1.^2 + eta.*z - eta.*fL1;
gammap = sqrt(2.*eta./lambda).*(fL1.*x+lambda.*u0.*beta)./(fL1.*beta.^0.5);
gamman = sqrt(2.*eta./lambda).*(fL1.*x-lambda.*u0.*beta)./(fL1.*beta.^0.5);
C = @(t) fresnelc(t);
S = @(t) fresnels(t);
env = 1 + C(gammap) + S(gammap) - C(gamman) - S(gamman) + C(gammap).^2 + S(gammap).^2 + C(gamman).^2 + S(gamman).^2;
VC = 1 + C(gammap) + S(gammap) - C(gamman) - S(gamman) - 2.*C(gammap).*C(gamman) - 2.*S(gammap).*S(gamman);
VS = -C(gammap) + S(gammap) - C(gamman) + S(gamman) + 2.*C(gammap).*S(gamman) - 2.*C(gamman).*S(gammap);
fm = 2.*u0.*eta./fL1;
I0 = @(z,x) env + VC.*cos(2.*pi.*fm.*x) + VS.*sin(2.*pi.*fm.*x);
%% Multi SLITS
switch N_Slits
case 1
    I0Signal = I0(z,x);
    %I0Signal = real(ifft(fft(I0Signal).*FTSlitWidthTransferFunction));
case 3
    I0ThreeSlits = @(z,x) I0(z,x+x0.*z/fL1) + I0(z,x) + I0(z,x-x0.*z/fL1);
    I0Signal = I0ThreeSlits(z,x);
case 5
    I0ThreeSlits = @(z,x) I0(z,x+2*x0.*z/fL1) + I0(z,x+x0.*z/fL1) + I0(z,x) + I0(z,x-x0.*z/fL1) + I0(z,x-2*x0.*z/fL1);
    I0Signal = I0ThreeSlits(z,x);
case 7
    I0ThreeSlits = @(z,x) I0(z,x+3*x0.*z/fL1) + I0(z,x+2*x0.*z/fL1) + I0(z,x+x0.*z/fL1) + I0(z,x) + I0(z,x-x0.*z/fL1) + I0(z,x-2*x0.*z/fL1) + I0(z,x-3*x0.*z/fL1);
    I0Signal = I0ThreeSlits(z,x);
case 9
    I0ThreeSlits = @(z,x) I0(z,x+4*x0.*z/fL1) + I0(z,x+3*x0.*z/fL1) + I0(z,x+2*x0.*z/fL1) + I0(z,x+x0.*z/fL1) + I0(z,x) + I0(z,x-x0.*z/fL1) + I0(z,x-2*x0.*z/fL1) + I0(z,x-3*x0.*z/fL1) + I0(z,x-4*x0.*z/fL1);
    I0Signal = I0ThreeSlits(z,x);
case 11
    I0ThreeSlits = @(z,x) I0(z,x+5*x0.*z/fL1) + I0(z,x+4*x0.*z/fL1) + I0(z,x+3*x0.*z/fL1) + I0(z,x+2*x0.*z/fL1) + I0(z,x+x0.*z/fL1) + I0(z,x) + I0(z,x-x0.*z/fL1) + I0(z,x-2*x0.*z/fL1) + I0(z,x-3*x0.*z/fL1) + I0(z,x-4*x0.*z/fL1) + I0(z,x-5*x0.*z/fL1);
    I0Signal = I0ThreeSlits(z,x);
case 13
    I0ThreeSlits = @(z,x) I0(z,x+6*x0.*z/fL1) + I0(z,x+5*x0.*z/fL1) + I0(z,x+4*x0.*z/fL1) + I0(z,x+3*x0.*z/fL1) + I0(z,x+2*x0.*z/fL1) + I0(z,x+x0.*z/fL1) + I0(z,x) + I0(z,x-x0.*z/fL1) + I0(z,x-2*x0.*z/fL1) + I0(z,x-3*x0.*z/fL1) + I0(z,x-4*x0.*z/fL1) + I0(z,x-5*x0.*z/fL1) + I0(z,x-6*x0.*z/fL1);
    I0Signal = I0ThreeSlits(z,x);
case 21
    I0ThreeSlits = @(z,x) I0(z,x+10*x0.*z/fL1) + I0(z,x+9*x0.*z/fL1) + I0(z,x+8*x0.*z/fL1) + I0(z,x+7*x0.*z/fL1) + I0(z,x+6*x0.*z/fL1) + I0(z,x+5*x0.*z/fL1) + I0(z,x+4*x0.*z/fL1) + I0(z,x+3*x0.*z/fL1) + I0(z,x+2*x0.*z/fL1) + I0(z,x+x0.*z/fL1) + I0(z,x) + I0(z,x-x0.*z/fL1) + I0(z,x-2*x0.*z/fL1) + I0(z,x-3*x0.*z/fL1) + I0(z,x-4*x0.*z/fL1) + I0(z,x-5*x0.*z/fL1) + I0(z,x-6*x0.*z/fL1) + I0(z,x-7*x0.*z/fL1) + I0(z,x-8*x0.*z/fL1) + I0(z,x-9*x0.*z/fL1)  + I0(z,x-10*x0.*z/fL1);
    I0Signal = I0ThreeSlits(z,x);
end
%% Auto save .mat
% "PRISM_WAVELENGTH_SLITSEPARATION_BIPRISMPOSITION_FOCALLENGTHOFCONVERGINGLENS_SLITWIDTH_XZDIMENSIONS_MMPERPIXEL_ZMMPERPIXEL.MAT"
% biprismAngle = 180 - delta*360/pi;
% wavelength =  lambda*10^6;
% slitWidth = DELTA*10^3;
% filename = sprintf('FBP2020G-%g_%gnm_%.3fmmslits_%gEta_%gFocal_%gumSlitWidth_%gx%g_%gx_%gzmmperpixel.mat',biprismAngle,wavelength,x0,eta,f,slitWidth,xdim,zdim,mmPerPixel,zmmperpixel)
% save(filename);