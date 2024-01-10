clc;clear;
eigen_values = [1, 1, 0, 0, 0, -1, 2, 2];
A = matrixOfEigens(eigen_values);
B = matrixOfEigens(eigen_values);
format short;
syms L
AB = {A, B};
for i=1:length(AB)
    % Find the minimal polynomial
    X = AB{i};
    minimum_polynomial = minpoly(sym(X), L);

    % Find the characteristic polynomial
    characteristic_polynomial = charpoly(sym(X), L);

    % Display the results
    disp(['Matrix ' num2str(i) ':']);
    disp(X);

    
    minimum_polynomial_string = symsToPolyString(minimum_polynomial, 'L');
    characteristic_polynomial_string = symsToPolyString(characteristic_polynomial, 'L');
    disp('Minimal Polynomial:');
    disp(minimum_polynomial_string);

    disp('Characteristic Polynomial:');
    disp(characteristic_polynomial_string);

    disp('- - - - - - - - - - - - - - - - - - - - - - - - -');
end
