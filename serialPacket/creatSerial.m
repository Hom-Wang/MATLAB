%{
s = creatSerial(baudRate)                   % port = 'auto', set baudRate, no delete instrfindall
s = creatSerial(port, baudRate)             % set port, set baudRate, no delete instrfindall
s = creatSerial(baudRate, 'clear')          % port = 'auto', delete instrfindall
s = creatSerial(port, baudRate, 'clear')    % set port, set baudRate, delete instrfindall
port = 'COMx', 'auto', 'select'
%}

function s = creatSerial( varargin )

switch nargin
	case 1
        port = 'auto';
        baudRate = varargin{1};
	case 2
        if ischar(varargin{1})
            port = varargin{1};
            baudRate = varargin{2};
        else
            port = 'auto';
            baudRate = varargin{1};
            if strcmp(varargin{2}, 'clear')
                delete(instrfindall);
            end
        end
	case 3
        port = varargin{1};
        baudRate = varargin{2};
        if strcmp(varargin{3}, 'clear')
            delete(instrfindall);
        end
    otherwise
        error('input error!!');
end

info = instrhwinfo('serial');
comPortList = info.AvailableSerialPorts;

if strcmp(port, 'auto')
    comPort = char(comPortList(1));
elseif strcmp(port, 'select')
    fprintf('-- serial port : ');
    for i = 1 : size(char(comPortList), 1)
        fprintf(['\t[%d] ', char(comPortList(i))], i);
    end
    comPort = input('\n');
    if isempty(comPort) || (comPort > size(char(comPortList), 1))
        comPort = comPortList(1);
    else
        comPort = comPortList(comPort);
    end
elseif strncmp(port, 'COM', 3)
    comPort = port;
else
    error('com port error!!');
end

s = serial(comPort, 'BaudRate', baudRate, 'DataBits', 8, 'StopBits', 1, 'Parity', 'none', 'FlowControl', 'none');
s.ReadAsyncMode = 'continuous';
s.InputBufferSize = 512;

fprintf(['com port : ', comPort, '\n']);
