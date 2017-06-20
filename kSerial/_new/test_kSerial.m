clear;

s = kSerial(115200, 'clear');
s.setRecordBufferSize(1024 * 16);
s.setRecvThreshold(0);
s.open();

dd = 0.1;

% {
fprintf('[     %02i     ]\n', 1);
fprintf('[W] [K, S, %3i, %3i, %3i, %3i, 13, 10]\n', 8, 0, 0, 0)
s.packetSend();
s.delay(dd);
[packetData, packetInfo, packetLens] = s.packetRecv();
fprintf('[R] [K, S, %3i, %3i, %3i, %3i, 13, 10]\n', packetInfo(1), packetInfo(2), packetInfo(3), packetInfo(4))
fprintf('\n')
%}
% {
fprintf('[     %02i     ]\n', 2);
command = [128, 10];
fprintf('[W] [K, S, %3i, %3i, %3i, %3i, 13, 10]\n', 8, command(1), command(2), 0)
s.packetSend(command);
s.delay(dd);
[packetData, packetInfo, packetLens] = s.packetRecv();
fprintf('[R] [K, S, %3i, %3i, %3i, %3i, 13, 10]\n', packetInfo(1), packetInfo(2), packetInfo(3), packetInfo(4))
fprintf('\n')
%}
% {
fprintf('[     %02i     ]\n', 3);
command = [128, 10];
data = uint8(1:240);
fprintf('[W] [K, S, %3i, %3i, %3i, %3i', 8, command(1), command(2), 0)
for i = 1 : size(data, 2)
    fprintf(', %3i', data(i))
end
fprintf(', 13, 10]\n')
s.packetSend(command, data);
s.delay(dd);
[packetData, packetInfo, packetLens] = s.packetRecv();
fprintf('[R] [K, S, %3i, %3i, %3i, %3i', packetInfo(1), packetInfo(2), packetInfo(3), packetInfo(4))
for i = 1 : size(packetData, 1)
    fprintf(', %3i', packetData(i))
end
fprintf(', 13, 10]\n')
fprintf('\n')
%}

s.close();
