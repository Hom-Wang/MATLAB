load('quadParam.mat');

position = [0; 0; 0];       % [x; y; z]
attitude = [-15; -15; 0];   % [pitch; roll; yew]
throttle = [0; 0; 0; 0];	% [M1; M2; M3; M4]

fig = figure(1);
set(fig, 'Position', [50, 50, 900, 750], 'color', 'w');

hold on;
grid on;
axis equal;

r = 1;
h = 0;

xlabel('x (m)');
ylabel('y (m)');
zlabel('z (m)');
view(45 * 7, 20);
axis([-1.2 * r, 1.2 * r, -1.2 * r, 1.2 * r, 0, 2]);

% {
%count = 0;
for t = linspace(0, 6 * pi, 100);
    h = h + 0.018;
    position = [r * cos(t); r * sin(t); h];
    attitude(3) = -t / pi * 180 - 90;
    throttle = [0; 0; 0; 0];
    plot3(position(1), position(2), position(3), '.r');
    quadPlot = plotQuadcopter(position, attitude, throttle);
    drawnow
%    count = count + 1;
%    frames(count) = getframe(1);
    delete(quadPlot.f);
end
quadPlot = plotQuadcopter(position, attitude, throttle);
%}
%{
quadPlot = plotQuadcopter([0; 0; 0], [0; 0; 0], [0.1; 0.1; 0.1; 0.1]);
%}

%dt = 0.01;
%filename = 'quadcopter_simu.gif';
%getGIF(filename, frames, 128, dt);
