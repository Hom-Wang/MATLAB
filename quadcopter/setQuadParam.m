%{
frame     : 220 mm motor to motor
propeller : 5 inch (127mm) propeller
unit      : meter (mm)
%}

clear all

global quadParam;

quadParam = struct;

% frame
quadParam.frameSize   = 0.22;      % 220 mm motor to motor
quadParam.frameRadius = quadParam.frameSize / 2;

% propeller
quadParam.propSize   = 5;   % 5 inch (127mm) propeller
quadParam.propRadius = (quadParam.propSize * 25.4) / 2000;  % inch to m
quadParam.propHeight = 0.03;    % 30 mm
quadParam.propCenter = zeros(3, 4);
quadParam.propCenter(:, 1) = [quadParam.frameRadius * cos(1 * pi/4); quadParam.frameRadius * sin(1 * pi/4); quadParam.propHeight];
quadParam.propCenter(:, 2) = [quadParam.frameRadius * cos(3 * pi/4); quadParam.frameRadius * sin(3 * pi/4); quadParam.propHeight];
quadParam.propCenter(:, 3) = [quadParam.frameRadius * cos(5 * pi/4); quadParam.frameRadius * sin(5 * pi/4); quadParam.propHeight];
quadParam.propCenter(:, 4) = [quadParam.frameRadius * cos(7 * pi/4); quadParam.frameRadius * sin(7 * pi/4); quadParam.propHeight];

% throttle
quadParam.throttle = zeros(3, 4);
quadParam.throttle(:, 1) = [quadParam.propCenter(1 : 2, 1); quadParam.propHeight * 2];
quadParam.throttle(:, 2) = [quadParam.propCenter(1 : 2, 2); quadParam.propHeight * 2];
quadParam.throttle(:, 3) = [quadParam.propCenter(1 : 2, 3); quadParam.propHeight * 2];
quadParam.throttle(:, 4) = [quadParam.propCenter(1 : 2, 4); quadParam.propHeight * 2];

% direction arrow
quadParam.dirArrow = zeros(3, 3)
quadParam.dirArrow(:, 1) = [0.14;     0; 0];
quadParam.dirArrow(:, 2) = [0.11;  0.02; 0];
quadParam.dirArrow(:, 3) = [0.11; -0.02; 0];
