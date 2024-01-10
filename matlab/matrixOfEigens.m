% Function to generate a matrix with specified eigenvalues
function A = matrixOfEigens(eigenvalues)
    n = length(eigenvalues);
    
    % Create a random orthogonal matrix
    Q = orth(randn(n));
    
    % Diagonal matrix with specified eigenvalues
    D = diag(eigenvalues);
    
    % Generate the matrix A
    A = Q * D * Q';
end
