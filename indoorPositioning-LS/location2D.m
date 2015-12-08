clear all

% Beacon
%{ 
P1 = [ 0,  0,  8];
P2 = [14,  0,  8];
P3 = [ 5, 10,  8];
%}
deltaX = 17.35 / 100;
deltaY = 19.486 / 100;
P1 = [0.5*deltaX,  33*deltaY,  getDistance([0.5*deltaX,  33*deltaY], [20*deltaX, 20*deltaY])];
P2 = [ 36*deltaX,  33*deltaY,  getDistance([ 36*deltaX,  33*deltaY], [20*deltaX, 20*deltaY])];
P3 = [ 15*deltaX, 2.5*deltaY,  getDistance([ 15*deltaX, 2.5*deltaY], [20*deltaX, 20*deltaY])];
pos = [P1; P2; P3];
posNum = size(pos, 1);

% Line Simulation
slope_m = 0.1;
LineBoundary = [-10, 1, 15]; % X_L, STEP, X_R

% rssi & n
p_tx = -51.350450;  % exp result
param_n = 2.301151; % exp result

figure(1);
axis image;
axis([-7, 13, -5, 12]);
xlabel('x(m)');
ylabel('y(m)');
grid on;
hold on

% location real result
t = linspace(0, 2*pi, 360);
STRING_SHIFT = 0.5;
for i = 1 : posNum
    x = pos(i,1) + pos(i,3) * cos(t);
    y = pos(i,2) + pos(i,3) * sin(t);
    plot(x, y, 'b');
    plot(pos(i,1), pos(i,2), 'xr');
    plot(pos(i,1), pos(i,2), 'ob');
    text(pos(i,1) + STRING_SHIFT, pos(i,2) + STRING_SHIFT, ['P', num2str(i), ' (', num2str(pos(i,1)), ', ', num2str(pos(i,2)), ')']);
end
realPos = positioning(pos(:,1:2), pos(:,3), posNum);
if length(realPos) == 2
    plot(realPos(1), realPos(2), 'o');
    text(realPos(1) + STRING_SHIFT, realPos(2) + STRING_SHIFT, ['T (', num2str(realPos(1)), ', ', num2str(realPos(2)), ')']);
else	% singular matrix
    sprintf('ERROR : Matrix is singular !!')
end

% draw line
b = realPos(2) - slope_m * realPos(1);
realPos_X = [LineBoundary(1) : LineBoundary(2) : LineBoundary(3)];
realPos_Y = getLinePoint(realPos_X, slope_m, b);
plot(realPos_X, realPos_Y, 'g')

expPoints = size(realPos_X, 2);
% get noise rssi
for i = 1 : expPoints
    realDistance(1, i) = getDistance([realPos_X(i), realPos_Y(i)], P1(1:2));
    realDistance(2, i) = getDistance([realPos_X(i), realPos_Y(i)], P2(1:2));
    realDistance(3, i) = getDistance([realPos_X(i), realPos_Y(i)], P3(1:2));
    realRssi(1, i) = distance_to_rssi(realDistance(1, i), p_tx, param_n);
    realRssi(2, i) = distance_to_rssi(realDistance(2, i), p_tx, param_n);
    realRssi(3, i) = distance_to_rssi(realDistance(3, i), p_tx, param_n);
    noiseRssi(1, i) = realRssi(1, i) + (3 * (rand - 0.5));
    noiseRssi(2, i) = realRssi(2, i) + (3 * (rand - 0.5));
    noiseRssi(3, i) = realRssi(3, i) + (3 * (rand - 0.5));
end

% location simulation result
for i = 1 : expPoints
    P1 = [0.5*deltaX,  33*deltaY, rssi_to_distance(noiseRssi(1, i), p_tx, param_n)];
    P2 = [ 36*deltaX,  33*deltaY, rssi_to_distance(noiseRssi(2, i), p_tx, param_n)];
    P3 = [ 15*deltaX, 2.5*deltaY, rssi_to_distance(noiseRssi(3, i), p_tx, param_n)];
    pos = [P1; P2; P3];
    tmpPos = positioning(pos(:,1:2), pos(:,3), posNum);
    simuPos_X(i) = tmpPos(1);
    simuPos_Y(i) = tmpPos(2);
end

for i = 1 :expPoints
    plot([simuPos_X(i), realPos_X(i)], [simuPos_Y(i), realPos_Y(i)], '-r');
    plot(realPos_X(i), realPos_Y(i), '.r');
    plot(simuPos_X(i), simuPos_Y(i), 'xk');
end
% figure(2) ===============================================================================
figure(2);
axis([LineBoundary(1)-5, LineBoundary(3)+5, 0, 12]);
xlabel('x(m)');
ylabel('err(m)');
grid on;
hold on
for i = 1 : expPoints
    positionErr(i) = getDistance([simuPos_X(i), simuPos_Y(i)], [realPos_X(i), realPos_Y(i)]);
end
plot(realPos_X, positionErr)

dataRange = [(0 - LineBoundary(1)) / LineBoundary(2), (6 - LineBoundary(1)) / LineBoundary(2)]; % 0 - 6 m
avePositionError = mean(positionErr(dataRange(1) : dataRange(2)))
legend(strcat('aveErr = ', num2str(avePositionError), ' m, range = 0 ~ 6 m'));
