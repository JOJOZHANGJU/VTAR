%08/06/05, Avinash Yentrapati
%synthesizes sound; uses rosenberg type B model of glottal waveform 

function[]=playsound

%AR = demo('oraltractaa.mat', 'nasaltract1.mat', 'aa', [], 0, 0 , 0 , 1, 3, 1, 1, 1, 1,4000, 5);
%AR= demo('oraltractaa.mat', 'aa', 4000, 5);
%AR = AR';
global VT;
AR = VT.AR_sync; %(1:end-1); 
AR = AR';
AR = [0 AR(2:end-1)];
%Z = [0 Z(2:end-1)];
%sfigure
%plot(20*log10(abs(AR)));
AR = [AR fliplr(conj(AR))];
ARinv = ifft(AR);
ARinvreal = real(ARinv);
%figure;
%plot(ARinvreal);
%pause;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialization of glottal paramters
VT.glottalpulse.Tperiod = 0.010; %time period of the glottal pulse Units: ms
VT.glottalpulse.changePN = 0.07; %percentage variation of open/close  Units: percent
VT.glottalpulse.changeT = 0.007; %percentage variation of time period  Units: percent
VT.glottalpulse.openP = 0.4; %open quotient %Units: percent
VT.glottalpulse.openN = 0.2; %close quotient %Units: percent
VT.glottalpulse.delT  = 0.000125; %3.5714e-006; %spacing in time Units: ms
VT.glottalpulse.shimmerdB= 0.5; %shimmer Units: dB
T = VT.glottalpulse.Tperiod; %time period
changePN = VT.glottalpulse.changePN;
changeT = VT.glottalpulse.changeT;
openP =VT.glottalpulse.openP;  %rise time
openN = VT.glottalpulse.openN;  %fall time
delT= VT.glottalpulse.delT;
shimmerdB = 0 ;% VT.glottalpulse.shimmerdB;  %dB
delT = delT/35;  %for downsampling purpose;

G = [];

for i=1:50,
    T=T-changeT*T +   ( 2*T*changeT)*rand(1,1); %generates random T in the interval [0.009 0.011];
    Tp = T*openP + (T*openP*changePN)*rand(1,1);
    Tn = T*openN + (T*openN*changePN)*rand(1,1);
    %Tp = 0.004;
    %Tp = 0.004 + (0.005 - 0.004)*rand(1,1);
   % Tn = 0.001;
    %Tn = 0.0003 + (0.004 - 0.003)*rand(1,1);
     %delT = 0.000125;
   
    t1 = 0: delT : Tp;
    rise = 3*(t1./Tp).^2 - 2*(t1./Tp).^3;
    t2 = Tp : delT : Tp+Tn;
    fall = 1- ((t2-Tp)./Tn).^2;
    
    %amplitude of area is 0.1, shimmer 0.5 dB
    shimmermax = .1/(10^(shimmerdB/20));       %conversion from decibel
    shimmermin =.1/(10^(-shimmerdB/20));
    shimmer = shimmermin + (shimmermax - shimmermin)*rand(1,1);
    rise = rise*shimmer;
    fall = fall*shimmer;
%    close = zeros(1, (T -(Tp+Tn))/delT);
    close = zeros(1, round((T -(Tp+Tn))/delT));

    %G = zeros(1, T/delT);
    %G(1:(Tp/delT+1)) = rise;
    %G((Tp/delT+2):((Tn+Tp)/delT+2)) = fall;
    %G = G - 0.05;
    %Gp = repmat(G, 1, 100);
    G = [G rise fall close];
end
    Gp =G;
%     Xinhui added , 04/23/2006, 2:00PM
Gp = diff(Gp) ; 
wavwrite(Gp, 8000*35, 16, 'Ug.wav');

 %   Gp = downsample(Gp, 35);
%    Gp = decimate(Gp, 35);
   % plot(Gp);
    Gp = decimate(Gp, 5);
    Gp = decimate(Gp, 7);
    
P = conv(Gp , ARinvreal);
%figure;
%plot(P);
%normalized P
% pause;
%figure;
P = P/(max(abs(P))*1.1);
%plot(P);
%pause;
%P = (ones(2,1)*P)';

% wavplay(P, 8000);
% wavwrite(P, 8000, 16, 'Uo.wav');

wavplay(P, 12000);
wavwrite(P, 12000, 16, 'Uo12.wav');

figure; plot(Gp) ;
figure; plot(P) ;

%a= auread('ah.au');
%plot(a);


%myfft=fft(P);
%asyfft=fft(a);
%plot(20*log10(abs(myfft(1:end/2))));

%figure;
%plot(20*log10(abs(asyfft(1:end/2))));





%rand('state',sum(100*clock))