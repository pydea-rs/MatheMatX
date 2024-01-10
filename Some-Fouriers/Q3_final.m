% Define a range for x 
x = linspace(-pi, pi, 1000);

% Define the function
f = @(x) cos(x) .* (0 <= x & x <= pi);

% Define a range for w
w = linspace(-25, 25, 1000);

% Compute the Fourier transform of the function
F = zeros(size(w));
for i = 1:length(w)
    F(i) = integral(@(x) f(x) .* exp(-1i * w(i) * x), -inf, inf);
end

% Plotting 
plot(w, real(F), 'b', 'DisplayName', 'Real part');
hold on;
plot(w, imag(F), 'r', 'DisplayName', 'Imaginary part');
hold off;
xlabel('w');
ylabel('F(w)');
title('Fourier transform of the given function');
legend;
grid on;
