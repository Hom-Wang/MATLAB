clear all;

ThetaToRad = pi / 180;

a = 6;
b = 5;
c = 10;
x0 = -8;
y0 = 2;
z0 = 4;

figure(1);
title('Ellipsoid Fitting draw by Hom');
plot3(x0, y0, z0, 'or');
xlabel('x');
ylabel('y');
zlabel('z');
hold on
grid on;
axis equal

i = 0;
for theta = [0 : 10 : 180]
    for phi = [0 : 20 : 360]
        i = i + 1;
        x(i) = x0 + a * sin(theta * ThetaToRad) .* cos(phi .* ThetaToRad);
        y(i) = y0 + b * sin(theta * ThetaToRad) .* sin(phi .* ThetaToRad);
        z(i) = z0 + c * cos(theta * ThetaToRad) .* ones(size(phi));
    end
end

x = x' + 1 .* rand(size(x, 2), 1) - 1;
y = y' + 1 .* rand(size(y, 2), 1) - 1;
z = z' + 1 .* rand(size(z, 2), 1) - 1;

tx = 30;
ty = 60;
tz = 10;
Rx = [1, 0, 0; 0, cos(tx), -sin(tx); 0, sin(tx), cos(tx)];
Ry = [cos(ty), 0, sin(ty); 0, 1, 0; -sin(ty), 0, cos(ty)];
Rz = [cos(tz), -sin(tz), 0; sin(tz), cos(tz), 0; 0, 0, 1];

matrixR = Rz*Ry*Rx;
X = x*matrixR(1, 1) + y*matrixR(1, 2) + z*matrixR(1, 3);
Y = x*matrixR(2, 1) + y*matrixR(2, 2) + z*matrixR(2, 3);
Z = x*matrixR(3, 1) + y*matrixR(3, 2) + z*matrixR(3, 3);

fm = 0;
for i = 1 : 8 : size(x, 1)
	plot3(X(1:i), Y(1:i), Z(1:i), 'xb');
    if i >= 10
        %
        coff = ellipsoidFit(X(1:i), Y(1:i), Z(1:i));
        hold on
        [fx, fy, fz] = meshgrid(linspace(-40, 40));
        f = @(x, y, z) (coff(1)*x.^2 + coff(2)*x.*y + coff(3)*y.^2 + coff(4)*x.*z + coff(5)*y.*z + coff(6)*z.^2 + coff(7)*x + coff(8)*y + coff(9)*z + coff(10)); 
        p = patch(isosurface(fx, fy, fz, f(fx,fy,fz), 0));
        view(3);
        set(p,'FaceVertexCData',jet(size(get(p,'faces'),1)) ,'FaceColor', 'flat', 'EdgeColor', 'none');
        %
    end
    title('Ellipsoid Fitting draw by Hom');
    xlabel('x');
    ylabel('y');
    zlabel('z');
    grid on;
    axis equal;
    hold off

    fm = fm + 1;
    frames(fm) = getframe(1, [70, 0, 420, 420]);
end

dt = 0;
filename = 'ellipsoidFitting.gif';
getGIF(filename, frames, 128, dt);
