clear;

s = creatSerial(115200, 'clear');
fopen(s);

packetSize  = 30;
dataBufSize = 1024;

% init packet parameter
packet = struct;
packet.recvBufMaxLens = s.InputBufferSize * 2;
packet.recvBufLens    = 0;
packet.recvBuffer     = zeros(packet.recvBufMaxLens, 1);
packet.packetSize     = packetSize;
packet.dataMaxLens    = (packet.packetSize - 6) / 4;    % float32 -> 4 bytes
packet.sequenceNum    = 0;
packet.packetCount    = 0;

packetDataBuf = zeros(packet.dataMaxLens, dataBufSize);

getFirstSequenceNum = true;
firstSequenceNum = 0;

tic
for i = 1 : 10000
%while true
    [packet, packetData, availablePacket] = serialPacketRecv(s, packet);
    if availablePacket
        packetLens = size(packetData, 2);
        packetDataBuf = [packetDataBuf(:, packetLens + 1 : end), packetData];
        fprintf('[%5i] [%2i] %6.3f, %6.3f, %6.3f, %6.3f\n', packet.sequenceNum, packetLens, packetDataBuf(1 : 4, end));

        if getFirstSequenceNum
            firstSequenceNum = packet.sequenceNum;
            getFirstSequenceNum = false;
        end
    end
end
time = toc;

lostPacket = (packet.sequenceNum - firstSequenceNum + 1) - packet.packetCount;
sampleRate = packet.packetCount / time;
fprintf('recv packet = %d, lost packet = %d, sample rate = %.3f Hz\n', packet.packetCount, lostPacket, sampleRate);

fclose(s);
delete(s);
