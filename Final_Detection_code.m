%% Method - SPIEDigitalLibrary.org/conference-proceedings-of-spie
%  Precise horizontal location of licenseplate image
%% clear command windows
clc
clear all
close all
%% Read Image/ convert to gray
Im = imread('/Users/donna/Desktop/Jacob/2018/DSPFinalProject/003.jpg');
%figure();imshow(Im);
Im_gray = im2double(rgb2gray(Im));
Im_gray = imadjust(Im_gray, [0.05, 0.65], [0,1]);
%figure();imshow(Im_gray)

%% Sobel Masking 
SM    = [-1 0 1;-2 0 2;-1 0 1];         % Sobel Vertical Mask
IS    = imfilter(Im_gray,SM,'replicate');     % Filter Image Using Sobel Mask
IS    = IS.^2;                          % Consider Just Value of Edges & Fray Weak Edges
%figure();imshow(IS)

%% Normalization
IS    = (IS-min(IS(:)))/(max(IS(:))-min(IS(:))); % Normalization
figure();imshow(IS)

%% Threshold (Otsu)
level = graythresh(IS);                 % Threshold Based on Otsu Method
IS    = imbinarize(IS,level);
% figure();imshow(IS)
%% Histogram
S     = sum(IS,2);                      % Edge Horizontal Histogram
%figure();plot(1:size(S,1),S)
% view(90,90)
%% Plot
% figure()
% subplot(1,2,1);imshow(IS)
% subplot(1,2,2);plot(1:size(S,1),S)
% axis([1 size(IS,1) 0 max(S)]);view(90,90)
%% Plate Location
T1    = 0.35;                           % Threshold On Edge Histogram
PR    = find(S > (T1*max(S)));          % Candidate Plate Rows
%% Masked Plate
Msk   = zeros(size(Im_gray));
Msk(PR,:) = 1;                          % Mask
MB    = Msk.*IS;                        % Candidate Plate (Edge Image)
%figure();imshow(MB)
%% Morphology (Dilation - Vertical)
Dy    = strel('rectangle',[80,4]);      % Vertical Extension
MBy   = imdilate(MB,Dy);                % By Dilation
MBy   = imfill(MBy,'holes');            % Fill Holes
%figure();imshow(MBy)
%% Morphology (Dilation - Horizontal)
Dx    = strel('rectangle',[4,80]);      % Horizontal Extension
MBx   = imdilate(MB,Dx);                % By Dilation
MBx   = imfill(MBx,'holes');            % Fill Holes
%figure();imshow(MBx)
%% Joint Places
BIM   = MBx.*MBy;                       % Joint Places
%figure();imshow(BIM)


%% Morphology (Dilation - Horizontal)
Dy    = strel('rectangle',[4,30]);      % Horizontal Extension
MM    = imdilate(BIM,Dy);               % By Dilation
MM    = imfill(MM,'holes');             % Fill Holes
% figure();imshow(MM)
%% Erosion
Dr    = strel('line',50,0);             % Erosion
BL    = imerode(MM,Dr);
%figure();imshow(BL)
%% Find Biggest Binary Region (As a Plate Place)
[L,num] = bwlabel(BL);                  % Label (Binary Regions)               
Areas   = zeros(num,1);
for i = 1:num                           % Compute Area Of Every Region
[r,c,v]  = find(L == i);                % Find Indexes
Areas(i) = sum(v);                      % Compute Area    
end 
[La,Lb] = find(Areas==max(Areas));      % Biggest Binary Region Index
%% Post Processing
[a,b]   = find(L==La);                  % Find Biggest Binary Region (Plate)
[nRow,nCol] = size(Im_gray);
FM      = zeros(nRow,nCol);             % Smooth and Enlarge Plate Place
T       = 10;                           % Extend Plate Region By T Pixel
jr      = (min(a)-T :max(a)+T);
jc      = (min(b)-T :max(b)+T);
jr      = jr(jr >= 1 & jr <= nRow);
jc      = jc(jc >= 1 & jc <= nCol);
FM(jr,jc) = 1; 
PL      = FM.*Im_gray;                  % Detected Plate
%figure();imshow(FM)
%figure();imshow(PL)
%% Plot
%figure()
%imshow(Im); title('Detected Plate')
%hold on
rectangle('Position',[min(jc),min(jr),max(jc)-min(jc),...
max(jr)-min(jr)],'LineWidth',4,'EdgeColor','r')
%hold off


%%
%clc
%close all
%% Crop
croppedIm = imcrop(Im, [min(jc),min(jr),max(jc)-min(jc),max(jr)-min(jr)]);
%figure();imshow(croppedIm);

%crop/filter image
croppedIm = im2double(rgb2gray(croppedIm));
croppedIm = medfilt2(croppedIm,[4 4]);

m = mean(croppedIm(:));
meanIntensity = mean(croppedIm(:));
val = std2(croppedIm);
T = adaptthresh(croppedIm,meanIntensity,'ForegroundPolarity','dark');
BlacknWhite = imcomplement(imbinarize(croppedIm,T));
%figure();imshow(BlacknWhite);

%% erode
se = strel('line',5,5);
erodedBW = imerode(BlacknWhite,se);
%figure();imshow(erodedBW);

%% Create and get average character size for bounding boxes
boxes = regionprops(erodedBW,'Area', 'BoundingBox', 'Image');

boxesfields = fieldnames(boxes);
boxescell = struct2cell(boxes);
sz = size(boxescell);
boxescell = reshape(boxescell, sz(1), []);  
boxescell = boxescell';
boxescell = sortrows(boxescell, 1);
% Put back into original cell array format
boxescell = reshape(boxescell', sz);

% Convert to Struct
boxessorted = cell2struct(boxescell, boxesfields, 1);

%remove top 2 and bottom 2 area outliers
boxessorted(1) = [];

%% Remove boxes that don't fit parameters for a character
avg_hght = 0;
avg_wdth = 0;
avg_hw_ratio = 0;
areas = [];

%define characteristics
for id = 1:length(boxessorted)
    h = boxessorted(id).BoundingBox(4);
    w = boxessorted(id).BoundingBox(3);
    avg_hw_ratio = avg_hw_ratio + h/w;
    avg_hght = avg_hght+ h;
    avg_wdth = avg_wdth+ w;
    areas(id)= h*w;
end
avg_hght = avg_hght/length(boxessorted);
avg_wdth = avg_wdth/length(boxessorted);
avg_hw_ratio = avg_hw_ratio/length(boxessorted);
median_area = median(areas);
count = 1;
while (count <= length(boxessorted))
    h = boxessorted(count).BoundingBox(4);
    w = boxessorted(count).BoundingBox(3);
    if h<.7*avg_hght %remove box if heigh< 70% avg height
        boxessorted(count) = [];
        count = 0;
    elseif (h/w < avg_hw_ratio-1 ) %remove box if h:w is less than the average h:w ratio +1 to reduce strictness
        boxessorted(count) = [];
        count = 0;
    elseif h*2*w < median_area-1000 %remove box if the median area is more than 1000 pixels less than the median
        boxessorted(count) = [];
        count = 0;
    end
    count = count+1;
end
avg_top = 0;
for id = 1:length(boxessorted)
    avg_top = avg_top+ boxessorted(id).BoundingBox(2);
end
avg_top = avg_top/length(boxessorted);
count = 1;
while (count <= length(boxessorted)) %eliminate low-hanging boxes
    if boxessorted(count).BoundingBox(2)> avg_top + .25*avg_hght
        boxessorted(count) = [];
        count = 0;
    end
    count = count+1;
end


for i = 1 : length(boxessorted)
        CurrBB = boxessorted(i).BoundingBox;
        rectangle('Position', [CurrBB(1), CurrBB(2), CurrBB(3), CurrBB(4)], 'Edgecolor', 'r', 'LineWidth', 2);  
end


modelfile = '/Volumes/LPR_2018/LicensePlates/modelLPRMLP_final3.h5';
classnames = {'A','B','C','D','E','F','G','H','I',...
    'J','K','L','M','N','O','P','Q','R','S','T',...
    'U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9'};
net = importKerasNetwork(modelfile,'ClassNames',classnames);
text_str = cell(length(boxessorted),1);
position = ones(length(boxessorted),2);
%close all;

for idx = 1: length(boxessorted)
    CurrBB = boxessorted(idx).BoundingBox;
    letter = imcrop(erodedBW, [CurrBB(1), CurrBB(2), CurrBB(3), CurrBB(4)]);
    letter = imresize(letter, [40 20]);
    %figure();
    %imshow(letter);
    letter = letter(:);
    letter = transpose(double(letter(:))./255);
    label = classify(net,letter);
    text_str{idx} = char(label);
    position(idx,:) = [min(jc)+CurrBB(1), min(jr)+CurrBB(2)+CurrBB(4)];
end

disp(text_str);
RGB = insertText(Im,position,text_str,'FontSize',75);
figure();
imshow(RGB),title('Numeric values');

