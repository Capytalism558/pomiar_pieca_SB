clear all; close all;

%zebranie danych z konsoli
data = input('Podaj nazwę pliku: ', 's');

%załadowanie danych
dane = load (data);
dane = dane.max_temps;

%podpisy czujników
legends = {'1', '2', '3', '4', '5', '6', '7', '8'};

%współrzędne termistorów [cm]
X = [15, 40, 65, 22, 58, 15, 40, 65];
Y = [48, 48, 48, 30, 30, 12, 12, 12];

%wartości temperatur
Z = dane;

% Siatka do interpolacji
[xq, yq] = meshgrid(linspace(0, 80, 1000), linspace(0, 60, 1000));
Xq = [xq(:), yq(:)];

% Interpolacja temperatur
F = scatteredInterpolant(X', Y', Z', 'natural', 'linear');
Zq = F(xq, yq);

% Wykres mapy ciepła
figure;
hold on;
contourf(xq, yq, Zq, 1000, 'LineColor', 'none'); 
scatter(X, Y, 'filled');

% Dodanie napisu przy każdym punkcie
for i = 1:length(X)
    label = ['[', legends{i}, ']', ' ', num2str(Z(i), '%.2f')];
    text(X(i) + 1, Y(i) + 0.2, label);
end

hold off;
c = colorbar;
ylabel(c, 'Temperatura [°C]');
xlabel('X [cm]');
ylabel('Y [cm]');
title('Heatmapa pieca (interpolacja naturalna i ekstrapolacja liniowa)');

