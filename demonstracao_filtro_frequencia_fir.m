%% FILTRO DE FREQU√äNCIA

%% CURVA PARA TESTE
clear all
clc

N=100; % fs
L=1*N; % qtde de pontos
data=zeros(L,2);
w=1:1:L;
data(:,1)=w*1/N;
data(:,2)=1*sin(1*2*pi*w/N)+1*sin(2*2*pi*w/N)+1*sin(3*2*pi*w/N)+1*sin(4*2*pi*w/N)+1*sin(5*2*pi*w/N)+1*sin(6*2*pi*w/N)+1*sin(7*2*pi*w/N)+1*sin(8*2*pi*w/N)+1*sin(9*2*pi*w/N)+1*sin(10*2*pi*w/N)+1*sin(11*2*pi*w/N)+1*sin(12*2*pi*w/N)  +   1*cos(1.5*2*pi*w/N)+1*cos(2.5*2*pi*w/N)+1*cos(3.5*2*pi*w/N)+1*cos(4.5*2*pi*w/N)+1*cos(17*2*pi*w/N)+1*cos(18*2*pi*w/N)+1*cos(19*2*pi*w/N)+1*cos(20*2*pi*w/N)+1*sin(9*2*pi*w/N)+1*sin(10*2*pi*w/N)+1*sin(11*2*pi*w/N)+1*sin(12*2*pi*w/N);
X=data(:,2);
X1=data(:,1);

fs = N;

%% FIM DO TESTE
for r = 0.1:0.1:25 % "s" quando for variar M e "r" quando for variar fc
    pause(0.01)
% r = 6; % frequÍncia de corte em Hz
fc1 = r; % frequÍncia de corte em Hz
fc = fc1/fs; % frequÍncia de corte como porcentagem da frequÍncia de amostragem
s = 1;
M = s*fs; % quantidade de pontos do filtro kernel (tem que ser par, pois o filtro vai de 0 a M)
BW = 4/M; % largura da banda de transiÁ„o como porcentagem da frequÍncia de amostragem
bw = BW*fs; % largura da banda de transiÁ„o em Hz
% bw = 5; % largura da banda de transiÁ„o em Hz
% BW = bw/fs; % largura da banda de transiÁ„o como porcentagem da frequÍncia de amostragem
% M = 4/BW; % quantidade de pontos do filtro kernel (tem que ser par, pois o filtro vai de 0 a M)

hk = 0;
for i = 0:M % criando a funÁ„o kernel
	blackman(i+1) = 0.42-0.5*cos(2*pi*i/M)+0.08*cos(4*pi*i/M);
    if i == M/2
		h(i+1) = 2*pi*fc*blackman(i+1); % no livro diz que deveria ser sÛ 2*pi*fc (o *K È feito fora do "for")
	else
		h(i+1) = ((sin(2*pi*fc*(i-0.5*M)))/(i-0.5*M))*blackman(i+1);
	end
	hk = hk+h(i+1); % soma para normalizar depois com valor de k
end

K = 1/hk; % calculando k, j· que a soma de todos os pontos tem que ser 1

H = K*h; % finalmente, o filtro kernel
H1 = H;
H = [zeros(1,length(X)) H]'; % vetor coluna

Xx = [X;zeros(length(H)-length(X)-1,1)]'; % vetor linha

% aqui È feita a convoluÁ„o
for k = 1:length(Xx)% +length(H)-1 % k È um instante de tempo do sinal filtrado
    Y(k) = Xx(1:k)*H(1+length(H)-k:length(H)); % (length(H)-n) È o Ìndice de tr·s pra frente
end
Y = Y(0.5*M+1:length(Y)-0.5*M); % eliminando os M pontos a mais do sinal filtrado em relaÁ„o ao sinal original


%% FAZENDO A FFT PARA CONFERIR

%% sinal original

L = length(X);            % Length of signal
Fs = L/max(X1(:,1));      % Sampling frequency
T = 1/Fs;                 % Sampling period
t = X1(:,1);              % Time vector

Yy = fft(X);

P2 = abs(Yy/L);
P1 = P2(1:L/2+1); % criou P1 como sendo P2 indo de 1 at√© metade mais 1 do tamanho do sinal
P1(2:end-1) = 2*P1(2:end-1); % √† exce√ß√£o do 1o e √∫ltimo termos, P1 foi definido como o dobro de P2

f = Fs*(0:floor(L/2))/L; % limita a frequ√™ncia √† metade da frequ√™ncia de amostragem

% plotando sinal em frequ√™ncia
% figure(1)
% subplot(3,1,1)
% plot(f,P1) % semilogx(f,P1)
% title('Frequency Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('Amplitude')
% axis([0 21 0 1.1*max(P1)])
% grid on

%% sinal filtrado

L = length(Y);            % Length of signal
Fs = L/max(X1(:,1));      % Sampling frequency
T = 1/Fs;                 % Sampling period
t = X1(:,1);              % Time vector

Yy = fft(Y);

P2 = abs(Yy/L);
P1 = P2(1:L/2+1); % criou P1 como sendo P2 indo de 1 at√© metade mais 1 do tamanho do sinal
P1(2:end-1) = 2*P1(2:end-1); % √† exce√ß√£o do 1o e √∫ltimo termos, P1 foi definido como o dobro de P2

f = Fs*(0:floor(L/2))/L; % limita a frequ√™ncia √† metade da frequ√™ncia de amostragem

% plotando sinal em frequ√™ncia
% figure(1)
% subplot(3,1,2)
% plot(f,P1) % semilogx(f,P1)
% title('Frequency Spectrum of Y(t)')
% xlabel('f (Hz)')
% ylabel('Amplitude')
% axis([0 21 0 1.1*max(P1)])
% grid on


%% Filtro kernel

for m = 0:length(H)-1
    HH(m+1) = H(length(H)-m); % HH È o H de tr·s pra frente => sinc primeiro e zeros depois
end

L = length(HH);            % Length of signal

Yy = fft(HH);

P2 = abs(Yy/L);
P1 = P2(1:L/2+1); % criou P1 como sendo P2 indo de 1 at√© metade mais 1 do tamanho do sinal
P1(2:end-1) = 2*P1(2:end-1); % √† exce√ß√£o do 1o e √∫ltimo termos, P1 foi definido como o dobro de P2

f = floor((0.5*fs)-1)/length(P1):floor((0.5*fs)-1)/length(P1):floor(0.5*fs)-1;

% plotando o filtro em frequÍncia e no tempo
figure(2)
subplot(2,2,1)
plot(f,P1,'color','r') 
title('Resposta em frequÍncia do filtro kernel')
xlabel('f (Hz)')
ylabel('Amplitude')
axis([0 max(f) 0 1.1*max(P1)]) % quando varia fc
% axis([0 max(f) 0 0.005]) % quando varia M
grid on

% figure(2)
subplot(2,2,2)
plot(0:M,H1,'color','r') 
title('Filtro kernel no domÌnio do tempo')
xlabel('Amostras')
ylabel('Amplitude')
axis([0 M -0.2 0.55]) % quando varia fc
% axis([0 10*fs 1.1*min(H1) 1.1*max(H1)]) % quando varia M
grid on

%%

% plotando sinais no tempo em gr·ficos diferentes
% figure(3)
% subplot(2,1,1)
% plot(X)
% title('Original')
% % axis([0 2200 min(X) max(X)])
% subplot(2,1,2)
% plot(Y,'color','r')
% title('Filtrado')
% % axis([0 2200 min(Y) max(Y)])

% plotando sinais no tempo no mesmo gr·fico e junto com o plot do filtro
figure(2)
subplot(2,2,3)
plot(X)
title('Sinal no tempo com passa-baixa')
axis([0 length(X) 1.2*min(X) 1.3*max(X)])
hold on
plot(Y,'color','r')
hold off

%% Tentando obter o sinal passa-alta

Z = X'-Y;

% verificando a FFT
L = length(Z);            % Length of signal

Yy = fft(Z);

P2 = abs(Yy/L);
P1 = P2(1:L/2+1); % criou P1 como sendo P2 indo de 1 at√© metade mais 1 do tamanho do sinal
P1(2:end-1) = 2*P1(2:end-1); % √† exce√ß√£o do 1o e √∫ltimo termos, P1 foi definido como o dobro de P2

f = floor((0.5*fs)-1)/length(P1):floor((0.5*fs)-1)/length(P1):floor(0.5*fs)-1;

% plotando a FFT junto com as outras FFT's
% figure(1)
% subplot(3,1,3)
% plot(f,P1) % semilogx(f,P1)
% title('Frequency Spectrum of Z(t)')
% xlabel('f (Hz)')
% ylabel('Amplitude')
% axis([0 21 0 1.1*max(P1)])
% grid on

figure(2)
subplot(2,2,4)
plot(X)
title('Sinal no tempo com passa-alta')
axis([0 length(X) 1.2*min(X) 1.3*max(X)])
hold on
plot(Z,'color','r')
hold off

end
xlabel('FIM')
