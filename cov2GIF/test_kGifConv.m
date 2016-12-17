
load('data.mat');
dataLens = size(data, 2);
runtimes = [1 : dataLens];

y_axisMax =  3000;   % int8_t range
y_axisMin = -2000;   % int8_t range
window_width = 800;
window_w = window_width;
window = window_w * (-0.75);  % 3/4 window

fig1 = figure(1);
set(fig1, 'Position', [400, 100, 1200, 700], 'color', 'w');
xlabel('x(m)');
ylabel('y(m)');
hold on
grid on

kgif = kGifConv('serial data - acc.gif');
step = 100;
for i = 1 : step : dataLens
    plot(runtimes(1:i), data(1, 1:i), 'r');
    plot(runtimes(1:i), data(2, 1:i), 'g');
    plot(runtimes(1:i), data(3, 1:i), 'b');

    legend('acc.c', 'acc.y', 'acc.z');
    window = window + step;
    axis([window, window + window_w, y_axisMin, y_axisMax]);

    kgif.record(fig1);
end

kgif.conv();
