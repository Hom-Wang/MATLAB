classdef kGifConv < handle

properties (SetAccess = public)
    filename  = 'k.gif';
    rgbColors = 128;
    dt        = 0.2;
end

properties (SetAccess = private)
    frames = getframe(1);
    count = 0;
end

methods

function kgif = kGifConv( filename )
    kgif.filename = filename;
end

function conv( kgif )
    for i = 1 : size(kgif.frames, 2)
        image = frame2im(kgif.frames(i));
        [im, map] = rgb2ind(image, kgif.rgbColors);
        if i == 1
            imwrite(im, map, kgif.filename, 'gif', 'writeMode', 'overWrite', 'delayTime', kgif.dt, 'loopcount', inf);
        else
            imwrite(im, map, kgif.filename, 'gif', 'writeMode', 'append', 'delayTime', kgif.dt);
        end
    end
end

function record( kgif, fig )
    kgif.count = kgif.count + 1;
    kgif.frames(kgif.count) = getframe(fig);   % kgif.frames(kgif.count) = getframe(fig, [70, 20, 1100, 650]);
end

end

end
