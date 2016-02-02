function D_e = eq_e( X, A, refA )

    A(1) = A(1) - X(7);
    A(2) = A(2) - X(8);
    A(3) = A(3) - X(9);

    Arx = X(1) * A(1) + X(2) * A(2) + X(3) * A(3);
    Ary = X(2) * A(1) + X(4) * A(2) + X(5) * A(3);
    Arz = X(3) * A(1) + X(5) * A(2) + X(6) * A(3);

    D_e = Arx^2 + Ary^2 + Arz^2 - refA^2;

end
