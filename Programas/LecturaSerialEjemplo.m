% Configuración del puerto serial
comPort = 'COM3'; % Reemplacen 'COMx' con el puerto correspondiente a su ESP32 o Arduino
baudRate = 115200; %TIENE QUE SER LA MISMA QUE ASIGNARON EN LA PLACA

s = serialport(comPort, baudRate); % Abre el puerto serial
configureTerminator(s, "LF");     % Configura el terminador de línea
disp('Conectado al ESP32.'); %Mensaje para corroborar la conexión

% Configuración para graficar en vivo
figure;
hold on;
grid on;
xlabel('Tiempo (s)');
ylabel('Valor del sensor');
title('Lectura en tiempo real del pin analógico');

t = 0; % Tiempo inicial
tic;   % Inicia el cronómetro

% Bucle para leer datos en vivo
while t<5
    try
        % Lee el dato serial
        data = readline(s);
        value = str2double(data); % Convierte el dato a número
        
        % Valida el dato
        if ~isnan(value)
            % Almacena y grafica en tiempo real
            t = toc; % Tiempo transcurrido
            plot(t, value, 'bo'); % Grafica con puntos azules
            drawnow;
        end
    catch
        warning('Error al leer datos del ESP32.');
        break;
    end
end

% Cierra el puerto serial al finalizar
clear s;
disp('Conexión cerrada.');
