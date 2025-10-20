% Configuración del puerto serial
comPort = 'COM3'; % Reemplacen 'COMx' con el puerto correspondiente a su ESP32 o Arduino
baudRate = 115200; % TIENE QUE SER LA MISMA QUE ASIGNARON EN LA PLACA

s = serialport(comPort, baudRate); % Abre el puerto serial
configureTerminator(s, "LF");     % Configura el terminador de línea
disp('Conectado al ESP32.'); % Mensaje para corroborar la conexión

% Configuración para graficar en vivo
figure;
hold on;
grid on;
xlabel('Tiempo (s)');
ylabel('Valor del sensor');
title('Lectura en tiempo real del pin analógico');

t = 0; % Tiempo inicial
tic;   % Inicia el cronómetro

i = 0;

sampleTime = 0.02; % Set sample time to 20 ms
maxSamples = ceil(5 / sampleTime); % Preallocate arrays based on sample time
fcg = zeros(1, maxSamples);
time = zeros(1, maxSamples);

while t < 5
    try
        i = i + 1;
        data = readline(s);
        pause(sampleTime); % Maintain 20 ms delay between iterations
        value = str2double(data); % Convert data to number
        if ~isnan(value)
            t = toc;
            time(i) = t;
            fcg(i) = value;
            if mod(i, 5) == 0 % Update plot every 5 iterations
                plot(t, value, 'bo');
                drawnow;
            end
        end
    catch
        warning('Error al leer datos del ESP32.');
        break;
    end
end