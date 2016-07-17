function quadPlot = plotQuadcopter( position, attitude, throttle )

    global quadParam;
    quadPlot = struct;

    % draw propeller
    theta = linspace(0, 2 * pi, 40);
    propCircle = zeros(3, 40);
    propCircle(1, :) = quadParam.propRadius * cos(theta);
    propCircle(2, :) = quadParam.propRadius * sin(theta);

    plotProp = zeros(3, 40, 4);
    for i = 1 : 4
        plotProp(1, :, i) = position(1) + quadParam.propCenter(1, i) + propCircle(1, :);
        plotProp(2, :, i) = position(2) + quadParam.propCenter(2, i) + propCircle(2, :);
        plotProp(3, :, i) = position(3) + quadParam.propCenter(3, i) + propCircle(3, :);
    end
    quadPlot.f(1) = fill3(plotProp(1, :, 1), plotProp(2, :, 1), plotProp(3, :, 1), 'g', 'linewidth', 2);
    quadPlot.f(2) = fill3(plotProp(1, :, 2), plotProp(2, :, 2), plotProp(3, :, 2), 'g', 'linewidth', 2);
    quadPlot.f(3) = fill3(plotProp(1, :, 3), plotProp(2, :, 3), plotProp(3, :, 3), 'g', 'linewidth', 2);
    quadPlot.f(4) = fill3(plotProp(1, :, 4), plotProp(2, :, 4), plotProp(3, :, 4), 'g', 'linewidth', 2);
    alpha(0.6);

    % draw frame
    plotFrame = zeros(3, 4, 2);
    plotFrame(:, :, 1) = [ quadParam.propCenter(1, 1), quadParam.propCenter(1, 1), quadParam.propCenter(1, 3), quadParam.propCenter(1, 3); ...
                           quadParam.propCenter(2, 1), quadParam.propCenter(2, 1), quadParam.propCenter(2, 3), quadParam.propCenter(2, 3); ...
                           quadParam.propCenter(3, 1),                          0,                          0, quadParam.propCenter(3, 3) ];
    plotFrame(:, :, 2) = [ quadParam.propCenter(1, 2), quadParam.propCenter(1, 2), quadParam.propCenter(1, 4), quadParam.propCenter(1, 4); ...
                           quadParam.propCenter(2, 2), quadParam.propCenter(2, 2), quadParam.propCenter(2, 4), quadParam.propCenter(2, 4); ...
                           quadParam.propCenter(3, 2),                          0,                          0, quadParam.propCenter(3, 4) ];
    plotFrame(1, :, 1) = plotFrame(1, :, 1) + position(1);
    plotFrame(2, :, 1) = plotFrame(2, :, 1) + position(2);
    plotFrame(3, :, 1) = plotFrame(3, :, 1) + position(3);
    plotFrame(1, :, 2) = plotFrame(1, :, 2) + position(1);
    plotFrame(2, :, 2) = plotFrame(2, :, 2) + position(2);
    plotFrame(3, :, 2) = plotFrame(3, :, 2) + position(3);
    quadPlot.f(5) = plot3(plotFrame(1, :, 1), plotFrame(2, :, 1), plotFrame(3, :, 1), 'k', 'linewidth', 4);
    quadPlot.f(6) = plot3(plotFrame(1, :, 2), plotFrame(2, :, 2), plotFrame(3, :, 2), 'k', 'linewidth', 4);

    % draw ball
    [x, y, z] = sphere(8);
    x = x * 0.01;
    y = y * 0.01;
    z = z * 0.01;
    colormap([0, 0, 0]);

    plotBall = quadParam.propCenter;
    plotBall(1, :) = plotBall(1, :) + position(1);
    plotBall(2, :) = plotBall(2, :) + position(2);
    plotBall(3, :) = plotBall(3, :) + position(3);
    quadPlot.f(7)  = surf(x + plotBall(1, 1), y + plotBall(2, 1), z + plotBall(3, 1));
    quadPlot.f(8)  = surf(x + plotBall(1, 2), y + plotBall(2, 2), z + plotBall(3, 2));
    quadPlot.f(9)  = surf(x + plotBall(1, 3), y + plotBall(2, 3), z + plotBall(3, 3));
    quadPlot.f(10) = surf(x + plotBall(1, 4), y + plotBall(2, 4), z + plotBall(3, 4));
    quadPlot.f(11) = surf(x * 2 + position(1), y * 2 + position(2), z * 2 + position(3));

	% draw throttle
%
    plotThr = quadParam.throttle;
    plotThr(1, :) = plotThr(1, :) + position(1);
    plotThr(2, :) = plotThr(2, :) + position(2);
    plotThr(3, :) = plotThr(3, :) + position(3);
    thr = throttle * 0.22 + plotThr(3, 1);
    quadPlot.f(12) = plot3([plotThr(1, 1), plotThr(1, 1)], [plotThr(2, 1), plotThr(2, 1)], [plotThr(3, 1), thr(1)], 'r', 'linewidth', 4);
    quadPlot.f(13) = plot3([plotThr(1, 2), plotThr(1, 2)], [plotThr(2, 2), plotThr(2, 2)], [plotThr(3, 2), thr(2)], 'r', 'linewidth', 4);
    quadPlot.f(14) = plot3([plotThr(1, 3), plotThr(1, 3)], [plotThr(2, 3), plotThr(2, 3)], [plotThr(3, 3), thr(3)], 'r', 'linewidth', 4);
    quadPlot.f(15) = plot3([plotThr(1, 4), plotThr(1, 4)], [plotThr(2, 4), plotThr(2, 4)], [plotThr(3, 4), thr(4)], 'r', 'linewidth', 4);
%}
    % draw direction
    plotDir = quadParam.dirArrow;
    plotDir(1, :) = plotDir(1, :) + position(1);
    plotDir(2, :) = plotDir(2, :) + position(2);
    plotDir(3, :) = plotDir(3, :) + position(3);
    quadPlot.f(16) = fill3(plotDir(1, :), plotDir(2, :), plotDir(3, :), 'r', 'linewidth', 2);

    % rotate
    rotate(quadPlot.f, [ 1,  0,  0], attitude(2), position);   % roll
    rotate(quadPlot.f, [ 0, -1,  0], attitude(1), position);   % pitch
    rotate(quadPlot.f, [ 0,  0, -1], attitude(3), position);   % yaw

end
