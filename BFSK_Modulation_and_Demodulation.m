%BFSK Modulation and Demodulation

%% Input Bits Generation
N=10; %Input Size
n=randi([0 1],1,N); % Random N bits generation : 1 or 0

%% Uni-Polar Mapping
for ii=1:N
    if n(ii)==1
        nn(ii)=1;
    else 
        nn(ii)=0;
    end
end

%% Uni-Polar NRZ signal
S=100; %Sampling frequency for MATLAB, basically it is the number of points for representation of 1 bit
       %Simply called "Samples per Bit"
i=1;
t=0:1/S:N;
for j=1:length(t)
    if t(j)<=i
        m(j)=nn(i);
    else
        m(j)=nn(i);%This line of code is written to maintain a continuum in the waveform
        i=i+1;
    end
end
figure(1);
subplot(411);
plot(t,m,'m'); xlabel('Time'); ylabel('Amplitude');
title('NRZ Uni-Polar Line coded Signal');

%% Carrier Signal Generation
c1=cos(2*pi*1*t);%Carrier 1
c2=cos(2*pi*2*t);%Carrier 2

subplot(412);
plot(t,c1,'k-'); xlabel('Time'); ylabel('Amplitude');
title('Carrier Signal-1');

subplot(413);
plot(t,c2,'k-'); xlabel('Time'); ylabel('Amplitude');
title('Carrier Signal-2');

%% BFSK Signal Generation
for i=i:length(t)
    if m(i)==1
        x(i)=c1(i);
    else
        x(i)=c2(i); 
    end
end

subplot(414);
plot(t,x,'k'); xlabel('Time'); ylabel('Amplitude');
title('BFSK Signal');

%% Coherent Detection
% We consider no noise case
y=x; %Received Signal=Transmitted Signal, since Coherent Detection %IDEAL CHANNEL.

y1=y.*c1; %Product Modulator-1
figure(2)
subplot(411);
plot(t,y1,'k'); xlabel('Time'); ylabel('Amplitude');
title('Product Modulator-1 Output');

y2=y.*c2; %Product Modulator-2
subplot(412);
plot(t,y2,'k'); xlabel('Time'); ylabel('Amplitude');
title('Product Modulator-2 Output');

%% Integrator

%Integrator Output 1
int_op1=[];
for ii=0:S:length(y1)-S %from 0 to the second last bit as integrating the second last goes on to the last bit
                        %trapz: Trapezoidal Numerical Integration
                        %division by S is done to find the average area
                        %between every 2 bits
    int_o1=(1/S)*trapz(y1(ii+1:ii+S));
    int_op1=[int_op1  int_o1];
end



%Integrator Output 2
int_op2=[];
for ii=0:S:length(y2)-S %from 0 to the second last bit as integrating the second last goes on to the last bit
                        %trapz: Trapezoidal Numerical Integration
                        %division by S is done to find the average area
                        %between every 2 bits
    int_o2=(1/S)*trapz(y2(ii+1:ii+S));
    int_op2=[int_op2  int_o2];
end

%% Decision Device
Th= 0; %Threshold for BASK
disp('Detected Bits:')
det=(round((int_op1-int_op2),1)>=Th) %round(input,number of significant places) and compare with the Threshold  

%% BER Computation
ber=sum(n~=det)/N %Count number of detected bits which are not equal to the original input 

% Clearly as there is no noise so the BER=0
