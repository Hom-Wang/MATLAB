close all;
clear all;

refA = 1000;    % 1000 mg

% parameters
%    k11,k12,k13,k22,K23,k33,  bx,by,bz
X  = [ 1;  0;  0;  1;  0;  1;    0; 0; 0 ];
rX = [ 0.9980; -0.0109; 0.0293; 1.0419; 0.0509; 0.9552; 35.9405; 31.0196; -67.4777 ];

K = [ rX(1), rX(2), rX(3); ...
      rX(2), rX(4), rX(5); ...
      rX(3), rX(5), rX(6) ];
B = [ rX(7); ...
      rX(8); ...
      rX(9) ];

% measure data
A = [ +1.0, -1.0,    0,    0,    0,    0, +0.707, +0.707, -0.707,  -0.707, +0.707,  +0.707,  -0.707,  -0.707,      0,       0,       0,       0; ...
         0,    0, +1.0, -1.0,    0,    0. +0.707, -0.707, -0.707,  +0.707,      0,       0,       0,       0, +0.707,  +0.707,  -0.707,  -0.707; ...
         0,    0,    0,    0, +1.0, -1.0,      0,      0,      0,       0, +0.707,  -0.707,  -0.707,  +0.707, +0.707,  -0.707,  -0.707,  +0.707; ];

N = size(A, 2);
for i = 1 : N
    noiseA(:, i) = inv(K) * refA * A(:, i) + B;
end

alpha = 0.32;
saveLens = 0;
for k = 0 : 100

    error2     = 0;
    gradientE  = zeros(9, 1);
    gradient2E = zeros(9, 9);
    for i = 1 : N
        error2     = error2 + eq_e(X, noiseA(:, i), refA)^2;
        gradientE  = gradientE   + 2 * eq_e(X, noiseA(:, i), refA) * eq_Ge(X, noiseA(:, i))';
        gradient2E = gradient2E  + 2 * eq_Ge(X, noiseA(:, i))' * eq_Ge(X, noiseA(:, i));
    end

    corr   = inv(gradient2E) * gradientE;
    X = X - alpha * corr;

    % save data  ------------------------------------ SAVE VARIABLE
    saveLens = saveLens + 1;
    save_err2(saveLens)    = error2;
    save_alpha(saveLens)   = alpha;
    save_corr(:, saveLens) = corr;
    save_pX(:, saveLens)   = X;

    % stop condition
    if saveLens > 2
        DX = save_pX(:, end) - save_pX(:, end - 1);
        SX = save_pX(:, end) + save_pX(:, end - 1);
        EP = DX ./ SX;
        if max(EP) < 1.5 * 10^-6
            break;
        end
    end

end

dataLens = [1 : saveLens] - 1;

%
figure(1);  % --------------------------------------- FIGURE 1
grid on;  hold on;
plot(dataLens, save_pX(1, :));
plot(dataLens, save_pX(2, :));
plot(dataLens, save_pX(3, :));
plot(dataLens, save_pX(4, :));
plot(dataLens, save_pX(5, :));
plot(dataLens, save_pX(6, :));
plot(dataLens, save_pX(7, :));
plot(dataLens, save_pX(8, :));
plot(dataLens, save_pX(9, :));
title('parameter X');
legend('k_1_1', 'k_1_2', 'k_1_3', 'k_2_2', 'k_2_3', 'k_3_3', 'b_x', 'b_y', 'b_z');
%}
%
figure(2);  % --------------------------------------- FIGURE 2
grid on;  hold on;
plot(dataLens, save_corr(1, :));
plot(dataLens, save_corr(2, :));
plot(dataLens, save_corr(3, :));
plot(dataLens, save_corr(4, :));
plot(dataLens, save_corr(5, :));
plot(dataLens, save_corr(6, :));
plot(dataLens, save_corr(7, :));
plot(dataLens, save_corr(8, :));
plot(dataLens, save_corr(9, :));
title('correction');
legend('k_1_1', 'k_1_2', 'k_1_3', 'k_2_2', 'k_2_3', 'k_3_3', 'b_x', 'b_y', 'b_z');
%}
%{
figure(3);  % --------------------------------------- FIGURE 3
grid on;  hold on;
plot(dataLens, save_alpha);
title('update rate');
legend('alpha');
%}
%
figure(4);  % --------------------------------------- FIGURE 4
grid on;  hold on;
plot(dataLens, save_err2);
title('error^2');
legend('e^2');
%}

% --------------------------------------- ERROR
%{
fprintf('k11 = %f\n', save_pX(1, end));
fprintf('k12 = %f\n', save_pX(2, end));
fprintf('k13 = %f\n', save_pX(3, end));
fprintf('k22 = %f\n', save_pX(4, end));
fprintf('k23 = %f\n', save_pX(5, end));
fprintf('k33 = %f\n', save_pX(6, end));
fprintf('bx  = %f\n', save_pX(7, end));
fprintf('by  = %f\n', save_pX(8, end));
fprintf('bz  = %f\n', save_pX(9, end));
%}

ERR = ((X - rX) ./ rX)' * 100;
str = '\n----- ERROR -----\n';
str = strcat(str, '             K_11,        K_12,       K_13,       K_22,       K_23,       K_33,        b_x,        b_y,        b_z,            error^2\n');
str = strcat(str, 'origin   = %.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f\n');
str = strcat(str, 'newton   = %.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f\n');
str = strcat(str, 'error(%%) = %.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f,\t%.6f,\t\t%f\n');
fprintf(str, rX, save_pX(:, end), ERR, save_err2(end))
