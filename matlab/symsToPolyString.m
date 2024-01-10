function polynomial_string = symsToPolyString(polynomial, symbol)
    % Matlab symbolic function, has fractional strange, coefficients
    % Here we extract the coefficients and create a standard polynomial    
    poly_coeffs = double(coeffs(polynomial));

    n = length(poly_coeffs);
    display(['n = ' num2str(n)]);
    polynomial_string = '';
    c = round(poly_coeffs(1), 4); % this is to make sure numbers are not strange
    % for example matlab considers some coeffs as 1e-32, and it doesnt
    % consider at zero!
    if c ~= 0
        polynomial_string = sprintf('%.4f%s^%d', c, symbol, n-1);
    end
    
    for i=2:n-1
        sign = '+';
        c = round(poly_coeffs(i), 4);
        if c < 0
           sign = '-';
           c = c * -1;
        end
        if c ~= 0
            polynomial_string = sprintf('%s %s %.4f%s^%d', polynomial_string, sign, c, symbol, n-i);
        end
    end
end

