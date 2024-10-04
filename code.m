% Radar Waveform Generation and Analysis

% Parameters
fs = 1e8;         % Sampling frequency (1 MHz)
t = 0:1/fs:0.01;  % Time vector for 10 ms
pulse_width = 1e-3;  % Pulse width for pulse waveform (1 ms)
f0 = 10e7;        % Center frequency for FMCW (10 kHz)
bw = 2e3;         % Bandwidth for FMCW (2 kHz)
fmcw_duration = 0.01; % Duration for FMCW (10 ms)

% Generate Pulse Waveform
pulse_waveform = zeros(size(t));
pulse_waveform(t < pulse_width) = 1; % Rectangular pulse

% Generate FMCW Waveform
fmcw_waveform = zeros(size(t));
fmcw_slope = bw / fmcw_duration; % Frequency slope
for i = 1:length(t)
    if t(i) <= fmcw_duration
        fmcw_waveform(i) = cos(2 * pi * (f0 * t(i) + (fmcw_slope / 2) * t(i)^2));
    end
end

% Time-Frequency Analysis using Short-Time Fourier Transform (STFT)
[~, F_pulse, T_pulse, P_pulse] = spectrogram(pulse_waveform, 256, 250, 256, fs);
[~, F_fmcw, T_fmcw, P_fmcw] = spectrogram(fmcw_waveform, 256, 250, 256, fs);

% Plot Waveforms
figure;
subplot(3, 1, 1);
plot(t, pulse_waveform);
title('Pulse Waveform');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 1, 2);
plot(t, fmcw_waveform);
title('FMCW Waveform');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot Spectrograms
subplot(3, 1, 3);
imagesc(T_pulse, F_pulse, 10*log10(abs(P_pulse)));
axis xy;
title('Spectrogram of Pulse Waveform');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;

figure;
imagesc(T_fmcw, F_fmcw, 10*log10(abs(P_fmcw)));
axis xy;
title('Spectrogram of FMCW Waveform');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;

