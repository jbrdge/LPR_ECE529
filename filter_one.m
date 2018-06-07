clc;
clear all;
close all;


kl=300000;
for b0 = 30:36
filename = sprintf('30003000-%d.png',b0);
im = imread(filename);
current_count=10001000;
im = rgb2gray(im);
[rows, cols] = size(im);
rounds = 100; %number of matricies we want to return on each filter 
n = 6; % number of functions

%% Filter Machine
for r = 1:rounds
    r2 = randi(n,2,1);
    I = im;
    for count = 1:2
        switch r2(count)
            case 1 %crop image, try to keep between 1 and ~15%-20% max!!
                I = im2double(crop(I, r/50));
                I = im2double(imresize(I, [40, 20]));
                
            case 2 %Filter 1 - uses convolution filter rough bevel
                I = im2double(filter_one(I, r/5));
                
            case 3 %Filter 2 - uses convolution filter rough bevel
                   %variation of the above function
                I = im2double(filter_two(I, r/20));
                
            case 4
                I = im2double(filter_three(I, r/10)); 
            case 5
                I = im2double(sin_noise(I, r/10));
            case 6
                I = im2double(cotangent_noise(I, r));
            case 7
                I = im2double(shear(I, r/10));
            case 8
                h = fspecial('motion',10,2*r);
                I = imfilter(I,h, 'conv');
        end
    end
%size(imresize(I, [20, 40]));   
%IMAGES(r) = imresize(C.*F1, [20, 40]);
if I == zeros(size(I))
    I = im2double(filter_three(im, 2));
end
if I == ones(size(I))
    I = im2double(sin_noise(im, 2));
end
I = imresize(I,[40, 20]);%figure;imshow(I);
if size(I,3)==3
    I=rgb2gray(I);
end
filename = sprintf('%d-%d.png',current_count+kl+r, b0) ;
imwrite(I, filename, 'png') ;
I1 = imbinarize(I,0.5);    %figure;imshow(I1);
I1 = imresize(I,[40, 20]);%figure;imshow(I);
if size(I,3)==3
    I1=rgb2gray(I1);
end
filename = sprintf('%d-%d.png',current_count+kl+100+r, b0) ;
imwrite(I1, filename, 'png') ;
I2 = imcomplement(I); %figure;imshow(I2);
I2 = imresize(I2,[40, 20]);%figure;imshow(I);
if size(I2,3)==3
    I2=rgb2gray(I2);
end
filename = sprintf('%d-%d.png',current_count+kl+200+r, b0) ;
imwrite(I2, filename, 'png') ;
I3 = imbinarize(I2,0.5);   %figure;imshow(I3);
I3 = imresize(I3,[40, 20]);%figure;imshow(I);
if size(I3,3)==3
    I3=rgb2gray(I3);
end
filename = sprintf('%d-%d.png',current_count+kl+300+r, b0) ;
imwrite(I3, filename, 'png') ;
Q = wiener2(I,[3 3]); %figure;imshow(Q);
filename = sprintf('%d-%d.png',current_count+kl+400+r, b0) ;
Q = imresize(Q,[40, 20]);%figure;imshow(I);
if size(Q,3)==3
    Q=rgb2gray(Q);
end
imwrite(Q, filename, 'png') ;
Q1 = imbinarize(Q);        %figure;imshow(Q1);
filename = sprintf('%d-%d.png',current_count+kl+500+r, b0) ;
Q1 = imresize(Q1,[40, 20]);%figure;imshow(I);
if size(Q1,3)==3
    Q1=rgb2gray(Q1);
end
imwrite(Q1, filename, 'png') ;
Q2 = imcomplement(Q); %figure;imshow(Q2);
filename = sprintf('%d-%d.png',current_count+kl+600+r, b0) ;
Q2 = imresize(Q2,[40, 20]);%figure;imshow(I);
if size(Q2,3)==3
    Q2=rgb2gray(Q2);
end
imwrite(Q2, filename, 'png') ;
Q3 = imbinarize(Q2);       %figure;imshow(Q3);
filename = sprintf('%d-%d.png',current_count+kl+700+r, b0) ;
Q3 = imresize(Q3,[40, 20]);%figure;imshow(I);
if size(Q3,3)==3
    Q3=rgb2gray(Q3);
end
imwrite(Q3, filename, 'png') ;
J = imnoise(I,'gaussian', 0.06);%figure;imshow(J);
filename = sprintf('%d-%d.png',current_count+kl+800+rounds, b0) ;
J = imresize(J,[40, 20]);%figure;imshow(I);
if size(J,3)==3
    J=rgb2gray(J);
end
imwrite(J, filename, 'png') ;
J1 = imbinarize(J,0.5);    %figure;imshow(J1);

filename = sprintf('%d-%d.png',current_count+kl+900+rounds, b0) ;
J1 = imresize(J1,[40, 20]);%figure;imshow(I);
if size(J1,3)==3
    J1=rgb2gray(J1);
end
imwrite(J1, filename, 'png') ;
J2 = imcomplement(J); %figure;imshow(J2);
filename = sprintf('%d-%d.png',current_count+kl+1000+rounds, b0) ;
J2 = imresize(J2,[40, 20]);%figure;imshow(I);
if size(J2,3)==3
    J2=rgb2gray(J2);
end
imwrite(J2, filename, 'png') ;
J3 = imbinarize(J2,0.5);   %figure;imshow(J3);
filename = sprintf('%d-%d.png',current_count+1100+rounds, b0) ;
J3 = imresize(J3,[40, 20]);%figure;imshow(I);
if size(J3,3)==3
    J3=rgb2gray(J3);
end
imwrite(J3, filename, 'png') ;
K = wiener2(I,[5 5]); %figure;imshow(K);
filename = sprintf('%d-%d.png',current_count+1200+rounds, b0) ;
K = imresize(K,[40, 20]);%figure;imshow(I);
if size(K,3)==3
    K=rgb2gray(K);
end
imwrite(K, filename, 'png') ;
K1 = imbinarize(K,0.5);    %figure;imshow(K1);
filename = sprintf('%d-%d.png',current_count+1300+rounds, b0) ;
K1 = imresize(K1,[40, 20]);%figure;imshow(I);
if size(K1,3)==3
    K1=rgb2gray(K1);
end
imwrite(K1, filename, 'png') ;
K2 = imcomplement(K); %figure;imshow(K1);
filename = sprintf('%d-%d.png',current_count+1400+rounds, b0) ;
K2 = imresize(K2,[40, 20]);%figure;imshow(I);
if size(K2,3)==3
    K2=rgb2gray(K2);
end
imwrite(K2, filename, 'png') ;
K3 = imbinarize(K2,0.5);   %figure;imshow(K3);
filename = sprintf('%d-%d.png',current_count+1500+rounds, b0) ;
K3 = imresize(K3,[40, 20]);%figure;imshow(I);
if size(K3,3)==3
    K3=rgb2gray(K3);
end
imwrite(K3, filename, 'png') ;
end

end


%% Function One-------CROP-------------------------------------------------
%crops an image I with iterative changes n
function C = crop(I, n)
    [rows, cols] = size(I);
    I=im2double(mat2gray(I));
    J = im2double(zeros(rows, cols));
    size(J);
    percent = 100-n;
    y = uint16(rows*.01*(100-percent));
    x = uint16(cols*.01*(100-percent));
    h = rows - 2 * y;
    w = cols - 2 * x;
    C = imcrop(I, [x y w h]);
    C = im2double(imresize(C, [rows,cols]));
end

%% Function Two ----------Filter 1-----------------------------------------
%Violent Bevel
function F1 = filter_one(I,i)
    F1 = im2double(ones(size(I)));
    h = [1/64 100-i 1/64 ; 100-i 1/16 -1*(100-i); 1/16 -(100-i) 1/16 ];
    F1 = im2double(imfilter(I,h, 'conv'));
end
%% Function Three ---------Filter 2----------------------------------------
%Variation on the Violent Bevel
function F2 = filter_two(I,i)
    F2 = im2double(ones(size(I)));
    h = [1/32 (100-i)/128 -1/128 ; (100-i)/128 -1/128 (100-i)/128; -1/128 (100-i)/128 1/32 ];
    F2 = im2double(imfilter(I,h, 'conv'));
end

%% Function Four
function F3 = filter_three(I,i)
    blur = (1/16)*[1 2 1; 2 4 2; 1 2 1];
    F3 = im2double(imfilter(I,blur, 'conv'));
end
%% Function Five 

function SN1 = sin_noise(I, i)
    [rows, cols] = size(I);
    x = 1:4*i;
    y = 10:8*i;
    x = linspace(-pi, pi, 201);
    [xx,yy] = meshgrid(x);
    S = i*sin((yy+i)*(i*xx-i));
    S = imresize(S, [rows cols]);
    S= im2double(mat2gray(S));
    J = im2double(zeros(rows, cols));
    size(J);
    for i = 1:rows*cols
      J(i) = 2*S(i)*I(i);
    end
    SN1 = mat2gray(J);
end


%% Funciton Six
function COTN = cotangent_noise(I, i)
    [rows, cols] = size(I);
    x = 1:4;
    y = 10:14;
    x = linspace(-pi, pi, 201);
    % If you pass meshgrid only one vector, it uses that vector for both the x
    % and the y coordinates.
    [xx,yy] = meshgrid(x);
    P = 23*cot((yy+1)*(i*xx-1));
    P = imresize(P, [rows cols]);
    P = im2double(mat2gray(P));
    Q = im2double(zeros(rows, cols));
    size(Q);
    for i = 1:rows*cols
        Q(i) = P(i)*I(i);
    end
	COTN =mat2gray(Q);
end

%% Function Seven
function SHR = shear(I,i)
    [rows, cols] = size(I);
    a=0.01*i;
    T = affine2d([1 0 0; -a 1 0; 0 0 1]);
    I = imwarp(I,T);
    SHR = imresize(I,[rows, cols]);
end

    
    

