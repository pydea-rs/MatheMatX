% Read the image
image = imread('1.jpg'); % Replace with your image file path

% Convert the image to a grayscale matrix
imageMatrix = double(rgb2gray(image));
ranksToCheck = [5, 20, 50, 100, min(size(imageMatrix))];

% Display the original image
figure;
subplot(length(ranksToCheck) + 1, 1, 1);
imshow(uint8(imageMatrix));
title('Original Image');

% Check approximation with different ranks
for i = 1:length(ranksToCheck)
    rank = ranksToCheck(i);

    % Perform Singular Value Decomposition (SVD) with the current rank
    [U, S, V] = svd(imageMatrix);

    % Approximate the image with the current rank
    approxImageMatrix = U(:, 1:rank) * S(1:rank, 1:rank) * V(:, 1:rank)';

    % Display the approximated image
    subplot(length(ranksToCheck) + 1, 1, i + 1);
    imshow(uint8(approxImageMatrix));
    title(['Approximated Image (Rank ', num2str(rank), ')']);
end
