adc40 = importdata("calibration_1.txt");
adc60 = importdata("calibration_2.txt");
adc80 = importdata("calibration_3.txt");
adc100 = importdata("calibration_4.txt");
adc120 = importdata("calibration_5.txt");
adc140 = importdata("calibration_6.txt");
adcbefore = importdata("data_before.txt");
adcafter = importdata("data_after.txt");

torr40=ones(length(adc40), 1) * 40;
torr60=ones(length(adc60), 1) * 60;
torr80=ones(length(adc80), 1) * 80;
torr100=ones(length(adc100), 1) * 100;
torr120=ones(length(adc120), 1) * 120;
torr140=ones(length(adc140), 1) * 140;

cadc = [adc40 adc60 adc80 adc100 adc120 adc140];
ctorr = [torr40 torr60 torr80 torr100 torr120 torr140];

c = polyfit(cadc, ctorr, 1);


cfigure = figure('Name','Калибровка', 'NumberTitle','off');
hold all;

plot(adc40, torr40, '.', 'MarkerSize', 20);
plot(adc60, torr60, '.', 'MarkerSize', 20);
plot(adc80, torr80, '.', 'MarkerSize', 20);
plot(adc100, torr100, '.', 'MarkerSize', 20);
plot(adc120, torr120, '.', 'MarkerSize', 20);
plot(adc140, torr140, '.', 'MarkerSize', 20);

plot(cadc, polyval(c, cadc));
y=c(1)*x+c(2);
x = [40:1:145];
plot(x,y);
grid on;
xlabel("Отсчёты АЦП");
ylabel("торр");
title("Калибровка измерительной системы");

text(60,50,["P(adc) = " + c(1) + "* adc+ " + num2str(c(2)) + " торр"]);
legend("40 тoрр", "60 торр", "80 торр", "100 торр", "120 торр", "140 торр", "Location", "NorthWest");
saveas(cfigure, "Калибровка.png");

dt = 0.01;

tbefore = linspace(0, length(adcbefore)*dt,length(adcbefore));
pbefore = polyval(c, adcbefore);

tafter = linspace(0, length(adcafter)*dt, length(adcafter));
pafter = polyval(c, adcafter);

pfigure = figure('Name', 'График давления', 'NumberTitle', 'off');

plot(tbefore, pbefore, tafter, pafter, 'Linewidth', 1);
legend("До физической нагрузки","После физической нагрузки");

grid on;
xlim([0,25]);

xlabel("Время, с");
ylabel("Давление, торр");
title("График измерения артериального давления");

saveas(pfigure, "Давление.png");

cbefore = polyfit(tbefore, pbefore, 7);
cafter = polyfit(tafter, pafter, 5);

pulseb = pbefore - polyval(cbefore, tbefore)';
pulsea = pafter - polyval(cafter, tafter)';

pulsefigure = figure("Name", "Графики пульса", "NumberTitle", "off");

subplot(2,1,1);
plot(tbefore,pulseb);
legend("11 ударов за 10 секунд = 66 уд/мин");
grid on;
xlim([10,20]);
title("Пульс без физической нагрузки");

subplot(2,1,2);
plot(tafter,pulsea,"yellow");
legend("30 ударов за 10 секунд = 180 уд/мин");
grid on;
xlim([10,20]);
title("Пульс после физической нагрузки");

saveas(pulsefigure, "Пульс.png");







