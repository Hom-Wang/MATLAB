function sqrt_matrix = cholesky( pdMatrix )

    [n, m] = size(pdMatrix);
	sqrt_matrix = zeros(n);
	for j = 1 : n
        for i = j : n
            if i == j
                tempSum = 0;
                for k = 1 : i - 1
                    tempSum = tempSum + sqrt_matrix(i, k)^2;
                end
                sqrt_matrix(i, j) = sqrt(pdMatrix(i, j) - tempSum);
            else
                tempSum = 0;
                for k = 1 : j - 1
                    tempSum = tempSum + sqrt_matrix(i, k) * sqrt_matrix(j, k);
                end
                sqrt_matrix(i, j) = (pdMatrix(i, j) - tempSum) / sqrt_matrix(j, j);
            end
        end
    end

end
