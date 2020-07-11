
function varargout = FibonacciLatticeDisk(num)

    p = FibonacciLattice(num);

    theta = 2 * pi * p(1, :);
    radius = sqrt(p(2, :));
    x = radius .* cos(theta);
    y = radius .* sin(theta);
    p = [x; y];

    varargout = {p, [radius; theta]};

end
