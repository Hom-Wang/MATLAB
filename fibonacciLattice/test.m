
clc, clear, close all;

N = 280;

%% square

p = FibonacciLattice(N);
[~, pd] = FibonacciLatticeGetMininumDistance(p);

figure(1);
hold on; grid on; axis equal;
plot(p(1, :), p(2, :), '.r', 'MarkerSize', 16);
xlim([-0.2, 1.2]);
ylim([-0.2, 1.2]);
xlabel('x-axis');
ylabel('y-axis');

p1 = p;
pd1 = pd;

%% disk

p = FibonacciLatticeDisk(N);
[~, pd] = FibonacciLatticeGetMininumDistance(p);

figure(2);
hold on; grid on; axis equal;
plot(p(1, :), p(2, :), '.g', 'MarkerSize', 16);
xlim(1.2*[-1, 1]);
ylim(1.2*[-1, 1]);
xlabel('x-axis');
ylabel('y-axis');

p2 = p;
pd2 = pd;

%% cylindrical A

phi = (sqrt(5) + 1) / 2;
i = -(N - 1) : 2 : (N - 1);
theta = 2 * pi * i / phi;
sphi = i / N;
cphi = sqrt((N + i) .* (N - i)) / N;
xp = cphi .* sin(theta);
yp = cphi .* cos(theta);
zp = sphi;
p = [xp; yp; zp];

[~, pd] = FibonacciLatticeGetMininumDistance(p);

figure(3);
hold on; grid on; axis equal;
plot3(p(1, :), p(2, :), p(3, :), '.b', 'MarkerSize', 16);
xlim(1.2*[-1, 1]);
ylim(1.2*[-1, 1]);
zlim(1.2*[-1, 1]);
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');

% figure(6);
% hold on; grid on;
% plot(1:size(xp, 2), xp, 'r');
% plot(1:size(yp, 2), yp, 'g');
% plot(1:size(zp, 2), zp, 'b');

p3 = p;
pd3 = pd;


%% cylindrical B

p = FibonacciLatticeSphere(N, 0);
[~, pd] = FibonacciLatticeGetMininumDistance(p);

figure(4);
hold on; grid on; axis equal;
plot3(p(1, :), p(2, :), p(3, :), '.m', 'MarkerSize', 16);
xlim(1.2*[-1, 1]);
ylim(1.2*[-1, 1]);
zlim(1.2*[-1, 1]);
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');

% figure(5);
% hold on; grid on;
% plot(1:size(xp, 2), xp, 'r');
% plot(1:size(yp, 2), yp, 'g');
% plot(1:size(zp, 2), zp, 'b');

p4 = p;
pd4 = pd;


%% cylindrical C

p = FibonacciLatticeSphere(N);
[~, pd] = FibonacciLatticeGetMininumDistance(p);

figure(5);
hold on; grid on; axis equal;
plot3(p(1, :), p(2, :), p(3, :), '.c', 'MarkerSize', 16);
xlim(1.2*[-1, 1]);
ylim(1.2*[-1, 1]);
zlim(1.2*[-1, 1]);
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');

% figure(7);
% hold on; grid on;
% plot(1:size(xp, 2), xp, 'r');
% plot(1:size(yp, 2), yp, 'g');
% plot(1:size(zp, 2), zp, 'b');

p5 = p;
pd5 = pd;

%%
figure(6); hold on; grid on;
plot(1:size(pd1, 2), pd1, 'r.-');
plot(1:size(pd2, 2), pd2, 'g.-');
plot(1:size(pd3, 2), pd3, 'b.-');
plot(1:size(pd4, 2), pd4, 'm.-');
plot(1:size(pd5, 2), pd5, 'c.-');


sphere_radius = 1;
circle_radius = 2 * sphere_radius / sqrt(N);

[max(pd1), min(pd1), max(pd1) - min(pd1);
max(pd2), min(pd2), max(pd2) - min(pd2);
max(pd3), min(pd3), max(pd3) - min(pd3);
max(pd4), min(pd4), max(pd4) - min(pd4);
max(pd5), min(pd5), max(pd5) - min(pd5)]
% 
% fprintf('N = %d, total = %.2f min\n', N, N*2/60);
[norm(sum(p3, 2)), norm(sum(p4, 2)), norm(sum(p5, 2))]
