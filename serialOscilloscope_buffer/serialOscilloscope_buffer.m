close all
clear all

% ***********************
% **** set parameters
%comPort     = 'COM5';
baudRate     = 256000;
y_axisMax    =  10000;
y_axisMin    = -10000;
window_width = 800;
% ***********************

recvBufSize = 65536;

lastIndex = 0;
lastPacketSize = 0;

packetNum        = 0;
packetCount      = 0;
packetTotalCount = 0;
availableData    = 0;
availablePacket  = 0;

recvBuf = zeros(recvBufSize, 1);

% Auto find available serial port
delete(instrfindall);
info  = instrhwinfo('serial');
comPort = info.AvailableSerialPorts

% Serial config
s = serial(comPort, 'BaudRate', baudRate, 'DataBits', 8, 'StopBits', 1, 'Parity', 'none', 'FlowControl', 'none');
s.ReadAsyncMode   = 'continuous';
s.InputBufferSize = 4096;
fclose(s);
fopen(s);

window_w = window_width;
window   = window_w * (-0.9);   % display window

fig1 = figure(1);
set(fig1, 'Position', [200, 100, 1200, 700], 'color', 'w');  % 1920*1080
axis([window, window + window_w, y_axisMin, y_axisMax]);
xlabel('runtimes');
ylabel('data');
grid on;
hold on;

%for i = 1 : 1000
while ishandle(fig1)

    nBytes = get(s, 'BytesAvailable');
    if nBytes > 0
        % read from serial
        recvData = fread(s, nBytes, 'uint8');
        bufLens = lastPacketSize + nBytes;
        recvBuf(lastPacketSize + 1 : bufLens) = recvData;   % add recv data to buffer

        % find index - 'S'
        index = find(recvBuf == 83);
        if ~isempty(index)
            % first check available packets
            packetNum = size(index, 1);
            packetType = fix(recvBuf(index + 1) / 32);      % get data type
            packetLens = rem(recvBuf(index + 1), 32) + 6;	% get data total lens (uint8_t)
                                                            % include header, lens, checksum, '\r', '\n'
            lastIndex  = index(end);                        % get last index
            lastPacketEND = lastIndex + packetLens(end) - 1;
            if (packetLens(end) <= 6) || (lastPacketEND > bufLens)
                packetNum = packetNum - 1;
            end
            availablePacket = 1;
        end
    end

    if availablePacket == 1
        availablePacket = 0;
        packetCount = 0;
        % second check available packets & get data
        for i = 1 : packetNum
            packet = recvBuf(index(i) : index(i) + packetLens(i) - 1);
            % check '\r', '\n'
            if (packet(packetLens(i) - 1) == 13) && (packet(packetLens(i)) == 10)
                data = packet(3 : end - 4);
                checksum = calChecksum(data);
                % check checksum
                if (rem(checksum, 256) == packet(end - 2)) && (fix(checksum / 256) == packet(end - 3))
                    availableData = 1;          % available data
                    packetCount = packetCount + 1;
                    save_data(:, packetTotalCount + packetCount) = byte2int(data, packetType(i));
                end
            end
        end
        packetTotalCount = packetTotalCount + packetCount;
    end

    if availableData == 1
        availableData = 0;
        lastPacketSize = bufLens - lastIndex;
        recvBuf = [recvBuf(lastIndex + 1 : bufLens); zeros(recvBufSize - lastPacketSize, 1)];

        runtimes = (packetTotalCount - packetCount + 1) : packetTotalCount;
        plot(runtimes, save_data(1, runtimes(1) : runtimes(end)), 'r');  % acc.x
        plot(runtimes, save_data(2, runtimes(1) : runtimes(end)), 'g');  % acc.y
        plot(runtimes, save_data(3, runtimes(1) : runtimes(end)), 'b');  % acc.z
        axis([window, window + window_w, y_axisMin, y_axisMax]);
        window = window + packetCount;
        drawnow

%        sprintf('A.X = %6i, A.Y = %6i, A.Z = %6i\n', save_data(1, end), save_data(2, end), save_data(3, end))
%        sprintf('A.X = %6i, A.Y = %6i, A.Z = %6i\nG.X = %6i, G.Y = %6i, G.Z = %6i\n', save_data(1, end), save_data(2, end), save_data(3, end), save_data(4, end), save_data(5, end), save_data(6, end))
    end

end

fclose(s);
delete(s);
delete(instrfindall);
