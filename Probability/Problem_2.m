clc;clear; % Clear everything
% PMF
joint_pmf = [1/8, 1/8, 1/4, 1/2];

N = 10000;

% Generating samples
X = zeros(1, N);
Y = zeros(1, N);

for i = 1:N
    % X
    rand_num = rand;
    if rand_num < joint_pmf(1)
        X(i) = 0;
    elseif rand_num < joint_pmf(1) + joint_pmf(2)
        X(i) = 0;
    elseif rand_num < joint_pmf(1) + joint_pmf(2) + joint_pmf(3)
        X(i) = 1;
    else
        X(i) = 1;
    end
    % Y
    rand_num = rand;
    
    % Determining sample value for Y based on the joint probability mass function
    if rand_num < joint_pmf(1) + joint_pmf(2)
        Y(i) = 0;
    elseif rand_num < joint_pmf(1) + joint_pmf(2) + joint_pmf(3)
        Y(i) = 1;
    else
        Y(i) = 1;
    end
end

% Calculate Probabilities
P = zeros(2);  
% P = 
% [ (X=0, Y=0), (X=0, Y=1) ;
% (X=1, Y=0), (X=1, Y=1) ;]
fprintf('Index\t\tX\t\tY\n');
for i=1:N
    fprintf('%4d\t\t%d\t\t%d\n', i, X(i), Y(i));
    
    P(X(i) + 1, Y(i) + 1) = P(X(i) + 1, Y(i) + 1) + 1;
end

% Display probabilities
display('Calculating Probabilities...');
fprintf('\n\nP(X=i, Y=j); i,j=0.1   =\n\n');
for i=1:2
    for j=1:2
        P(i, j) = P(i, j) / N;
        fprintf('\t\tP(X=%d, Y=%d) = %f\t\t\t', i - 1, j - 1, P(i, j));
    end
    fprintf('\n');
end