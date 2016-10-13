clear;

dataLens = 16;
dataType = 'single';

s = kSerial(256000, 'clear');
s.dataBuffer = zeros(dataLens, 1024 * 16);
s.open();

fig = subplot(1, 1, 1);
        
cube = kCube([0, 0, 0], [1.5, 1.5, 0.5]);   % origin, scale
cube.initCube(fig, [135, 30]);              % view

while ishandle(fig)
    [packetData, packetLens] = s.packetRecv(dataLens, dataType);
    if packetLens > 0
        s.dataBuffer = [s.dataBuffer(:, packetLens + 1 : end), packetData];     % record data
        cube.plotCube([0, 0, 0], s.dataBuffer(13 : 16, end));                   % origin, quaternion
        fprintf('[%5i][%2i]   Gyr[%8.3f, %8.3f, %8.3f]   Acc[%8.5f, %8.5f, %8.5f]   Mag[%8.3f, %8.3f, %8.3f]   Att[%8.4f, %8.4f, %8.4f]\n', s.packet.sequenceNum, packetLens, s.dataBuffer(1 : 12, end));
    end
end

s.close();
