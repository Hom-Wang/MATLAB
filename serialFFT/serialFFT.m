clear;

dataLens = 19;
dataType = 'single';

s = kSerial(256000, 'clear');
s.dataBuffer = zeros(dataLens, 1024 * 16);
s.open();

fig = figure(1);
f = struct;
f.fig = subplot(1, 1, 1);
f.length = 128;
f.window = [-10, 170, 0, 1.2];
f = plotFFT(f, 0, 0, 'init');

while ishandle(fig)
    [packetData, packetLens] = s.packetRecv(dataLens, dataType);
    if packetLens > 0
        s.dataBuffer = [s.dataBuffer(:, packetLens + 1 : end), packetData];     % record data
        gyr  = s.dataBuffer( 1 : 3, end);
        acc  = s.dataBuffer( 4 : 6, end);
        mag  = s.dataBuffer( 7 : 9, end);
        att  = s.dataBuffer(10 : 12, end);
        q    = s.dataBuffer(13 : 16, end);
        time = s.dataBuffer(17 : 19, end);
        time(3) = fix(time(3) * 100);

        lens = f.length;
        sec_s = s.dataBuffer(17, end - lens + 1) * 60 + s.dataBuffer(18, end - lens + 1) + s.dataBuffer(19, end - lens + 1);
        sec_e = s.dataBuffer(17, end) * 60            + s.dataBuffer(18, end)            + s.dataBuffer(19, end);
        freq = lens / (sec_e - sec_s);
        f = plotFFT(f, s.dataBuffer(3, end - lens + 1 : end), freq, 0);

        fprintf('[%05i][%02i][%02i:%02i:%02i][%6.2fHz]  Gyr[%8.3f, %8.3f, %8.3f]   Acc[%8.5f, %8.5f, %8.5f]   Mag[%8.3f, %8.3f, %8.3f]   Att[%8.4f, %8.4f, %8.4f]\n', s.packet.sequenceNum, packetLens, time, freq, gyr, acc, mag, att);
    end
end

s.close();
