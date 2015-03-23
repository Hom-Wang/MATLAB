clear all

% ******************************
% set parameters
% 
dataType = 'int8';
y_axis_max =  128;  % int8_t range
y_axis_min = -127;  % int8_t range
window_width = 40;
xlabel_string = 'time';
ylabel_string = 'data';
% 
% ******************************

% Serial config
s = serial('COM4', 'BaudRate', 115200);
fopen(s);

fig = figure;

% init data
time = 0;
data = 0;
signal = plot(time, data);
window_w = window_width;
window = window_w * (-0.75);    % 3/4 window
axis([window, window + window_w, y_axis_min, y_axis_max]);
xlabel(xlabel_string);
ylabel(ylabel_string);
grid on;

while ishandle(fig)
    recvData = fread(s, 1, dataType);
    time = [time, time(end) + 1];
    data = [data, recvData];
    set(signal, 'xdata', time, 'ydata', data)
    drawnow
    window = window + 1;
    axis([window, window + window_w, y_axis_min, y_axis_max]);
    legend([num2str(data(end))]);   % print data
end

fclose(s);
delete(s);
