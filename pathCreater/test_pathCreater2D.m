
clear;
close all;

dt = 0.1;
vm = 0.5;
am = 0.5;
round = 1;
rpos  = [ 0,  3,  3,  0,  0;
          0,  0,  3,  3,  0 ];
% rpos = [ 0,  2,  4,  6,  6, 2, -4, -4, -2, 0;
%          0,  0, -2, -2,  2, 2,  2, -2, -2, 0 ];
n = size(rpos, 2) - 1;
for i = 1 : round - 1;
    rpos = [rpos, rpos(:, end-n+1:end)];
end

n = size(rpos, 2) - 1;
rvmax = zeros(2, n + 1);
rvmax(1, 2:end) = vm * ones(1, n);
rvmax(2, 2:end) = am * ones(1, n);

cpath = pathCreater2D(rpos, rvmax, dt);
pos  = cpath(1:2, :);
vel  = cpath(3:4, :);
acc  = cpath(5:6, :);
head = cpath(7, :);
time = cpath(8, :);

% {
fig1 = figure(1);
subplot(4, 1, 1);
hold on;  grid on;
plot(time, pos(1, :));
plot(time, pos(2, :));
legend('pos_x', 'pos_y');
xlabel('time (s)');
ylabel('position (m)');

subplot(4, 1, 2);
hold on;  grid on;
plot(time, vel(1, :));
plot(time, vel(2, :));
legend('vel_x', 'vel_y');
xlabel('time (s)');
ylabel('velocity (m/s)');

subplot(4, 1, 3);
hold on;  grid on;
plot(time, acc(1, :));
plot(time, acc(2, :));
legend('acc_x', 'acc_y');
xlabel('time (s)');
ylabel('acceleration (m/s^2)');

subplot(4, 1, 4);
hold on;  grid on;
plot(time, head);
legend('head');
xlabel('time (s)');
ylabel('theta (deg)');
%}

% {
fig2 = figure(2);
map = subplot(1, 1, 1);
hold on;  grid on;  axis equal;
axis(map, [min(pos(1, :)) - 0.5, max(pos(1, :)) + 0.5, min(pos(2, :)) - 0.5, max(pos(2, :)) + 0.5]);
plot(map, pos(1, :), pos(2, :), '--r');
plot(map, rpos(1, :), rpos(2, :), '.k', 'MarkerSize', 12);
%}

% {
kgif = kGifConv('pathCreater.gif');
kgif.dt = 0.01;
tx = text(map, min(pos(1, :)) - 0.4, min(pos(2, :)) - 0.25, 'time');
point = plot(map, pos(1, 1), pos(2, 1), 'bo', 'MarkerSize', 8, 'LineWidth', 2);
for i = 2 : size(pos, 2)
   point.XData = pos(1, i);
   point.YData = pos(2, i);
   tx.String = sprintf('%05.2f s', time(i));
%    drawnow;

   kgif.record(fig2);
end

kgif.conv();
%}

%{
print(fig1, 'pathCreater_data', '-dpng', '-r1200'); 
%}
