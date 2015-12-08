function distance = rssi_to_distance( rssi, tx_power, n )

    % RSSI = P_recv = P_1m - 10 * n * log10(d)
    distance = 10^((tx_power - rssi) / (10 * n));

end
