% TODO: from equation ... in the document
function omegaz = OmegaZ(omegaXY, lambda)
if (max(lambda*omegaXY/2) > 1)
    error('3W computation of omegaZ has problem! Check the value of lambda and omegaXY!');
end
omegaz = (1 - sqrt(1 - (lambda*omegaXY/2).^2))/lambda;
end