clear;

s = kSerial(256000, 'clear');
s.dataBuffer = zeros(12, 1024 * 8);
s.open();

getFirstSequenceNum = true;
firstSequenceNum = 0;

tic
for i = 1 : 40000
%while true
    [packetData, packetLens] = s.packetRecv(12, 'single');
    if packetLens > 0
        s.dataBuffer = [s.dataBuffer(:, packetLens + 1 : end), packetData];       % record data
        fprintf('[%5i][%2i]   Gyr[%8.3f, %8.3f, %8.3f]   Acc[%8.5f, %8.5f, %8.5f]   Mag[%8.3f, %8.3f, %8.3f]   Att[%8.4f, %8.4f, %8.4f]\n', s.packet.sequenceNum, packetLens, s.dataBuffer(:, end));
        if getFirstSequenceNum
            firstSequenceNum    = s.packet.sequenceNum;
            getFirstSequenceNum = false;
        end
    end
end
time = toc;

lostPacket = (s.packet.sequenceNum - firstSequenceNum + 1) - s.packet.packetCount;
sampleRate = s.packet.packetCount / time;
fprintf('\nrecv packet = %d, lost packet = %d, sample rate = %.3f Hz\n', s.packet.packetCount, lostPacket, sampleRate);

s.close();
