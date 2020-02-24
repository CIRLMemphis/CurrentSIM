function ret = MSESSIMtoTex(MSE, SSIM, txt)
ret = "\begin{table}[H]" + newline;
ret = ret + "\begin{tabular}{c|";
for ind = 1:length(MSE)
    ret = ret + "c|";
end

ret = ret + "}" + newline;
ret = ret + "\cline{2-3}" + newline;

ret = ret + "                       ";
for ind = 1:length(MSE)
    ret = ret + " & " + txt(ind);
end
ret = ret + " \\ \hline" + newline;

ret = ret + "\multicolumn{1}{|c|}{MSE} ";
for ind = 1:length(MSE)
    ret = ret + " & " + MSE(ind);
end
ret = ret + " \\ \hline" + newline;

ret = ret + "\multicolumn{1}{|c|}{SSIM} ";
for ind = 1:length(MSE)
    ret = ret + " & " + SSIM(ind);
end
ret = ret + " \\ \hline"  + newline;
ret = ret + "\end{tabular}" + newline;
ret = ret + "\end{table}" + newline;
end