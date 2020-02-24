x = -1:0.005:1;
[xx,yy] = meshgrid(x, x);
X = size(xx,1);
Y = size(xx,2);
fxx = zeros(size(xx));
N = 63;
xpi = zeros(N,1);
for j = 1:N
    xpi(j) = (j-1)*pi/(N-1)+pi/(N-1)/2;
end

for xi = 1:X
    for yi = 1:Y
        for j = 1:2:length(xpi)
            if (j == 1 && (abs(xx(xi,yi)) <= tan(xpi(j))*abs(xx(xi,xi))))
                fxx(xi,yi) = 1;
            elseif ((abs(xx(xi,yi)) <= tan(xpi(j))*abs(xx(xi,xi))) &&...
                (abs(xx(xi,yi)) >= tan(xpi(j-1))*abs(xx(xi,xi))))
                fxx(xi,yi) = 1;
            end
        end
    end
end
figure; imagesc(fxx); axis square;