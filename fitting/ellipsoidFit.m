function a = ellipsoidFit( x, y, z )

	D1 = [x .^ 2, x .* y, y .^ 2,];
	D2 = [x .* z, y .* z, z .^ 2, x, y, z, ones(size(x))];

    S1 = D1' * D1;
    S2 = D1' * D2;
    S3 = D2' * D2;

    invC1 = inv([0,  0,  2; ...
                 0, -1,  0; ...
                 2,  0,  0]);

    M = invC1 * (S1 - S2 * inv(S3) * S2');
    [evec, eval] = eig(M);

    cond = 4 * evec(1, :) .* evec(3, :) - evec(2, :) .^ 2;
    a1 = evec(:, find(cond > 0));
    a2 = (-inv(S3) * S2') * a1;
    a = [a1; a2];

end
