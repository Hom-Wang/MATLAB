function dataInt = byte2int( data, type )

    lens = size(data, 1) / (type + 1);
    dataInt = zeros(lens, 1);

    switch type
%{
        case 0  % KS_INT8
            convData = data;
%}
        case 1  % KS_INT16
            for i = 0 : lens - 1
                dataInt(i + 1) = data(2 + i * 2) * 256 + data(1 + i * 2);
                if dataInt(i + 1) > 2^15 + 1
                    dataInt(i + 1) = int16(bitcmp(uint16(dataInt(i + 1))) + 1) * (-1);
                end
            end
%{
        case 2  % KS_INT32
            convData = byte2uint32(data);
        case 3  % KS_INT64
%           convData = byte2uint32(recvData);
        case 4
%           convData = byte2uint32(recvData);
        case 5
%           convData = byte2uint32(recvData);
%}
    end

    dataInt = double(dataInt);

end
