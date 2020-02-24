function [J, Fm1] = newcostFunction(theta, g, um,dXY)


% Initialize some useful values
[X Y no] = size(g); % number of training examples

% You need to return the following variables correctly 
fm1 = zeros(X,Y);
Fm1 = zeros(X,Y);
J = 0;


[ftemp]= demComp(theta, g,um,dXY);
fm1=ftemp(:,:,1);
Fm1=FT(fm1);


Index_Fp = round(1+X/2+dXY*X*um);
Index_Fm = round(1+X/2-dXY*X*um);

J = 1 - (abs(Fm1(1+Y/2,Index_Fm))-abs(Fm1(1+Y/2,Index_Fp)))/(abs(Fm1(1+Y/2,Index_Fm))+abs(Fm1(1+Y/2,Index_Fp)));

% fprintf('theta: %f\n', theta);

end