clear;

s = kSerial(256000, 'clear');
s.dataBuffer = zeros(12, 1024 * 8);
s.open();

osc = kSerial_Oscilloscope();
osc.setWindow(200, -200, 1000);

while ishandle(osc.fig)
    [packetData, packetLens] = s.packetRecv(12, 'single');
    if packetLens > 0
        s.dataBuffer = [s.dataBuffer(:, packetLens + 1 : end), packetData];       % record data
        osc.updateOscilloscope(s);
        fprintf('[%5i][%2i]   Gyr[%8.3f, %8.3f, %8.3f]   Acc[%8.5f, %8.5f, %8.5f]   Mag[%8.3f, %8.3f, %8.3f]   Att[%8.4f, %8.4f, %8.4f]\n', s.packet.sequenceNum, packetLens, s.dataBuffer(:, end));
    end
end

s.close();
