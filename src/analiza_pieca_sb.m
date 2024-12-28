clear all; close all;

%zebranie danych z konsoli
data = input('Podaj nazwę pliku: ', 's');
T_set = input('Podaj temperaturę zadaną w °C: ');
T_v = input('Podaj prędkość grzania w °C/h: ');
t_T_max = input('Podaj wartość czasu w której pobrać maksymalne temperatury [min]: ');
t_T_max = t_T_max * 120;

%wczytanie danych
cd ..;
cd 'data';
dane = load (data);

%podpisy czujników i wartości zadanych
legends = {'1LGR', '2SG', '3PGR', '4LS', '5PS', '6LDR', '7SD', '8PDR', 'Temp. zadana', 'Prędkość grzania'};

%parametry rezystancji stałych
R = [4.710, 4.655, 4.692, 4.682, 4.652, 4.620, 4.687, 4.728];
R = R * 10^3;           %[Ohm]       
R_T_norm = 10 * 10^3;   %[Ohm]

%parametry termistora
b = 3950;       %[K]
T0 = 298.15;    %[K]
max_temps = [0];%[K]

%parametry uC
digit = 1023;
Vcc = 5;                %[V]
prescaller = Vcc/digit; %[V]

%dodanie nowych kolorów
colors = [245, 20, 190;
          17, 241, 176;
          103, 10, 157;
          255, 33, 164;
          50, 13, 59;
          46, 188, 150;
          117, 201, 65;
          200, 230, 58;
          199, 16, 113;
          222, 169, 20
];

colors = colors./255;

%wektor czasu
t = [0 : 1 : length(dane(:, 1))-1]/120;

%temperatura zadana i prędkość grzania
T_set_vec = [1, 1] * T_set;
T_v_vec = [0, t(length(t))/60] * T_v;

for i = 1 : 8

    %określenie danych dla konkretnego czujnika
    A = dane(:, i);

    %wartość napięcia
    A_u = A .* prescaller;

    %obliczenie rezystancji termistora
    R_T = (Vcc * R(i) - A_u * R(i))./A_u;
    
    %obliczenie temp w stopniach Kelwina
    T_K = b./(log(R_T./R_T_norm) + b/T0);

    %obliczenie temp w stopniach Celcjusza
    T = T_K - 273.15;

    %wyznaczenie temperatur maksymalnych i zapisywanie do pliku
    max_temps(i) = T(t_T_max);
    
    %wizualizacja wyników
    hold on;
    plot(t, T, 'Color', colors(i, :), 'LineWidth', 2);
end 

%narysowanie temperatury zadanej
plot([0, t(length(t))], T_set_vec, 'Color', colors(9, :), 'LineWidth', 2.5);

%narysowanie rampy grzania
plot([0, t(length(t))], T_v_vec, 'Color', colors(10, :), 'LineWidth', 2.5);

legend(legends);
title('Wykres temperatur w zależności od czasu');
xlabel ('Czas t [min]');
ylabel('Wartość temp T [°C]');
grid('on');
xlim ([0, t(1, length(t))]);
ylim ([0, T_set + 10]);
hold off;


%zapisanie temperatur maksymalnych do pliku .txt
if strcmp(data, 'dane_otwarte_okno.txt')
    save('max_temps_otwarte_okno.mat', 'max_temps');
end
if strcmp(data, 'dane_zamkniete_okno.txt')
    save('max_temps_otwarte_okno.mat', 'max_temps');
end
