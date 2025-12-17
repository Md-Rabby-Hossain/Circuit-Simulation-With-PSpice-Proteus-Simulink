% --- original data (unchanged) ---
f  = [15 20 50 100 300 1000 3000 5000 10000 20000 50000 100000];
g  = [33.48 33.62 33.77 33.90 33.90 33.90 33.90 33.77 33.62 33.48 33.02 31.41];
f1 = [10 15 20 50 100 300 1000 3000 5000 10000 50000 100000 200000 300000];
g1 = [35.79 35.90 36.01 36.12 36.12 36.12 36.12 36.01 35.90 35.79 35.33 33.76 31.50 28.56];

% --- compute cutoffs for both datasets ---
[fL_rc, fH_rc] = find_3db_cutoffs(f, g);
[fL_dc, fH_dc] = find_3db_cutoffs(f1, g1);

% --- plot (exact data only) ---
figure('Color','w');

% RC curve (red) and DC curve (blue), line width = 2
semilogx(f,  g, '-o', 'Color','r', 'LineWidth',2, 'MarkerSize',6); hold on
semilogx(f1, g1, '-s', 'Color','b', 'LineWidth',2, 'MarkerSize',6);

% --- Plot -3 dB horizontal lines ---
mid_rc = max(g);
mid_dc = max(g1);
yline(mid_rc - 3, '--r', '-3 dB (RC)', 'LineWidth',2, 'LabelHorizontalAlignment','left');
yline(mid_dc - 3, '--b', '-3 dB (DC)', 'LineWidth',2, 'LabelHorizontalAlignment','left');

% --- Plot vertical cutoff lines only if found ---
if ~isnan(fL_rc)
    xline(fL_rc, '--r', ['fL(RC) = ' num2str(fL_rc,'%.2f') ' Hz'], 'LineWidth',2, 'LabelVerticalAlignment','bottom');
end
if ~isnan(fH_rc)
    xline(fH_rc, '--r', ['fH(RC) = ' num2str(fH_rc,'%.2f') ' Hz'], 'LineWidth',2, 'LabelVerticalAlignment','bottom');
end
if ~isnan(fL_dc)
    xline(fL_dc, '--b', ['fL(DC) = ' num2str(fL_dc,'%.2f') ' Hz'], 'LineWidth',2, 'LabelVerticalAlignment','top');
end
if ~isnan(fH_dc)
    xline(fH_dc, '--b', ['fH(DC) = ' num2str(fH_dc,'%.2f') ' Hz'], 'LineWidth',2, 'LabelVerticalAlignment','top');
end

% --- Finalize axes & style ---
title('Frequency Response Curve of RC and DC Amplifier', 'FontWeight','bold');
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
legend('RC Coupling','DC (Direct) Coupling','Location','Best');
grid on;
xlim([1 3e5]);
ylim([30 37]);
yticks(30:0.5:37);

% Set solid black grid lines
set(gca, 'FontSize',11, ...
         'YMinorGrid','on', ...
         'LineWidth',1, ...
         'GridLineStyle','-', ...
         'MinorGridLineStyle','-', ...
         'GridColor',[0 0 0], ...       % black major grid
         'MinorGridColor',[0 0 0], ...  % black minor grid
         'GridAlpha',1.0, ...
         'MinorGridAlpha',0.7);

hold off;

% --- helper function to find -3 dB cutoffs robustly ---
function [fL, fH] = find_3db_cutoffs(freq, gain)
    mid_idx = find(gain == max(gain), 1, 'first');     % index of midband peak
    cut_level = max(gain) - 3;
    fL = NaN; fH = NaN;

    % --- lower cutoff: search between start and mid_idx
    if mid_idx > 1
        below_idxs = find(gain(1:mid_idx) < cut_level);
        if ~isempty(below_idxs)
            i = below_idxs(end); % last index below cut
            if i < mid_idx
                x = log([freq(i), freq(i+1)]);
                y = [gain(i), gain(i+1)];
                logf_at_cut = interp1(y, x, cut_level, 'linear');
                fL = exp(logf_at_cut);
            end
        end
    end

    % --- upper cutoff: search between mid_idx and end
    if mid_idx < length(gain)
        above_idxs = find(gain(mid_idx:end) < cut_level);
        if ~isempty(above_idxs)
            j = above_idxs(1) + (mid_idx - 1);
            if j > mid_idx
                x = log([freq(j-1), freq(j)]);
                y = [gain(j-1), gain(j)];
                logf_at_cut = interp1(y, x, cut_level, 'linear');
                fH = exp(logf_at_cut);
            end
        end
    end
end
