function rssi = distance_to_rssi( distance, tx_power, n )

    % RSSI = P_recv = P_1m - 10 * n * log10(d)
    rssi = tx_power - 10 * n * log10(distance);

end
