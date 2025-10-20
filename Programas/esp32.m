a = arduino;
%% 
a.AvailableAnalogPins
%% 
figure;
hold on;
grid on;
xlabel('Tiempo (s)');
ylabel('Valor del sensor');
title('Lectura en tiempo real del pin analógico');

t = 0; % Tiempo inicial
tic;   % Inicia el cronómetro

%n = 100; % Assume you want to add 100 elements
%ls = zeros(1, n); % Preallocate an array of zeros with size 1xn
for i = 1:n
    fcg = readVoltage(a,"D2"); % Assign values to the array
    t = toc; % Tiempo transcurrido
    plot(t, fcg,'bo'); % Grafica con puntos azules
    drawnow;
end
% Display the array
%plot(time,fcg)
%xlabel('Tiempo (s)');
%ylabel('Valor del sensor');

%% 