function [aveData, p_front] = moveAve_s( newData, moveAveFIFO, fifoLens, windowLens )

    p_front = moveAveFIFO(1);
    p_rear  = mod(p_front - windowLens + fifoLens, fifoLens) + 1;

%    moveAveFIFO(p_front + 1) = newData;

    sumData = 0;
    if p_front > p_rear
        for i = p_front : -1 : p_rear
            sumData = sumData + moveAveFIFO(i + 1);
        end
    else
        for i = p_front : -1 : 1
            sumData = sumData + moveAveFIFO(i + 1);
        end
        for i = fifoLens : -1 : p_rear
            sumData = sumData + moveAveFIFO(i + 1);
        end
    end

    aveData = sumData / windowLens;
    p_front = mod(p_front, fifoLens) + 1;

end
