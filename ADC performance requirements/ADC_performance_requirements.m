%% ADC performance requirements
%
% Consider, for example, a reciever like GSM standard, which has narrowband 
% 200 kHz bandwidth with 14 bit 65 MSPS ADC, such as the AD6644. This ADC 
% has a 2.2 volt peak to peak input range, typical SNR of 74.5 dB, 14 bit.
% Let's calculate sensitivity of the reciever


% Boltzmann’s constant
k = 1.38 * 10^(-23);    % J/K 
% temperature
T = 300;    % K
% bandwidth
BW = 200*10^3; %Hz
% Noise Fugure of reciever
NF_rec = 5;  % dB 
% Gain of reciever
Gain_rec = 25;   % dB
% datasheet SNR of ADC
SNR_typ = 74.5;    % dB
% peak to peak input range of ADC
AMP = 2.2;
% ADC samplerate
Fs = 65*10^6;   % SPS
% ADC bit error
BER = 5;    % dB
%% Antenna part
% Fundamental noise floor of the reciever

% Available noise power from the antenna
P_a = k*T*BW;   % watts
% Fundamental noise floor of the reciever
N_floor_rec = 10*log10(P_a/10^(-3));    % dBm/Hz 
%%
% Noise before ADC

% Noise at input of ADC
ADC_input_noise = N_floor_rec + NF_rec + Gain_rec;  % dBm
%% ADC part
% root Mean Square full-scale value
rms_full = AMP/(2*sqrt(2)); % volts 
% all noises within the ADC, thermal and quantization (volts^2).
V_noise_v = (rms_full*10^(-SNR_typ/20))^2; % volts^2
% converting volts to dBm (assuming 200 ohm input impedance into the ADC)
V_noise_dBm = 10*log10(V_noise_v/200/0.001);    % dBm
SNR_effective = V_noise_dBm; 
% the process gain due to oversampling for these conditions is given by
% it is increased after appropriate digital filtering. 
Process_gain = 10*log10(Fs/(2*BW));   % dB
% processing gain of a 200 kHz channel improves the effective SNR to –91.8 
% dBm for the ADC
SNR_proc_gain = SNR_effective - Process_gain;   % dB
%% Overall system noise
Syst_noise = 0.001*10^(ADC_input_noise/10) + 0.001*10^(SNR_proc_gain/10);   
% watts
%% Sensetivity of system
ADC_full_scale = 10*log10(rms_full^2/200) + 30   % dBm 
% full scale input power
ADC_power_full = 0.001*10^(ADC_full_scale/10);  % watts 
% maximum SNR in a 200 kHz bandwidth (we take into account the receiver 
% noise and normalized noise power in 200 kHz bandwidth of ADC )
SNR_max = -10*log10(ADC_power_full/Syst_noise);   % dB
Sen = SNR_max + BER + Signal_power - Gain_rec;   % dBm
% noise figure of ADC
NF_ADC = -N_floor_rec + SNR_effective - Process_gain;   % dB






