%ESTE CÓDIGO TIENE UN RETRASO DE 1.14 SEGUNDOS EN REGISTRAR LA SEÑAL
%ESTE CÓDIGO YA FUNCIONAAA


% Serial communication setup
serialPort = "COM3"; % Replace with the actual port
baudRate = 115200; 
esp32 = serialport(serialPort, baudRate);

% Data acquisition parameters
numSamples = 5000; % Number of samples
data = zeros(1, numSamples); % Preallocate for efficiency
time = zeros(1, numSamples);

% Reading loop
disp('Reading data from ESP32...');
tic; % Start timer
for i = 1:numSamples
    if esp32.NumBytesAvailable > 0
        rawData = readline(esp32); % Read data from ESP32
        value = str2double(rawData); % Convert to number
        if ~isnan(value) % Check for valid data
            data(i) = value;
            time(i) = toc;
        else
            warning('Invalid data received: %s', rawData);
        end
    else
        disp('No data available yet.');
    end
    pause(0.001); % Match ESP32 delay
end

% Close serial port
clear esp32;

data(1:783) = []; % Remove the first 787 elements
time(1:783) = [];
%%
% Plot results
figure;
plot(data);
xlabel('Time (s)');
ylabel('Analog Signal');
title('Analog Signal from ESP32');
grid on;
%% GRAFICAR SEÑAL CARGADA Y OBTENER EL ESPECTRO DE FRECUENCIA
%Espectro de frecuencias
tiempo=transpose(time);
Fs=1000;                              %FRECUENCIA DE MUESTREO
L=length(data); %número de datos
t=L/Fs; % número de datos/frecuencia de muestreo
x=data; %renombrar al voltaje
%Obtención del espectro
Y = fft(x); %aplicar transformada de fourier
P2 = abs(Y/L); %fourier/número de datos
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

%Graficar señal y el espectro de frecuencias
figure
subplot(2,1,1)
plot(tiempo,data); title("Corazón"); xlabel("tiempo [s]"); ylabel("voltaje [V]")
subplot(2,1,2)
plot(f,P1) 
title('Frequency Spectrum Plot')
ylim([0,0.1])
xlabel('f (Hz)')
xlim([0,100])
ylabel('|P1(f)|')

%% FILTRO DIGITAL PASA BANDAS
filt=bandpass(x,[20,75],Fs);
%graficar señales y sus espectros de frecuencia
figure
bandpass(x,[20,75],Fs) 

%% GENERAR SONIDO CON SEÑAL ORIGINAL
filt1=normalize(filt,"range",[-1,1]);
%probe1=repmat(filt1,2,1);
%sound(filt1,1000)
%song=audioplayer(probe1,1000);
%play(song)
%audiowrite("prueba_corazon.wav",filt1,1000)

%% PRUEBAS CON RESAMPLE
target_length = 185220;
audio_resampled = resample(filt1, target_length, length(filt1));
audio_resampled=normalize(audio_resampled,"range",[-1,1]);
figure
plot(audio_resampled)
%% GENERAR SONIDO CON SEÑAL RESAMPLE
sound(audio_resampled,44100)
audiowrite("prueba_corazon_resample.wav",audio_resampled,44100)
%% GRAFICAR LA SEÑAL FINAL YA FILTRADA
tiempo_cali=0:0.001:4.216;
figure
subplot(2,1,1)
plot(tiempo_cali,filt1,"black") %señal normal
set(gca,'XTick',0:0.2:4.4) %para tener en el eje x cada 200ms
set(gca,'YTick',-1:0.2:1) %para tener en el eje x cada 200ms
set(gca,'color',"#F08080")
title('Señal del Corazón'); xlabel('Tiempo [s]'); ylabel('Amplitud [V]'); grid on
subplot(2,1,2)
plot(audio_resampled) %señal resample
title("Señal para archivo WAV")
%% Encontrar los picos
[amp,pos]=findpeaks(filt1,"MinPeakHeight",0.75); 
frec_cardiaca=length(pos)/2*30; %calcular frecuencia cardiaca
figure
findpeaks(filt1,"MinPeakHeight",0.75)


