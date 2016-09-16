classdef kSerial_Oscilloscope < handle

properties (SetAccess = public)

end

properties (SetAccess = private)
    fig;
    subPlot;
    curve;
    window = struct;
end

methods

    function osc = kSerial_Oscilloscope( ~ )
        osc.fig     = figure(1);
        osc.subPlot = subplot(1, 1, 1);
        osc.curve   = plot(0, 0);

        osc.window.width =  800;
        osc.window.displayPos = osc.window.width * (-0.9);
        osc.window.xmax  = osc.window.displayPos + osc.window.width;
        osc.window.xmin  = osc.window.displayPos;
        osc.window.ymax  =  200;
        osc.window.ymin  = -200;

        xlabel(osc.subPlot, 'runtimes');
        ylabel(osc.subPlot, 'data');
        grid(osc.subPlot, 'on');
        hold(osc.subPlot, 'on');

        set(osc.fig, 'Position', [100, 100, 1200, 600], 'color', 'w');
        axis(osc.subPlot, [osc.window.xmin, osc.window.xmax, osc.window.ymin, osc.window.ymax]);
    end

	function setWindow( osc, ymax, ymin, width )
        osc.window.width = width;
        osc.window.displayPos = osc.window.width * (-0.9);
        osc.window.xmax  = osc.window.displayPos + osc.window.width;
        osc.window.xmin  = osc.window.displayPos;
        osc.window.ymax  = ymax;
        osc.window.ymin  = ymin;
    end

    function updateOscilloscope( osc, s )
        delete(osc.curve);
        runtimes = (s.packet.packetCount - osc.window.width + 1) : s.packet.packetCount;
        osc.curve(1) = plot(osc.subPlot, runtimes, s.dataBuffer(10, end - osc.window.width + 1 : end), 'r');
        osc.curve(2) = plot(osc.subPlot, runtimes, s.dataBuffer(11, end - osc.window.width + 1 : end), 'g');
        osc.curve(3) = plot(osc.subPlot, runtimes, s.dataBuffer(12, end - osc.window.width + 1 : end), 'b');
        osc.window.xmin = osc.window.xmin + s.packet.availableData;
        osc.window.xmax = osc.window.xmin + osc.window.width;
        axis(osc.subPlot, [osc.window.xmin, osc.window.xmax, osc.window.ymin, osc.window.ymax]);
        drawnow
    end

end

end
