clear all; close all;

%zebranie danych z konsoli
data = input('Podaj nazwę pliku: ', 's');
sensors = input('Podaj ilość czujników: ');
n = input('Podaj stopien badanej inercji: ');

%załadowanie danych
cd ..;
cd 'data';
dane = load (data);
dane = dane.T_all;
cd ..;
cd 'src';

%obliczenie temperatury średniej do zbadania inercji pieca
T_average = mean(dane, 2);

%stworzenie wektora czasu
t = [0 : 1 : length(T_average)-1]/120;

%narysowanie wykresu temperatury średniej
plot(t, T_average, 'LineWidth', 2);
title('Wykres temperatury średniej w zależności od czasu');
xlabel ('Czas t [min]');
ylabel('Wartość temp T [°C]');
grid('on');
xlim ([0, t(1, length(t))]);
ylim ([0, max(T_average) + 10]);
hold off;

%pobranie wartości k, T, theta z wykresu
disp(['Pobierz punkty zgodne z punktami na rysunku w instrukcji w' ...
    'kolejności: k, T, theta'])
[x_gin, y_gin] = ginput(3);

k = y_gin(1);
theta = x_gin(3);
T = x_gin(2) - theta;

%obliczenie wartości optymalnych dla obiektu regulacji
[param, err] = fminsearch('identyfikacja_obiekt_inercyjny_n_rzedu',[k, T, theta, n]);

k = param(1);
T = param(2);
theta = param(3);
n = param (4);

%zbadanie odpowiedzi skokowej
num = [k];
den = 1;  % Start od (T*s + 1)^0 = 1
for i = 1:n
    den = conv(den, [T, 1]);  % Konwolucja dla (T*s + 1)
end
sys = tf(num, den, 'OutputDelay', theta);
response = step (sys, t);
response = response + min(T_average);

%porównanie wyników
figure;
plot(t, T_average)
hold on;
plot(t, response);
hold off;
legend('obiekt rzeczywisty', ['obiekt inercyjny'] + n + ['rzędu']);
title(['Wykres odpowiedzi skokowych badanych obiektów, err = '] + ['err']);
grid on;