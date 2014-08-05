%---------------------------------------------------------
% Copyright (c) 2014 Haiyong Zheng [OUC]
% Contact: zhenghaiyong@gmail.com
%---------------------------------------------------------
clc;
clear all;
%% Settings
inputdir='./experiments/single/';
outputdir='./experiments/results/single/';
exts={'.tif','.bmp','.jpg','.png','.gif','.jpeg'};
%% END Settings
for i=1:length(exts)
    ext=exts{i};
    extwild=strcat('*',ext);
    inputdirformat=[inputdir extwild];
    files= dir(inputdirformat);
    for j=1:length(files)
        imgname=files(j).name; 
        f=imread(strcat(inputdir,imgname));
        [row,col,dim] = size(f);
        if dim==1
            continue
        else
        img_color=imresize(f,1);
        img_gray=rgb2gray(img_color);
       %% Salient Objects Detection
        gf_img_color = imfilter(img_color, fspecial('gaussian', 3, 3), 'symmetric', 'conv');%Gaussian low-pass filter   
        sm_IG=saliency_cvpr09(gf_img_color,imgname,ext,outputdir);%salient objects by IG method
        sm_S=saliency_cvpr09_S(gf_img_color,imgname,ext,outputdir);%salient objects by saturation
        saliencymap=(sm_IG+sm_S);%combined salient objects
        img_sm_name=strrep(imgname,ext,'-saliencymap-3.tif');
        imwrite(saliencymap,strcat(outputdir,img_sm_name),'tif','Resolution',300);
       %% END Salient Objects Detection
       %% Markers Selection
        % Binarization
        [u,sigma]=expectation_variance(saliencymap);
        u=u+10;
        binary_saliencymap=im2bw(saliencymap,u/255);
        img_binary_saliencymap_name=strrep(imgname,ext,'-saliencymap-4-binary.tif');
        imwrite(binary_saliencymap,strcat(outputdir,img_binary_saliencymap_name),'tif','Resolution',300);
        % Removing corner noise
        binary_image=remove_corner_noise(binary_saliencymap,imgname,ext,outputdir);
        % Removing small noise
        cell_region=extract_single_cell_region(binary_image);
       %% END Markers Selection
       %% Watershed from markers
        watershed_single(img_color,img_gray,cell_region,imgname,ext,row,col,outputdir); 
       %% END Watershed from markers
        end
    end
end