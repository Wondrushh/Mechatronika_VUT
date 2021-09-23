clc, clear


%% funkcie
systemTF = tf([7 6 2],[1 5 2 8]); %system zapis1

systemZPK = zpk([-2 -3],[-1 -4],3/4); %system zapis2

%% casovy usek pocitania

t = 1:0.01:100; %od 1 po 100 sekund


%% odozvy

[Y, t] = impulse(systemTF,t); %odozva na impulz

[S, t] = step(systemTF,t); %odozva na skok

%% niquistovo kriterium

[re,im,wout] = nyquist(systemTF);
nyquist(systemTF); %nyquist kriterium

%% bode

bode(systemZPK,{0,1E10}); %vypocita odozvu na frekvencie v dB

%% poles

pole(systemZPK); %vypocita poly systemu

%% vypocet nul

zero(systemZPK) %vypocita nuly systemu

%% algebraicke pocitanie

%dva rozne systemy
systemTF1 = tf([2],[2 8]);
systemTF2 = tf([1],[1 2 8]);

zapserie = series(systemTF1,systemTF2); % seriove zapojenie
parserie = parallel(systemTF1,systemTF2); % paralelne zapojenie
feedserie = feedback(systemTF1,systemTF2) % spatna vazba

%% Regulator PID

r0 = 1;
gr_p = tf([r0],1); % urcenie proporcionalnej zlozky

ti = 1;
gr_i = tf([r0],[ti 0]); % urcenie integralnej zlozky

td = 3;
gr_d = tf([r0*td],[ti 0]); % urcenie derivacnej zlozky


gr_pid = gr_p + gr_i + gr_d; % pid regulator spolu (zapojeny paralelne)

%% priklad motor

% premenne ktore hladame
tk = 280;

% premenne
Ce = 2.8;
J = 0.1;
R = 0.5;
L = 5e-3;

% funkcia motoru
funkcia_motoru = tf([1],[L*(J/Ce) R*(J/Ce) Ce 0])

% najdem regulator ked po vyradeni r0 (propor.) ostane konst. kmitat

reg_p = tf([r0],1);
reg_tk = tf([tk],1);
reg_i = tf([r0],[ti 0]);
reg_d = tf([r0*td],[ti 0]);

% pouzijem len proporcionalny pre cely system (seriove zapojenie +
% feedback)
%
%u --->O---->[ M1 ]----+---> y
%      |               |
%      +-----[ M2 ]<---+
%   --> schema zapojenia testovania (M2 = 1, M1 = motor a regulator)

step(feedback(funkcia_motoru*reg_tk,1)); %testovac na skok

% skusanim tohto zapojenia a jeho odozvy hladame tk v reg_tk dovtedy kym
% system nekmita konstantne, potom mame final cislo v tomto pripade to
% funguje ked tk = 280, regulator tk je taky isty ako regulator proporcionalny ale vytvoril som novy lebo som v tom bol strateny

%% tvorba regulatoru podla tabulky v prezentacii

ik = 0.05; % na toto prideme pri stabilnom kmite s tk = 280 a 0.05 je perioda sinusovky

r0 = 0.6*tk; % v prezentacii a tabulke je oznacene ako R0k
ti = 0.5*ik; % v prezentacii a tabulke je oznacene ako Tk
td = 0.12*ik; % v prezentacii a tabulke je oznacene ako Tk

%hodnoty treba zmenit podla toho aky regulator chceme

% regulator PI
% funckie zadam znovu nech sa zrataju s hodnotami ktore su vyratane vyssie

reg_p = tf([r0],1);
reg_i = tf([r0],[ti 0]);
reg_d = tf([r0*td],[ti 0]);

% regulator PI

reg_pi = reg_i + reg_p;

%regulator PID

reg_pid = reg_d + reg_p + reg_i;

% odozva na skok sustavy motor a regulator

step(feedback(reg_pid*funkcia_motoru,1)); % regulator PID ale je nekvalitny, nasou ulohou je najst hodnoty aby to bolo gut
