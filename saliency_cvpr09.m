%---------------------------------------------------------
% Copyright (c) 2009 Radhakrishna Achanta [EPFL]
% Contact: firstname.lastname@epfl.ch
%---------------------------------------------------------
% Citation:
% @InProceedings{LCAV-CONF-2009-012,
%    author      = {Achanta, Radhakrishna and Hemami, Sheila and Estrada,
%                  Francisco and S�sstrunk, Sabine},
%    booktitle   = {{IEEE} {I}nternational {C}onference on {C}omputer
%                  {V}ision and {P}attern {R}ecognition},
%    year        = 2009
% }
%---------------------------------------------------------
% Please note that the saliency maps generated using this
% code may be slightly different from those of the paper.
% This seems to be because the RGB to Lab conversion is
% different from the one used for the results in the C++ code.
% The C++ code is available on the same page as this matlab
% code (http://ivrg.epfl.ch/supplementary_material/RK_CVPR09/index.html)
% One should preferably use the C++ as reference and use
% this matlab implementation mostly as proof of concept
% demo code.
%---------------------------------------------------------
%
%
%---------------------------------------------------------
% Read image and blur it with a 3x3 or 5x5 Gaussian filter
%---------------------------------------------------------
%�����ļ�����׺������ļ���?
function sm=saliency_cvpr09(img_color,imgname,ext,outputdir)
% img = imread(imgname);%Provide input image path
%gfrgb = imfilter(img_color, fspecial('gaussian', 3, 3), 'symmetric', 'conv');
%---------------------------------------------------------
% Perform sRGB to CIE Lab color space conversion (using D65)
%---------------------------------------------------------
cform = makecform('srgb2lab', 'adaptedwhitepoint', whitepoint('d65'));
lab = applycform(img_color,cform);
%---------------------------------------------------------
% Compute Lab average values (note that in the paper this
% average is found from the unblurred original image, but
% the results are quite similar)
%---------------------------------------------------------
l = double(lab(:,:,1)); lm = mean(mean(l));
a = double(lab(:,:,2)); am = mean(mean(a));
b = double(lab(:,:,3)); bm = mean(mean(b));
%---------------------------------------------------------
% Finally compute the saliency map and display it.
%---------------------------------------------------------
sm_distance = (l-lm).^2 + (a-am).^2 + (b-bm).^2;
sm=im2uint8(mat2gray(sm_distance));
% imshow(sm,[]);
%TIME%img_sm_name=strrep(imgname,ext,'-saliencymap-1-lab-IG.tif');
%TIME%imwrite(sm,strcat(outputdir,img_sm_name),'tif','Resolution',300);
%---------------------------------------------------------
