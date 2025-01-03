clear all; close all;

%----------------------pobranie danych wejściowych---------------%
%zebranie danych z konsoli
data = input('Podaj nazwę pliku: ', 's');
T_set = input('Podaj temperaturę zadaną w °C: ');
T_v = input('Podaj prędkość grzania w °C/h: ');
sensors = input('Podaj ilość czujników: ');

%wczytanie danych
cd ..;
cd 'data';
dane = load (data);

%---------------------dane potrzebne do obliczeń----------------%
%parametry rezystancji stałych
R = [4.710, 4.655, 4.692, 4.682, 4.652, 4.620, 4.687, 4.728];
R = R * 10^3;           %[Ohm]       
R_T_norm = 10 * 10^3;   %[Ohm]

%parametry termistora
b = 3950;       %[K]
T0 = 298.15;    %[K]

%parametry uC
digit = 1023;
Vcc = 5;                %[V]
prescaller = Vcc/digit; %[V]

%wektor czasu
t = [0 : 1 : length(dane(:, 1))-1]/120;

%temperatura zadana i prędkość grzania
T_set_vec = [1, 1] * T_set;
T_v_vec = [0, t(length(t))/60] * T_v;

%macierz temperatur 
T_all = [];

%wektor temperatur do heatmapy
T_heatmap = [];

%-----------------rzeczy potrzebne do wykresu--------------------%
%podpisy czujników i wartości zadanych
legends = {'1LGR', '2SG', '3PGR', '4LS', '5PS', '6LDR', '7SD', '8PDR', 'Temp. zadana', 'Prędkość grzania'};

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


%------------obliczanie temperatur i rysowanie wykresów----------%
for i = 1 : sensors

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
    
    %dodanie temperatury do macierzy przechowywującej temp wszystkich
    %czujników
    T_all = [T_all, T];

    %wizualizacja wyników
    hold on;
    plot(t, T, 'Color', colors(i, :), 'LineWidth', 2);
end 

%narysowanie temperatury zadanej
plot([0, t(length(t))], T_set_vec, 'Color', colors(9, :), 'LineWidth', 2.5);

%narysowanie rampy grzania
plot([0, t(length(t))], T_v_vec, 'Color', colors(10, :), 'LineWidth', 2.5);

%opisanie wykresu
legend(legends);
title('Wykres temperatur w zależności od czasu');
xlabel ('Czas t [min]');
ylabel('Wartość temp T [°C]');
grid('on');
xlim ([0, t(1, length(t))]);
ylim ([0, T_set + 10]);
hold off;


%-----------------pobranie danych do heatmapy--------------------%
disp('Podaj moment czasu w której pobrać temperatury do heatmapy');
[x, y] = ginput(1);
t_heatmap = round(x * 120);

for i = 1 : 8
    T_heatmap(i) = T_all(t_heatmap, i);
end

%-------------------------zapis danych---------------------------%
if strcmp(data, 'dane_otwarte_okno.txt')
    save('heatmap_temps_otwarte_okno.mat', 'T_heatmap');
    save('all_temps_otwarte_okno.mat', 'T_all');
end
if strcmp(data, 'dane_zamkniete_okno.txt')
    save('heatmap_temps_zamkniete_okno.mat', 'T_heatmap');
    save('all_temps_zamkniete_okno.mat', 'T_all')
end
