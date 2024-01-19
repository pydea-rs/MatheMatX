%% clear command windows
clc;clear;close all;
%% Read Image
%% Images that work fine with our program:
    % inputfile = '1/2020-10-24_20-42-39_153287833_0_I.jpg'
    % inputfile = '1/2020-10-29_12-14-04_892736166_0_B41.jpg';
    % inputfile = '1/2020-10-25_14-42-13_573114668_0_I.jpg';
    
    % inputfile = '2/2020-10-23_22-48-12_S2_I.jpg';
%% Start
inputfile = '1.jpg';
imRaw = imread(inputfile); % read image
figure(); imshow(imRaw);
imRaw = imresize(imRaw,[1200,1600]);
imMinimumTexts = imcrop(imRaw, [500 0 1200 1200]); % some images has parking numbers that interfere with algorythm. so the tries to remove the parking numbers

%% Image Enhancement & Finding Image edges
iYCbCr = rgb2ycbcr(imMinimumTexts); % change image color space to YCbCr
imGray = im2double(rgb2gray(iYCbCr)); % rgb to gray
imAdjusted = imadjust(imGray);
imMedianFiltered = medfilt2(imAdjusted, [10,10]);
imRemovedNoise = wiener2(imMedianFiltered, [10,10]);
% figure();imshow(imRemovedNoise);
sobelMaskManualMatrix = [-1 0 1;-2 0 2;-1 0 1]; % sobel mask matrix; found by trial and error; matlab built-in matrices didnt worked as expected
imageFilter = imfilter(imRemovedNoise,sobelMaskManualMatrix,'replicate'); % filter image using sobel mask
imEdges=edge(imageFilter,'roberts',0.18,'both'); % find image edges
imSmoothed=strel('rectangle',[25,25]); % smoothing image
imMorphologicallyClosed = imclose(imEdges, imSmoothed);
% figure(5),imshow(imMorphologicallyClosed);title('smothing image');
ImFinalEnhanced = im2double(imMorphologicallyClosed);
%figure(),    imshow(ImFinalEnhanced)
%% Normalization
ImFinalEnhanced = (ImFinalEnhanced-min(ImFinalEnhanced(:)))/(max(ImFinalEnhanced(:))-min(ImFinalEnhanced(:))); % normalization
% figure(), imshow(ImFinalEnhanced)
%% Threshold (Otsu)
threshholdLevel = graythresh(ImFinalEnhanced); % threshold based on otsu method
ImFinalEnhanced = imbinarize(ImFinalEnhanced,threshholdLevel); % not available in old
% matlab versions
ImFinalEnhanced = imquantize(ImFinalEnhanced,threshholdLevel);  % or use graythresh
%figure(), imshow(ImFinalEnhanced);
%% Histogram
histogram = sum(ImFinalEnhanced,2); % edge horizontal histogram
%figure();plot(1:size(histogram,1),histogram)
%view(90,90);
%% Plot
figure();
subplot(1,2,1);imshow(ImFinalEnhanced);
subplot(1,2,2);plot(1:size(histogram,1),histogram);
axis([1 size(ImFinalEnhanced,1) 0 max(histogram)]);view(90,90);
%% Plate Location
threshOnEdge = 0.35; % threshold on edge histogram
plateRows = find(histogram > (threshOnEdge*max(histogram))); % candidate plate rows
%% Masked Plate
plateMask = zeros(size(imGray));
plateMask(plateRows,:) = 1;
imMaskedPlate = plateMask .* ImFinalEnhanced; % candidate plate
% figure(), imshow(imMaskedPlate);
%% Dilation: Vertical
verticalExtension = strel('rectangle',[80,4]);
imMaskedByVerticalDilation = imdilate(imMaskedPlate,verticalExtension);
imMaskedByVerticalDilation = imfill(imMaskedByVerticalDilation,'holes'); % fill holes
% figure(), imshow(imMaskedByVerticalDilation)
%% Dilation: Horizontal
horizontalExtension    = strel('rectangle',[4,80]);
imMaskedByHorizontalDilation   = imdilate(imMaskedPlate,horizontalExtension);
imMaskedByHorizontalDilation   = imfill(imMaskedByHorizontalDilation,'holes'); % fill holes
% figure(), imshow(imMaskedByVerticalDilation);
%% Joint Places
imJointed   = imMaskedByHorizontalDilation .* imMaskedByVerticalDilation; % joint all fragmented places
% figure(), imshow(imJointed);
%% Dilation: Horizontal
newHorizontalExtension = strel('rectangle',[4,30]); % new horizontal extension
imMaskedByNewDilation = imdilate(imJointed, newHorizontalExtension);
imMaskedByNewDilation = imfill(imMaskedByNewDilation,'holes'); % fill holes
% figure(), imshow(imMaskedByNewDilation);
%% Erosion
erosion = strel('line',50,0);
imEroded = imerode(imMaskedByNewDilation,erosion);
figure(),
    imshow(imEroded);
%% Find Biggest Binary Region (As a Plate Place)
% note; from all plate candidates, the one with largest area is supposed
% the actual plate
[L,num] = bwlabel(imEroded); % label (binary regions)               
Areas = zeros(num,1);
for i = 1:num % compute area of every region
    [r,c,plateHistogram]  = find(L == i); % find each area indexes
    Areas(i) = sum(plateHistogram); % compute area    
end
[La,Lb] = find(Areas==max(Areas)); % biggest binary region index is supposed as actual plate
%% Post Processing

[a,b] = find(L==La); % find biggest binary region (plate)
[nRow, nColumn] = size(imGray);
scaler = zeros(nRow,nColumn); % smooth and enlarge plate
enlargingScale = 10; % extend plate region by t pixel
jointRow = (min(a)-enlargingScale :max(a)+enlargingScale);
jointColumn = (min(b)-enlargingScale :max(b)+enlargingScale);
jointRow = jointRow(jointRow >= 1 & jointRow <= nRow);
jointColumn = jointColumn(jointColumn >= 1 & jointColumn <= nColumn);
scaler(jointRow,jointColumn) = 1; 
scaledDetectedPlate = scaler .* imGray;                        % Detected Plate
figure(),
    imshow(scaledDetectedPlate);
%% Initial Extraction of The Plate
plate = imcrop(imMinimumTexts, [min(jointColumn),min(jointRow),max(jointColumn)-min(jointColumn),...
max(jointRow)-min(jointRow)]); % show scaled plate independently
figure();
subplot(3,1, 1);
imshow(plate);

%% Character Seperation
imLabled = bwlabel(imEroded);
% figure, imshow(imLabled);
allWhiteBoxes = regionprops(imLabled,'Area','Extent','BoundingBox','Image','Orientation','Centroid');
plateBoxIndex = (find([allWhiteBoxes.Area] == max([allWhiteBoxes.Area]))); % Finds the plate box; it is needed to calculate plates angle
plateWhiteBox = allWhiteBoxes(plateBoxIndex).Image;
% figure,imshow(plate);
%% Enhancing Plate Quality
plateGray = rgb2gray(plate);
plateGray = imadjust(plateGray, stretchlim(plateGray), [0 1]); %specify lower and upper limits that can be used for contrast stretching image(J = imadjust(I,[low_in; high_in],[low_out; high_out]))
plateGrayEnhanced = im2double(plateGray);
binaryPlateGray = imbinarize(plateGrayEnhanced); % not available in old
% matlab versions
% binaryPlateGray = graythresh(plateGrayEnhanced);
subplot(3,1, 2);
imshow(binaryPlateGray)
%% saf kardan zaviie aks pelak
if abs(allWhiteBoxes(plateBoxIndex).Orientation) >= 1 % The orientation is the angle between the horizontal line and the major axis of ellipse=angle
    plateAngle = allWhiteBoxes(plateBoxIndex).Orientation;
    plateRotated = imrotate(plateWhiteBox, -plateAngle); % B = imrotate(A,angle) rotates image A by angle degrees in a counterclockwise direction around its center point. To rotate the image clockwise, specify a negative value for angle.
    binaryPlateRotated = imrotate(binaryPlateGray, -plateAngle);
else  
    binaryPlateRotated = binaryPlateGray;
end

subplot(3,1, 3);
imshow(binaryPlateRotated), title('Plate With removed Angle') % removes the plate angle

plateStraightenedDilated = imdilate(binaryPlateRotated,strel('line',1,0));
plateStraightened = imfill(plateStraightenedDilated,'holes');
plateFinalSmall = xor(plateStraightened , plateStraightenedDilated);
plateFinal = imresize(plateFinalSmall, [44 250]); % 4*(57*11)=Resize the image to (iranian plate size * 4)

%% Remove unnecessary characters
stat = regionprops( bwlabel(plateFinal,4) ,'Area','Image');
index = (find([stat.Area] == max([stat.Area])));
maxArea =[stat(index).Area]; % removes IRAN word in the plate & removes some errors;
plateMain = bwareaopen(plateFinal,maxArea-30); % plate image with removed unnecessary words or characters
%% Plate Histogram
plateHistogram = sum(plateMain);
figure();
plot(plateHistogram); 
%% Extracting Characters
stat = regionprops(bwlabel(plateFinal, 4),'Area','Image');
index = (find([stat.Area] == max([stat.Area])));
maxArea =[stat(index).Area];
plateMain = bwareaopen(plateFinal,maxArea-200);
plateBox = regionprops(plateMain,'Area','BoundingBox','Image','Orientation','Centroid');
plateCharacters = cell(1,8);
figure();
for i=1:8
    character = plateBox(i).Image;
    characterResized = imresize(character, [60 30]);
    subplot(2,4,i);
    imshow(character);
    plateCharacters{1,i} = characterResized;
    fx = mat2gray(plateCharacters{1,1});
    imwrite(characterResized,[num2str(i) '.jpg']); % save each character in hard disk
end