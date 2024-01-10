clc;clear;
% Read the image
image = imread('1.jpg'); % Replace with your image file path

% Convert the image to the corresponding matrix
imageMatrix = double(rgb2gray(image));

% Perform Singular Value Decomposition (SVD)
[U, S, V] = svd(imageMatrix);

% Display the original image
figure;
subplot(1, 2, 1);
imshow(uint8(imageMatrix));
title('Original Image');

% Desired number of reduced ranks
reducedRank = 50; % You can change the number of ranks

% Approximate the image with the specified reduced ranks
approxImageMatrix = U(:, 1:reducedRank) * S(1:reducedRank, 1:reducedRank) * V(:, 1:reducedRank)';

% Display the approximated image
subplot(1, 2, 2);
imshow(uint8(approxImageMatrix));
title(['Approximated Image (Rank ', num2str(reducedRank), ')']);
