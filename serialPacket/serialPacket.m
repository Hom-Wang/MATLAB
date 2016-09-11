clear;

s = kSerial(115200, 'clear');
s.initPacket(6, 'single');    % float32 * 6
s.open();

dataBuffer = zeros(s.packet.dataLengths, 1024);

getFirstSequenceNum = true;
firstSequenceNum = 0;

tic
for i = 1 : 10000
%while true
    [packetData, packetLens] = s.packetRecv();
    if packetLens > 0
        dataBuffer = [dataBuffer(:, packetLens + 1 : end), packetData];       % record data
        fprintf('[%5i] [%2i] %6.3f, %6.3f, %6.3f, %6.3f m\n', s.packet.sequenceNum, packetLens, dataBuffer(1 : 4, end));
        if getFirstSequenceNum
            firstSequenceNum = s.packet.sequenceNum;
            getFirstSequenceNum = false;
        end
    end
end
time = toc;

lostPacket = (s.packet.sequenceNum - firstSequenceNum + 1) - s.packet.packetCount;
sampleRate = s.packet.packetCount / time;
fprintf('\nrecv packet = %d, lost packet = %d, sample rate = %.3f Hz\n', s.packet.packetCount, lostPacket, sampleRate);

s.close();
