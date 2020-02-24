% x and y data
x = [0; 5; 10; 10.1; 10.25; 10.5; 11.34; 22.83; 43; 119; 257];
y = 2*exp(-1/8*x)+1/3*exp(-2*x)+0.2*rand(length(x),1);
figure
plot(x,y)
hold on

% fit an exponential function to data
f1 = fit(x,y,'exp2');
plot(f1)

% set major axes legend, title, and labels
title('How far does the apple fall?')
xlabel('Distance from tree')
legend('Experimental Data','Multi-Exponential Fit')

%% zoomPlot to highlight a portion of the major plot
[p,z] = zoomPlot(x,y,[5 50],[0.33 0.35 0.3 0.55],[1 3]);
hold on
plot(f1)
legend hide

% Forgot to add a title/label/legend to the original plot?
p.YLabel.String = 'Apples';


%%
figure(1)
[x,y] = meshgrid( linspace(0,100, 63) , linspace(0,100,83));
Urecon = rand(83,63);
Vrecon = rand(83,63);
quiver(x,y,Urecon(:,:),Vrecon(:,:), 0.5, 'color','blue')
axis equal
xlabel('x [mm]','FontSize',12)
ylabel('y [mm]','FontSize',12)
title('Reconstruction','FontSize',12)
ah=gca;
source_pos=[40 35 70 45];
target_pos=[20 52 80 75];
zoomPlot(ah,source_pos,target_pos);
axis(ah);