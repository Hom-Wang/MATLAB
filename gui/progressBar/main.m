function main()

% start progressBar_gui
progressBar_gui();

% test progressBar_gui
for progress = 1 : 100
    setProgressBar(progress);
    pause(0.1);
end

end


function setProgressBar( progress )

    global myProgressBar

    index = fix((progress - 1) / 10) + 1;
    for i = 1 : 10
        if i > index
            set(myProgressBar.pBar{i}, 'BackgroundColor', [0.831, 0.816, 0.784]);
        else
            set(myProgressBar.pBar{i}, 'BackgroundColor', 'g');
        end
    end
    set(myProgressBar.pText, 'String', strcat(num2str(progress), '%'));

end
