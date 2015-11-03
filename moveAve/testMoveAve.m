clear all;

timeScal = 0.01;
runTimes = 10;

fifoLens = 256;
windowLens = 32;
fifo = zeros(1, fifoLens+1);
fifo(1) = windowLens;

weighted = zeros(1, windowLens + 1);
for i = 1 : windowLens
    weighted(i + 1) = 2^((windowLens - i) / 4);
end
weighted(1) = sum(weighted(2 : end));

saveLens = 0;
for t = 0 : timeScal : runTimes
    newData = sin(t) + randn();

    p_front = fifo(1);
    fifo(p_front + 1) = newData;
    [sma_data, p_front] = moveAve_s(newData, fifo, fifoLens, windowLens);
    [wma_data, p_front] = moveAve_w(newData, fifo, weighted, fifoLens, windowLens);
    fifo(1) = p_front;

    saveLens = saveLens + 1;
    save_org(saveLens)  = sin(t);
    save_orgn(saveLens) = newData;
    save_sma(saveLens)  = sma_data;
    save_wma(saveLens)  = wma_data;
end

hold on;
grid on;
plot([0 : timeScal : runTimes], save_org,  'g');
plot([0 : timeScal : runTimes], save_orgn, 'r');
plot([0 : timeScal : runTimes], save_sma,  'b');
plot([0 : timeScal : runTimes], save_wma,  'c');

xlabel('t(s)');
ylabel('data');
legend('org', 'org + noise', 'sma', 'wma');

