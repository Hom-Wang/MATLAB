function getGIF( filename, frames, rgbColors, dt )

    for i = 1 : size(frames, 2)
        image = frame2im(frames(i));
        [im, map] = rgb2ind(image, rgbColors);
        if i == 1
            imwrite(im, map, filename, 'gif', 'writeMode', 'overWrite', 'delayTime', dt, 'loopcount',inf);
        else
            imwrite(im, map, filename, 'gif', 'writeMode', 'append', 'delayTime', dt);
        end
    end

end

