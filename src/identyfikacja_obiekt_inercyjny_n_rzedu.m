function err = identyfikacja_obiekt_inercyjny_n_rzedu(X0)
    cd ..;
    cd 'data';
    dane = load ("all_temps_otwarte_okno.mat");
    dane = dane.T_all;

    T_average = mean(dane, 2);

    K = X0(1);
    T = X0(2);
    theta = X0(3);
    disp(theta)
    n = X0(4);

    %stworzenie wektora czasu
    t = [0 : 1 : length(T_average)-1]/120;
    
    num = [K];
    den = 1;  % Start od (T*s + 1)^0 = 1
    for i = 1:n
        den = conv(den, [T, 1]);  % Konwolucja dla (T*s + 1)
    end

    sys = tf(num, den, 'OutputDelay', theta);
    y_sim = step(sys, t);
    y_real = T_average;
    %---------------------------------------- ------%
    e = y_real - y_sim;
    err = sum(e.^2) / length(e);