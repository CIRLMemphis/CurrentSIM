function [im_ch1, im_ch2] = nd2read(filename, varargin)
tic
finfo = nd2finfo(filename);
disp(['analyzing file structure used ', sprintf('%0.2f', toc), ' seconds'])

im_ch1 = zeros(finfo.img_width, finfo.img_height, finfo.img_seq_count, 'uint16');
im_ch2 = zeros(finfo.img_width, finfo.img_height, finfo.img_seq_count, 'uint16');

fid = fopen(filename, 'r');
offsets = [finfo.file_structure(strncmp('ImageDataSeq', ...
  {finfo.file_structure(:).nameAttribute}, 12)).dataStartPos];

tic
for ind = 1:length(offsets)
fseek(fid, offsets(ind), 'bof');
% Image extracted from ND2 has image width defined by its first dimension.
if finfo.padding_style == 1
    for ii = 1: finfo.img_height
        temp = reshape(fread(fid, finfo.ch_count * finfo.img_width, '*uint16'),...
          [finfo.ch_count finfo.img_width]);
        im_ch1(:, ii, ind) = temp(1, :);
        im_ch2(:, ii, ind) = temp(2, :);
        fseek(fid, 2, 'cof');
    end
else
    for ii = 1: finfo.img_height
        temp = reshape(fread(fid, finfo.ch_count * finfo.img_width, '*uint16'),...
          [finfo.ch_count finfo.img_width]);
        im_ch1(:, ii, ind) = temp(1, :);
        im_ch2(:, ii, ind) = temp(2, :);
    end 
end
im_ch1(:,:,ind) = permute(im_ch1(:,:,ind), [2 1]);
im_ch2(:,:,ind) = permute(im_ch2(:,:,ind), [2 1]);
  
% im_ch1(:,:,ind) = im_ch1(:,:,ind)/max(max(im_ch1(:,:,ind)));
% im_ch2(:,:,ind) = im_ch2(:,:,ind)/max(max(im_ch2(:,:,ind)));

end
fclose(fid);
disp(['reading complete image data used ', sprintf('%0.2f', toc), ' seconds'])
end