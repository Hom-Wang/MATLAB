close all
clear all

% ******************************
% **** set parameters
comPort = 'COM3';
y_axisMax =  2000;   % int8_t range
y_axisMin = -2000;   % int8_t range
window_width = 800;
% ******************************

% Serial config
s = serial(comPort, 'BaudRate', 115200, 'DataBits', 8, 'StopBits', 1, 'Parity', 'none', 'FlowControl', 'none');
s.ReadAsyncMode = 'continuous';
fopen(s);

fig = figure(1);

% Init data
window_w = window_width;
window = window_w * (-0.75);  % 3/4 window

runtimes = 0;
recvData = 0;
signal = plot(runtimes, recvData);
axis([window, window + window_w, y_axisMin, y_axisMax]);
xlabel('time');
ylabel('data');
grid on;
hold on;

state = 0;
%for i = 1 : 150
while ishandle(fig)
    n_bytes = get(s, 'BytesAvailable');
    if n_bytes == 0
        n_bytes = 20;
    end
    recvData = fread(s, n_bytes, 'uint8');
    data_s = find(recvData == 83);

    dataNum = size(data_s, 1);
    if dataNum >= 1
        i = 1;
        while (i) & (dataNum >= 1)
            if (n_bytes - data_s(dataNum)) < 10
                dataNum = dataNum - 1;
            else
                i = 0;
            end
        end
    end
    
    if dataNum >= 1
        count = 0;
        for i = 1 : dataNum
            if (recvData(data_s(i) + 8) == 13) & (recvData(data_s(i) + 9) == 10)
                check = sum(recvData(data_s(i) + 1 : data_s(i) + 6));
                if rem(check, 256) == recvData(data_s(i) + 7)
                    count = count + 1;
                    runtimes(runtimes(end) + 1) = runtimes(end) + 1;
                    Acc(:, runtimes(end)) = [ unsigned2signed(recvData(data_s(i) + 1) * 2^8 + recvData(data_s(i) + 2)); ...
                                              unsigned2signed(recvData(data_s(i) + 3) * 2^8 + recvData(data_s(i) + 4)); ...
                                              unsigned2signed(recvData(data_s(i) + 5) * 2^8 + recvData(data_s(i) + 6)); ];
                    state = 1;
                end
            end
        end

        if state == 1
%
%            set(signal, 'xdata', runtimes, 'ydata', Acc(1, :));
            plot(runtimes, Acc(1, :), 'r', runtimes, Acc(2, :), 'g', runtimes, Acc(3, :), 'b');
%            plot(runtimes(runtimes(end) - count + 1 : end), Acc(1, runtimes(end) - count + 1 : end), 'b');
            window = window + count;
            axis([window, window + window_w, y_axisMin, y_axisMax]);
            drawnow
            state = 0;
%
%            sprintf('Acc.X = %d mg, Acc.Y = %d mg, Acc.Z = %d mg, runtimes = %d', Acc(1, end), Acc(2, end), Acc(3, end), runtimes(end))
        end
    end
end

fclose(s);
delete(s);
