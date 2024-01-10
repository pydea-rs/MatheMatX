clc;clear;close all;
% Define system parameters
M1 = 1; M2 = 1; k1 = 1; k2 = 6; D1 = 0.5; D2 = 0.1;

inM1 = input('[default = 1] M1 = ', 's');
if ~isempty(inM1)
   M1 = str2double(inM1);
end
inM2 = input('[default = 1] M2 = ', 's');
if ~isempty(inM2)
   M2 = str2double(inM2);
end
in_k1 = input('[default = 1] k1 = ', 's');
if ~isempty(in_k1)
   k1 = str2double(in_k1);
end
in_k2 = input('[default = 6] k2 = ', 's');
if ~isempty(in_k2)
   k2 = str2double(in_k2);
end
inD1 = input('[default = 0.5] D1 = ', 's');
if ~isempty(inD1)
   D1 = str2double(inD1);
end
inD2 = input('[default = 0.1] D2 = ', 's');
if ~isempty(inD2)
   D2 = str2double(inD2);
end

fprintf('Final system parameters are as followed:\n M1=%.2f, M2=%.2f, ', M1, M2);
fprintf('k1=%.3f, k2=%.3f, D1=%.3f, D2=%.3f :\n\n', k1, k2, D1, D2);

f = @(t) abs(sin(t));
inF = input('{ default: f(t) = |sin(t)| }  f(t) = ', 's');
if ~isempty(inF)
   f = str2func(['@(t)' inF]);
end
display(f);

A = [0, 1, 0, 0;
    -(k1+k2)/M2, -(D1+D2)/M2, k1/M2, D1/M2;
    0, 0, 0, 1;
    k1/M1, D1/M1, -k1/M1, -D1/M1
];
B = [0; 0; 0; -1/M1];
C = [1, 0, 0, 0];
D = 0;
% Display state space matrices
disp('State Space Matrices:');
display(A);
display(B);
display(C);
display(D);

disp('Approach 1. Use matlab ss2tf function: ');
disp('Approach 2. Transfer Matrix is ontained via: G(s) = C * (sI - A) \ B + D');
choice = input('Which approach do you want to use? (Enter 1 or 2) ');
while choice ~= 1 && choice ~= 2
    choice = input('Wrong choice; Please just Enter 1 or 2: ');
end

G_s = [];
if choice == 1
    [numerator, denominator] = ss2tf(A, B, C, D);
    display(numerator);
    display(denominator);
    G_s = tf(numerator, denominator);
    display(G_s);
elseif choice == 2
    [n, m] = size(A);  % for constructing I we need dimension of A
    s = tf('s');
    sI_A = s*eye(n) - A;
    display('sI - A = ');
    display(sI_A);
    disp('(sI - A) ^ -1 = ');
    display(inv(sI_A));
    % inv_sI_A_cross_B = inv(sI_A) * B;  % this line could be used, but
    % MatLab says too: This method is slower and less accurate than the
    % next line approach:
    inv_sI_A_cross_B = sI_A \ B;
    disp('C * [(sI - A)^-1] * B \ ');
    G_s0 = C * inv_sI_A_cross_B;
    display(G_s0);
    G_s = G_s0 + D;
    display(G_s);
end

% Define model functions (state-space equations)
ode = @(t, y) [
    y(2);
    (-(k1+k2)*y(1) - (D1+D2)*y(2) + k1*y(3) + D1*y(4))/M2;
    y(4);
    (k1*y(1) + D1*y(2) - k1*y(3) - D1*y(4) - f(t))/M1
];

% Initial conditions
initial_conditions = [0; 0; 0; 0];

% Simulation time span
t_i = input('Specify the start time of the simulation [usually its Zero]: ');
t_f = input('Specify the final time of the simulation: ');
while t_i < 0 || t_f < 0 || t_f <= t_i
    disp('Please provide valid time data; conditions: t_i >= 0, t_f >= 0, t_f > t_i');
    t_i = input('t_i = ');
    t_f = input('t_f = ');
end
t_span = [t_i t_f];

% Solve state-space equations
[t, Y] = ode45(ode, t_span, initial_conditions);

% Display results
figure;
x1 = Y(:, 1);
dx1 = Y(:, 2);
x2 = Y(:, 3);
dx2 = Y(:, 4);

plot(t, x1, 'r', t, dx1, 'b', t, x2, 'g', t, dx2, 'm');
legend('x1', 'dx1', 'x2', 'dx2');
xlabel('Time');
ylabel('State');
title('System Response to Step Input');

% Plot step, ramp and pulse responses:
%input for ramp plot

figure,
step(G_s),
hold on,
impulse(G_s),
legend('Step Response', 'Impulse Response'),
title('Step and Impulse responses');

t = t_i:.1:t_f;
u = sin(t);
figure,
lsim(G_s, u, t, initial_conditions), legend('Ramp'), title('Ramp Response');

% Compute the eigenvalues (roots) of the system
eigenvalues = eig(A);
disp('Here are the eigen values of A:');
display(eigenvalues);
% Plot the poles (roots) on the complex plane
figure;
rlocus(G_s);
title('Pole-Zero Map');
