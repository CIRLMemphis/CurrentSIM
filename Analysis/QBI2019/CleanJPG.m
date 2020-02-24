function CleanJPG(filename, off, leftX, leftY, rightX, rightY)
if (nargin < 2)
    off = 1;
end
A  = imread(filename);
if (nargin < 2)
    leftX  = 50;
    rightX = size(A,1) - 585;
    leftY  = 186;
    rightY = size(A,2) - 721;
    XA = size(A,1);
    YA = size(A,2);
    Acut = A(leftX:XA-rightX, leftY:YA-rightY,:);
    Acut = Acut(off:(size(Acut,1)-off+1), off:(size(Acut,2)-off+1), :);
else
    Acut = A(leftX:rightX, leftY:rightY,:);
    Acut = Acut(off:(size(Acut,1)-off+1), off:(size(Acut,2)-off+1), :);
end

imwrite(Acut, filename);
end