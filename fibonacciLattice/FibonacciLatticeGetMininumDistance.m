
function varargout = FibonacciLatticeGetMininumDistance(p)

    num = size(p, 2);
    pd = zeros(1, num);
    for i = 1 : num
        v = p - p(:, i);
        v(:, i) = [];
        d = sqrt(sum(v.*v));
        pd(i) = min(d);
    end

    varargout = {[max(pd), min(pd), max(pd) - min(pd)], pd};

end
