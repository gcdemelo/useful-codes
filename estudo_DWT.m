close all

fs = 128;

t = 1/fs:1/fs:5;
ff = 2*[1 3 6 12 24];
% ff = [3 0 0 25 60];
aa = [1 4 6 0.5 1];

f = ...
[
    ff(1)*ones(1,floor(0.2*length(t))) ... 
    ff(2)*ones(1,floor(0.2*length(t))) ...
    ff(3)*ones(1,floor(0.2*length(t))) ...
    ff(4)*ones(1,floor(0.2*length(t))) ...
    ff(5)*ones(1,floor(0.2*length(t)))
];

A = ...
[
    aa(1)*ones(1,floor(0.2*length(t))) ... 
    aa(2)*ones(1,floor(0.2*length(t))) ...
    aa(3)*ones(1,floor(0.2*length(t))) ...
    aa(4)*ones(1,floor(0.2*length(t))) ...
    aa(5)*ones(1,floor(0.2*length(t)))
];

B = 0;
% A = 1;
x = B + A.* sin(2*pi*f.*t);

%% fazendo as transformadas

[LoD,HiD] = wfilters('db4','d');


N = 5;
[C,L] = wavedec(x,N,LoD,HiD); %C = C.^2;


[cA1,cD1] = dwt(x,  LoD,HiD);
[cA2,cD2] = dwt(cA1,LoD,HiD);
[cA3,cD3] = dwt(cA2,LoD,HiD);
[cA4,cD4] = dwt(cA3,LoD,HiD);
[cA5,cD5] = dwt(cA4,LoD,HiD); %cD1 = cD1.^2; cD2 = cD2.^2; cD3 = cD3.^2; cD4 = cD4.^2; cD5 = cD5.^2; cA5 = cA5.^2;


y = abs(fft(x));

%% plotando as transformadas

figure(1)
subplot(6,1,1)
plot(cD1); grid on; title('32 - 64 Hz'); ylim([min(C) max(C)]); xlim([0 length(detcoef(C,L,1))]);   hold on; plot([0.2*length(cD1) 0.4*length(cD1) 0.6*length(cD1) 0.8*length(cD1)],[0 0 0 0],'o','color','r')
subplot(6,1,2)
plot(cD2); grid on; title('16 - 32 Hz'); ylim([min(C) max(C)]); xlim([0 length(detcoef(C,L,2))]);   hold on; plot([0.2*length(cD2) 0.4*length(cD2) 0.6*length(cD2) 0.8*length(cD2)],[0 0 0 0],'o','color','r')
subplot(6,1,3)
plot(cD3); grid on; title('8 - 16 Hz'); ylim([min(C) max(C)]); xlim([0 length(detcoef(C,L,3))]);   hold on; plot([0.2*length(cD3) 0.4*length(cD3) 0.6*length(cD3) 0.8*length(cD3)],[0 0 0 0],'o','color','r')
subplot(6,1,4)
plot(cD4); grid on; title('4 - 8 Hz'); ylim([min(C) max(C)]); xlim([0 length(detcoef(C,L,4))]);   hold on; plot([0.2*length(cD4) 0.4*length(cD4) 0.6*length(cD4) 0.8*length(cD4)],[0 0 0 0],'o','color','r')
subplot(6,1,5)
plot(cD5); grid on; title('2 - 4 Hz'); ylim([min(C) max(C)]); xlim([0 length(detcoef(C,L,5))]);   hold on; plot([0.2*length(cD5) 0.4*length(cD5) 0.6*length(cD5) 0.8*length(cD5)],[0 0 0 0],'o','color','r')
subplot(6,1,6)
plot(cA5); grid on; title('0 - 2 Hz'); ylim([min(C) max(C)]); xlim([0 L(1)]);   hold on; plot([0.2*length(cA5) 0.4*length(cA5) 0.6*length(cA5) 0.8*length(cA5)],[0 0 0 0],'o','color','r')

% figure(2)
% subplot(6,1,1)
% plot(detcoef(C,L,1)); grid on; title('32 - 64 Hz'); ylim([min(C) max(C)]); xlim([0 length(detcoef(C,L,1))])
% subplot(6,1,2)
% plot(detcoef(C,L,2)); grid on; title('16 - 32 Hz'); ylim([min(C) max(C)]); xlim([0 length(detcoef(C,L,2))])
% subplot(6,1,3)
% plot(detcoef(C,L,3)); grid on; title('8 - 16 Hz'); ylim([min(C) max(C)]); xlim([0 length(detcoef(C,L,3))])
% subplot(6,1,4)
% plot(detcoef(C,L,4)); grid on; title('4 - 8 Hz'); ylim([min(C) max(C)]); xlim([0 length(detcoef(C,L,4))])
% subplot(6,1,5)
% plot(detcoef(C,L,5)); grid on; title('2 - 4 Hz'); ylim([min(C) max(C)]); xlim([0 length(detcoef(C,L,5))])
% subplot(6,1,6)
% plot(C(1:L(1))); grid on; title('0 - 2 Hz'); ylim([min(C) max(C)]); xlim([0 L(1)])

figure(3)
titulo = ['Frequencias do sinal: ' num2str(ff(1)) ', ' num2str(ff(2)) ', ' num2str(ff(3)) ', ' num2str(ff(4)) ', ' num2str(ff(5))];
plot(t,x); grid on; title(titulo)

% figure(4)
% y = abs(fft(x)); y = y(1:(0.5*length(y)));
% freq = 0:64/(0.5*length(y)):64-64/(0.5*length(y));
% plot(freq,y(1:0.5*length(y))); grid on

