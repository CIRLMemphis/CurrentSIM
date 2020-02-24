function [ Masks ] = Grating_2D( Phases, Angle, fgr, DC, ModDepth, XY, dXY, show )

[yy, xx] = meshgrid(0 : 1 : XY-1);
fxx = fgr*xx*dXY;               % 2fx abscissae
fyy = fgr*yy*dXY;               % 2fx abscissae
Angle_No = length(Angle);
Ph_No = length(Phases);
phi = pi*Phases/180;   % phi in radians
theta = pi*Angle/180;
Masks = zeros( XY, XY, Angle_No, Ph_No );

for i = 1:Angle_No
    for j = 1:Ph_No
%         Masks(:,:,i,j) = 0.5 * ( ones(XY,XY) + ...
%             ModDepth * cos( pi * ( (cos(theta(i)).*fyy + sin(theta(i)).*fxx) + phi(j) ) ) .*cos( pi * ( (cos(theta(i)).*fyy + sin(theta(i)).*fxx) + phi(j) ) ) + ...
%             cos( 2*pi * ( (cos(theta(i)).*fyy + sin(theta(i)).*fxx) + phi(j) ) )); % Fourier synthesis of square wave
        Masks(:,:,i,j) = DC.*ones(XY,XY) + ModDepth.*cos( 2*pi*(cos(theta(i)).*fyy + sin(theta(i)).*fxx) + phi(j)  ); % Fourier synthesis of square wave
    end
end

if show == true
    figure;
    ct = 0;
    for j = 1 : Ph_No
        for i = 1 : Angle_No
            ct = ct + 1;
            subplot(Ph_No,Angle_No,ct); imshow( Masks(:,:,i,j) ); axis tight;
            %title(strcat('Orientation: ', num2str(Angle(i)), ', Phase: ', num2str(Phases(j))));
        end
    end
    %xlabel('microns');
end

% j=1;
% Z=XY;
% Mask = repmat( Masks(:,:,1,1), [1 1 Z] );
% 
% figure, imshow( squeeze(Mask(:,:,1+Z/4)),[] ); axis tight;
% figure, imshow( squeeze(Mask(1+XY/4,:,:)),[] ); axis tight;
% export_fig('-png','-opengl','-r500','4_');