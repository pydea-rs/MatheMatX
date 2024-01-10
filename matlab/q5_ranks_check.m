clc;clear;close all;
% Load an example image
image = imread('1.jpg'); % You can replace this with your image path

% Convert the image to a grayscale matrix
img_original_gray_mat = double(rgb2gray(image));

% Calculate and observe different ranks
ranks = [5, 20, 50, 100, 150]; % Example ranks to observe
count = length(ranks);
display('Plotting ... Please wait ...');
for i = 1:count
    rank = ranks(i);
    % Perform Singular Value Decomposition (SVD) with the current rank
    [U, S, V] = svd(img_original_gray_mat);

    % Decompose and Approximate the image with the specified rank
    approximatede_image_mat = U(:, 1:rank) * S(1:rank, 1:rank) * V(:, 1:rank)';
    figure,
    % Display the actual image 
    subplot(1, 2, 1);
    imshow(uint8(img_original_gray_mat));
    title('Original Image');
    % Display the approximated image for the current rank, to compare with
    % the actual image
    subplot(1, 2, 2);
    imshow(uint8(approximatede_image_mat));
    title(['Rank ', num2str(rank)]);
    
end
display('Plotting completed');
% Starting from rank=125, Calculate rank mse errors, to compare ranks
ranks = 125:250;
count = length(ranks);
mse_values = zeros(1, count);
psnr_values = zeros(1, count);
fprintf('Calculating errors from rank=125 to rank=250...\n\tPlease wait ...\n');
for i=1:count
    rank = ranks(i);
    % Perform Singular Value Decomposition (SVD) with the current rank
    [U, S, V] = svd(img_original_gray_mat);

    % Decompose and Approximate the image with the specified rank
    approximatede_image_mat = U(:, 1:rank) * S(1:rank, 1:rank) * V(:, 1:rank)';
    % Calculate Mean Squared Error (MSE)
    mse_values(i) = mean((img_original_gray_mat(:) - approximatede_image_mat(:)).^2);

    % Calculate Peak Signal-to-Noise Ratio (PSNR)
    max_pixel_value = max(img_original_gray_mat(:));
    psnr_values(i) = 10 * log10((max_pixel_value^2) / mse_values(i));
end

% Display MSE and PSNR values
fprintf('Rank\t\t|\tMSE\t\t|\t\tPSNR\n');
disp('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -');
for i = 1:count
    fprintf('  %d\t\t%5.3f\t\t%5.3f\n', ranks(i), mse_values(i), psnr_values(i));
end