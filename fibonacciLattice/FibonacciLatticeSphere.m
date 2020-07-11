
function varargout = FibonacciLatticeSphere(varargin)

    num = varargin{1};

    if nargin > 1
        mode = varargin{2};
    else
        mode = 1;   % default mode
    end

    [p, i] = FibonacciLattice(num);

    theta = 2 * pi * p(1, :);
    switch mode
        case 0
            phi = acos(1 - 2 * p(2, :));
        case 1
            if num >= 600000
              epsilon = 214;
            elseif num >= 400000
              epsilon = 75;
            elseif num >= 11000
              epsilon = 27;
            elseif num >= 890
              epsilon = 10;
            elseif num >= 177
              epsilon = 3.33;
            elseif num >= 24
              epsilon = 1.33;
            else
              epsilon = 0.33;
            end
            phi = acos(1 - 2 * (i + epsilon) / (num - 1 + 2 * epsilon));
        otherwise
            error('mode error!!');
    end
    x = cos(theta) .* sin(phi);
    y = sin(theta) .* sin(phi);
    z = cos(phi);
    p = [x; y; z];

    varargout = {p, [theta; phi]};

end
