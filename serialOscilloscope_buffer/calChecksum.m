function checkSum = calChecksum( data )

    lens = size(data, 1);

    checkSum = 0;
    for i = 1 : 2 : lens
        checkSum = checkSum + (data(i) * 256 + data(i + 1));
    end
    checkSum = rem(checkSum, 65536);

end
