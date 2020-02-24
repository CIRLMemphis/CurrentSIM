% Test matlab column based
X = 300;
Y = 300;
Z = 300;
B  = rand(Y,Z);
A  = rand(X,Y,Z);
AT = permute(A, [3,1,2]);
tic
ret = 0;
for i = 1:10
   for row = 1:Z
       temp = A(:, :, row);
       ret = ret + dot(temp(:), B(:));
   end
end
toc

tic
retT = 0;
for i = 1:10
   for row = 1:Z
       temp = AT(row, :, :);
       retT = retT + dot(temp(:), B(:));
   end
end
toc

ret - retT