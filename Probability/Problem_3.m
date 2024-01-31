clc; clear; close all;
N = 1000;
for n=[2 6 15 20]
    % Exponential distribution param
    lambda = 1;
    X = zeros(n, N);
    for i=1:n
        X(i,:) = exprnd(lambda, 1, N);  % Generate Random Variable i Samples
    end

    % Plotting histogram of random variable X1
    figure, subplot(2, 1, 1);
    histogram(X(1,:), 100);
    title(['Histogram of X1 for n = ' num2str(n)]);
    xlabel('X1');
    ylabel('Frequency');

    % Sum of random variable Xi and storing in vector Y
    Y = zeros(1, N);
    for i=1:N
        Y(i) = sum(X(:, i));
    end
    % Plotting histogram of Y
    subplot(2, 1, 2);
    histogram(Y, 100);
    title(['Histogram of Y for n = ' num2str(n)]);
    xlabel('Y');
    ylabel('Frequency');

    % Computing mean and variance of X1 and Y
    meanX1 = mean(X(1, :));
    varX1 = var(X(1, :));
    meanY = mean(Y);
    varY = var(Y);
    display('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -');
    display(['n = ' num2str(n) ':']);
    fprintf('\t\tmean(X1) = %f\t\t\tmean(Y) = %f\n\n', meanX1, meanY);
    fprintf('\t\tvar(X1) = %f\t\t\tvar(Y) = %f\n\n', varX1, varY);
    fprintf('\tmean(Y) / mean(X1) = %f,\t\t\t', meanY / meanX1);
    fprintf('var(Y) / var(X1) = %f\n\n\n', varY / varX1);
    
end