clc;clear; % Clear everything
% Probability mass function
pmf = [1/8, 2/8, 4/8, 1/8];

N = 1000;

% Generating samples
samples = zeros(1, N);

for i = 1:N
    rand_num = rand;
    
    % Determining sample value based on the probability mass function
    if rand_num < pmf(1)
        samples(i) = 1;
    elseif rand_num < pmf(1) + pmf(2)
        samples(i) = 2;
    elseif rand_num < pmf(1) + pmf(2) + pmf(3)
        samples(i) = 3;
    else
        samples(i) = 4;
    end
end

% Mean:
mean_value = sum(samples) / N;

% Variance
variance_value = sum((samples - mean_value).^2) / N;

display(['Mean is ' num2str(mean_value)]);
display(['Variance is ' num2str(variance_value)]);
