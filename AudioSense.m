clc; clear; close all; % Clear command window, workspace, and close all figures

% Set audio recording parameters
Fs = 44100; % Sampling frequency for recording
nBits = 16; % Bit depth
nChannels = 1; % Mono recording

% Create an audio recorder object
recorder = audiorecorder(Fs, nBits, nChannels);

% Take user input for recording duration
t1 = input("Enter the time you want to record (in seconds): ");
disp('Recording... Speak Now');
recordblocking(recorder, t1); % Record for the specified duration
disp('Recording finished.');

% Retrieve recorded audio data
audio = getaudiodata(recorder);

% Take gain values from user
gain = input('Enter gain factor for original audio: ');  % Gain before filtering
amp_factor = input('Enter amplification factor after filtering: '); % Gain after filtering

% Apply gain to the original audio
audio_multiplied = gain * audio; 

% Define and apply a low-pass filter
Fc = 1000; % Cut-off frequency in Hz
[b, a] = butter(6, Fc/(Fs/2), 'low'); % 6th order Butterworth low-pass filter
audio_filtered = filter(b, a, audio_multiplied);

% Apply additional amplification after filtering
audio_amplified = amp_factor * audio_filtered;

% Time vector for plotting (using Fs for original signal analysis)
t = 0:1/Fs:(length(audio)-1)/Fs;

% Play original audio
disp('Playing Original Audio...');
sound(audio, Fs);
pause(length(audio)/Fs + 1); % Pause to allow playback to finish

% Play filtered audio
disp('Playing Filtered Audio...');
sound(audio_filtered, Fs);
pause(length(audio_filtered)/Fs + 1); % Pause to allow playback to finish

% Play amplified audio
disp('Playing Amplified Audio...');
sound(audio_amplified, Fs);

% Plot original, filtered, and amplified signals
figure;
subplot(3,1,1);
plot(t, audio);
title('Original Audio');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,2);
plot(t, audio_filtered);
title('Filtered Audio (Low-Pass)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,3);
plot(t, audio_amplified);
title('Amplified Audio');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Take user input for a different sampling frequency for Fourier Transform
Fs1 = input('Enter the sampling frequency for Fourier Transform (>=1000 Hz): ');

% Create a new figure for frequency analysis
figure;

% Resample audio to Fs_fft for proper Fourier Transform
audio_resampled = resample(audio, Fs1, Fs);
n = length(audio_resampled);
t1 = 0:1/Fs1:(n-1)/Fs1;

% Plot time-domain representation of recorded signal using Fs_fft
subplot(2,1,1);
plot(t1, audio_resampled, 'LineWidth', 1.5);
xlabel('Time (sec)');
ylabel('Amplitude');
title('Time Domain Plot of the Resampled Signal'); 

% Compute and plot frequency-domain representation using Fs_fft
Y = fft(audio_resampled, n);
F_0 = (-n/2:n/2-1) .* (Fs1/n);
Y_0 = fftshift(Y);
Ay_0 = abs(Y_0);

subplot(2,1,2);
plot(F_0, Ay_0, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Frequency Domain Plot of Resampled Audio Signal');

% Save the recorded audio to a file
filename = 'myvoice.wav';
audiowrite(filename, audio, Fs);
disp(['Audio saved as ', filename]);
