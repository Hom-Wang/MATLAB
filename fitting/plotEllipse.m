clear all;

ThetaToRad = pi / 180;

a = 17;
b = 12;
x0 = -100;
y0 = 0;
rot = 60 * ThetaToRad;
theta = [0 : 5 : 360];

x = x0 + a .* cos(theta .* ThetaToRad);
y = y0 + b .* sin(theta .* ThetaToRad);

X = x .* cos(rot) - y .* sin(rot);
Y = x .* sin(rot) + y .* cos(rot);

figure(1);
%plot(X, Y, 'xb');

x = X' + 2 .* rand(size(theta, 2), 1) - 1;
y = Y' + 2 .* rand(size(theta, 2), 1) - 1;

%plot(x, y, 'or');
for i = 1 : size([0 : 5 : 360], 2)

    plot(x(1:i), y(1:i), 'xb');
    title('Ellipse Fitting draw by Hom');
    axis([-70, -30, -110, -65]);
    xlabel('x');
    ylabel('y');
    grid on;
    axis square;
    if i >= 6 
        hold on
        coff = ellipseFit(x(1:i), y(1:i));
        eq = sprintf('%g*x^2 + %g*x*y + %g*y^2 + %g*x + %g*y + %g = 0', coff(1), coff(2), coff(3), coff(4), coff(5), coff(6));
        ezplot(eq, [-70, -30, -110, -65]);
    end
    hold off
    frames(i) = getframe(1, [70, 0, 420, 420]);
end

dt = 0;
filename = 'ellipseFitting.gif';
getGIF(filename, frames, 128, dt);
