function [f] = demComp(theta, g,um,dXY)


% Initialize some useful values
[X Y no] = size(g); % number of training examples

% You need to return the following variables correctly 
f = zeros(X,Y,no);

chi = 1/4 * csc((theta(1)-theta(2))/2)*csc((theta(1)-theta(3))/2)*csc((theta(2)-theta(3))/2);

f(:,:,1)=chi*((g(:,:,1)-g(:,:,2))*exp(1i*theta(3))+(g(:,:,2)-g(:,:,3))*exp(1i*theta(1))+(g(:,:,3)-g(:,:,1))*exp(1i*theta(2)))/(1i*cos(theta(1)+theta(2)+theta(3))-sin(theta(1)+theta(2)+theta(3)));%Fminus1
f(:,:,2)=chi *(g(:,:,3)*sin(theta(1)-theta(2)) - g(:,:,2) *sin(theta(1)-theta(3))+ g(:,:,1) *sin(theta(2)-theta(3)));%widefield component
f(:,:,3)=1i*chi*((g(:,:,1)-g(:,:,2))*exp(1i*(theta(1)+theta(2)))+(g(:,:,2)-g(:,:,3))*exp(1i*(theta(2)+theta(3)))+(g(:,:,3)-g(:,:,1))*exp(1i*(theta(1)+theta(3))))/(cos(theta(1)+theta(2)+theta(3))+1i*sin(theta(1)+theta(2)+theta(3)));%Fplus1



end