
% pos    x1  x2  x3 ... dxn
%        y1  y2  y3 ... dyn
% vmax  ---  v2  v3 ... vn
%       ---  a2  a3 ... an
% dt     dt

%{
cpath = pathCreater(pos, vmax, dt);
pos  = cpath(1:2, :);
vel  = cpath(3:4, :);
acc  = cpath(5:6, :);
head = cpath(7, :);
time = cpath(8, :);
%}

function cpath = pathCreater2D( pos, vmax, dt )

[ dp, np ] = size(pos);
[ dv, nv ] = size(vmax);
if dp ~= 2
    error('[1] pos format error');
elseif (dv ~= 2) || (vmax(1, 1) ~= 0) || (vmax(2, 1) ~= 0)
    error('[2] vmax format error');
elseif (np < 2) || (nv < 2)
    error('[3] input data num error');
end

[p, v, a, h, t] = singlePath(pos(:, 1:2), vmax(1, 2), vmax(2, 2), 0, dt);
cpath = [p; v; a; h; t];
for i = 2 : np - 1
    [p, v, a, h, t] = singlePath(pos(:, i:i+1), vmax(1, i+1), vmax(2, i+1), t(end), dt);
    cpath = [cpath(:, 1:end-1), [p; v; a; h; t]];
end

end

function [pos, vel, acc, head, time] = singlePath( pm, vm, am, t, dt )

dx = pm(1, 2) - pm(1, 1);
dy = pm(2, 2) - pm(2, 1);
d  = sqrt(dx^2 + dy^2);
ta = (vm - 0) / am;
t1 = t;
t  = d / vm - ta;
t2 = t1 + t + 2 * ta;

lens  = size(t1 : dt : t2, 2);
p = zeros(1, lens);
v = zeros(1, lens);
a = zeros(1, lens);

if (t <= 0)
    % acc too small, no enough time to get to vmax ...
    error('[4] acc too small');

else
    % time segmentation
    tm = zeros(1, 4);
    tm(1) = 1;
    tm(2) = tm(1) + fix(ta / dt);
    tm(3) = tm(2) + fix(t  / dt);
    tm(4) = tm(3) + fix(ta / dt);

    % calculate velocity
    v(tm(1) : tm(2)) = linspace(0, vm, ta / dt + 1);	% v0 to vmax
    v(tm(2) : tm(3)) = ones(1, tm(3) - tm(2) + 1) * vm;	% vmax
    v(tm(3) : tm(4)) = linspace(vm, 0, ta / dt + 1);	% vmax to v0

end

% calculate position and acceleration
a(1) = am;
for i = 2 : lens
    a(i) = (v(:, i) - v(:, i - 1)) / dt;
    p(i) = p(:, i - 1) + v(:, i) * dt;
end

% calculate head
head = atan2(dy, dx) * 180 / pi;
if head < 0
    head = head + 360;
end

% convert to global data
R = [cosd(head); sind(head)];
pos = R * p + pm(:, 1) * ones(1, lens);
vel = R * v;
acc = R * a;
head = head * ones(1, lens);
time = t1 : dt : t2;

end
