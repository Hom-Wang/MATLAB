
n = 10; % n by n matrix
X = diag(rand(n, 1));
U = orth(rand(n, n));

% generate a positive definite matrix
pdMatrix = U' * X * U;

% MATLAB function
P_U = chol(pdMatrix, 'upper');
P_L = chol(pdMatrix, 'lower');

% my function
P   = cholesky(pdMatrix);

% check pdMatrix equals P * P' ?
check = roundn(pdMatrix, -10) == roundn(P * P', -10);
if sum(sum(check)) == n * n
    sprintf('Equal')
else
    sprintf('Not Equal')
end
