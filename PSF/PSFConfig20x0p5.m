function [ psfpar, psfpari ] = PSFConfig20x0p5( )

distToCoverslip = 0;    % distance to cover slip, for a descending axis use a negative value
ni = 1.0;  niD = 1.0;  % ni/niD-actual/design immersion index
ng = 1.52; ngD = 1.52; % ng/ngD-actual/design cover-slip index
tg = 170;  tgD = 170;     % ti/tiD-actual/design cover-slip thickness [microns]
ns = 1.47; ts  = distToCoverslip; % ns/ts-actual index/depth[microns] of/into sample
tiD = 2000;            % tiD working-distance
% observation
NA = 0.5;                % NA/num aperture
Lambda = 0.515;          % wavelength [microns]
% illumination
NAi = 0.5;               % NA/num aperture
Lambdai = 0.515;         % wavelength [microns]

psfpar = psfparameter(...
    NA,...               % Numerical aperture objective
    [niD ngD],...        % Vector of design refractive indices [immersion, coverglass]
    [ni ng ns],...       % Vector of actual refractive indices [immersion, coverglass, stratum embedding]
    [tiD, tgD],...       % Vector of design thickness [working distance, coverglass]
    [0, tg, ts],...      % Vector of actual thickness [0, coverglass, stratum embedding]
    [Lambda Lambda]);    % Vector of used wavelengths [detection, illumination]

psfpari = psfparameter(...
    NAi,...              % Numerical aperture objective
    [niD ngD],...        % Vector of design refractive indices [immersion, coverglass]
    [ni ng ns],...       % Vector of actual refractive indices [immersion, coverglass, stratum embedding]
    [tiD, tgD],...       % Vector of design thickness [working distance, coverglass]
    [0, tg, ts],...      % Vector of actual thickness [0, coverglass, stratum embedding]
    [Lambdai Lambdai]);  % Vector of used wavelengths [detection, illumination]
