clc;
clear all;
close all;

n = 8; % number of functions
rounds = 50; %number of images we want to return on each filter
%% The Machine - Factorial combo of all pairs of filters, no double filts
for b = 1:36
    filename = sprintf('/Volumes/STORE/data2/Train/3000001-%d.png',b);
    im = imread(filename);
    im = rgb2gray(im);
    im = imresize(im, [40, 20]);
    for r = 0:2:50
        for i = 2:8 
            for j = 1:i-1 %do the filters inside this loop
                I = im; %reset image to original
                count = [i j]; %use counter for filter first i then j
                disp(1000*r + 10*i +1*j + '-' + b); 
                for filt = 1:2 %filter counter
                    switch count(filt)
                        case 1 %crop image
                            [rows, cols] = size(I);
                            I=im2double(mat2gray(I));
                            J = im2double(zeros(rows, cols));
                            size(J);
                            y = uint16(rows*.0003*(r));
                            x = uint16(cols*.0003*(r));
                            h = rows - 2 * y;
                            w = cols - 2 * x;
                            C = imcrop(I, [x y w h]);
                            I = im2double(imresize(C, [rows,cols]));
                
                        case 2 %band-limited
                            I = imadjust(I, [0 1], [0.002*r 1-0.002*r]);
               
                        case 3 %gaussian noise
                            I = imnoise(I, 'gaussian', r*.000000001);
                
                        case 4 %shear left
                            [rows, cols] = size(I);
                            a=0.00025*r;
                            T = affine2d([1 0 0; a 1 0; 0 0 1]);
                            I = imwarp(I,T);
                            I = imcrop(I,[round(r/20) 0 20 40]);
                            I = imresize(I,[rows, cols]);
                
                        case 5 %shear clockwise
                            [rows, cols] = size(I);
                            a=0.0000025*r;
                            T = affine2d([1 a 0; 0 1 0; 0 0 1]);
                            I = imwarp(I,T);
                            I = imcrop(I,[0 round(r/20) 20 40]);
                            I = imresize(I,[rows, cols]);
                
                        case 6 %erode letter
                            p = randi(3);
                            q = randi(3);
                            se = strel('rectangle',[p q]);
                            I = imerode(I, se);
                
                        case 7 %dialate letter
                            m = randi(3);
                            n = randi(3);
                            se = strel('rectangle',[m n]);
                            I = imdilate(I, se);
                            
                        case 8 %Gaussian Blur
                            GB = 0.000325*[-1 -2 -1; 2 4 2; 1 2 1];
                            I = conv2(I, GB);
                    end
                end
                %after running two filters, print
                I = imresize(I,[40, 20]);
                if size(I,3)==3
                    I=rgb2gray(I);
                end
                I = imbinarize(I);
                filename = sprintf('/Users/donna/Desktop/Test/s%d-%d.png',100*r + 10*i +1*j , b) ;
                imwrite(I, filename, 'png') ;
            end
        end
    end
end
