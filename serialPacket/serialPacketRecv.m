function [packet, packetData, availableData] = serialPacketRecv( s, packet, dataFormat )

% default output
packetData    = [];
availableData = false;

nBytes = get(s, 'BytesAvailable');
if nBytes > 0
    readData = fread(s, nBytes, 'uint8');
    packet.recvBuffer(packet.recvBufLens + 1 : packet.recvBufLens + nBytes) = readData;
    packet.recvBufLens = packet.recvBufLens + nBytes;

    if packet.recvBufLens >= packet.packetSize
        packetIndex = packet.recvBufLens - packet.packetSize + 1;
        index = zeros(1, fix(packet.recvBufMaxLens / packet.packetSize) + 1);

        % find available packet
        while packetIndex > 0
            if isequal(packet.recvBuffer(packetIndex : packetIndex + 1), uint8('KS')')  % KS
                if isequal(packet.recvBuffer(packetIndex + packet.packetSize - 2 : packetIndex + packet.packetSize - 1), [13; 10])   % \r\n
                    index = [packetIndex, index(1 : end - 1)];
                    packetIndex = packetIndex - packet.packetSize + 1;
                    packet.packetCount = packet.packetCount + 1;
                end
            end
            packetIndex = packetIndex - 1;
        end

        % check available packet index
        indexLens = size(find(index ~= 0), 2);
        if indexLens ~= 0

            % get data from buffer
            packetData = zeros(packet.dataMaxLens, indexLens);
            for k = 1 : indexLens
                packetData(:, k) = typecast(uint8(packet.recvBuffer(index(k) + 4 : index(k) + packet.packetSize - 3)), 'single');
            end
            packet.sequenceNum = typecast(uint8(packet.recvBuffer(index(indexLens) + 2 : index(indexLens) + 3)), 'uint16');

            % update recv buffer & lengths
            packet.recvBuffer = [packet.recvBuffer(index(indexLens) + packet.packetSize : end); zeros(index(indexLens) + packet.packetSize - 1, 1)];
            packet.recvBufLens = packet.recvBufLens - (index(indexLens) + packet.packetSize - 1);

            % set available
            availableData = true;
        end
    end
end

end
