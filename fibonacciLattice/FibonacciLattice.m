
% reference
% http://extremelearning.com.au/how-to-evenly-distribute-points-on-a-sphere-more-effectively-than-the-canonical-fibonacci-lattice/

function varargout = FibonacciLattice(num)

    goldenRatio = (sqrt(5) + 1) / 2;

    i = 0 : (num - 1);
    s = i ./ goldenRatio;
    x = s - fix(s);
    y = i ./ num;
    p = [x; y];

    varargout = {p, i, goldenRatio};

end
