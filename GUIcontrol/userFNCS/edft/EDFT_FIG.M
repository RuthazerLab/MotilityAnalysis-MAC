% This program calculate and plot output of spectral estimation methods discussed in [4]:
%	- DFT,
%	- Extended DFT (EDFT),
%	- High-Resolution DFT (HRDFT) [2],
%	- Iterative algorithm based on the Capon filter approach.
% Each spectral estimate is tested on the three 64-point sequences: 
% x_uni - uniform complex-value test sequence used in [3];
% x_non - nonuniform complex-value test sequence used in [3];
% x_mak - Well-known Marple&Kay 64-point real sample sequence [1].
% The spectral plots are not intended to demonstrate relative performance of approaches, but only
% to point out features of each technique. 
%
% References: 
% [1] - S.M.Kay, S.L.Marple, "Spectrum analysis - a modern perspective", Proceedings IEEE 69 (1981).
% [2] - Mauricio D. Sacchi, Tadeusz J. Ulrych, and Colin J. Walker, "Interpolation and Extrapolation Using a 
%	High-Resolution Discrete Fourier Transform", IEEE TRANS. ON SIGNAL PROC., VOL.46, NO.1, JANUARY 1998.
% [3] - Vilnis Liepins, High-resolution spectral analysis by using basis function adaptation approach /in Latvian/,
%	Doctoral Thesis for Scientific Degree of Dr.Sc.Comp., University of Latvia, 1997. 
%	Abstract available on http://www.opengrey.eu/item/display/10068/330816
% [4] - Vilnis Liepins, "Extended Fourier analysis of signals" available online at 
%	http://www.mathworks.com/matlabcentral/fileexchange/11020-extended-dft
%
% E-mail:	vilnislp@gmail.com

	it=10;							% Number of iterations
	N=1000;							% Number of frequencies
	fn=[-ceil((N-1)/2):floor((N-1)/2)]/N;			% Uniform frequency set (sampling frequency- 1)
	K=64;							% Length of sequences	
        t_u=0:K-1;              				% Uniform time set (sampling period- 1)
	%rand('seed',150);					% Generate always the same input sequences
        t_n=t_u+rand(1,K)*0.8;  				% Nonuniform time set (mean sampling period- 1)
	Eu=exp(-i*2*pi*t_u.'*fn);				% Exponents matrix (Uniform time), dim (KxN)
	En=exp(-i*2*pi*t_n.'*fn);				% Exponents matrix (Nonuniform time), dim (KxN)
	PHT=2*pi*(rand-0.5);					% Random initial phase for the complex exponent

% Uniform 64-point complex-value sequence: x_uni

	x_s=exp(i*(2*pi*0.35*t_u+PHT));				% complex exponent at normalized frequency 0.35
	disp(['Uniform sequence: True frequency=0.35 Amplitude=1.0 Phase=',num2str(PHT)]);
	x_i=20*sin(pi*(t_u-K/2)*0.25)./(pi*(t_u-K/2)+eps).*exp(i*pi*0.25*(t_u-K/2));	% rectangular impulse
	x_i(K/2+1)=5;
	f_x=-1:1/512:-0.5;
	x_n=sum(0.5*exp(i*pi*(f_x'*t_u+2*rand(257,1)*ones(1,K))))/sqrt(16);		% band limited noise
	x_uni=x_s+x_i+x_n;					% uniform composite sequence
	xmax=6;
	lim=2^11;	
	x_uni=xmax*round(x_uni/xmax*(lim+0.5))./(lim+0.5); 	% simulate 12-bit analog-to-digital converter

% Nonuniform 64-point complex-value sequence: x_non

	x_ns=exp(i*(2*pi*0.35*t_n+PHT));			% complex exponent at normalized frequency 0.35
	disp(['Nonuniform sequence: True frequency=0.35 Amplitude=1.0 Phase=',num2str(PHT)]);
	x_ni=20*sin(pi*(t_n-K/2)*0.25)./(pi*(t_n-K/2)).*exp(i*pi*0.25*(t_n-K/2));	% rectangular pulse
	x_nn=sum(0.5*exp(i*pi*(f_x'*t_n+2*rand(257,1)*ones(1,K))))/sqrt(16);		% band limited noise
	x_non=x_ns+x_ni+x_nn;					% nonuniform composite sequence
	x_non=xmax*round(x_non/xmax*(lim+0.5))./(lim+0.5); 	% simulate 12-bit analog-to-digital converter 


% Marple&Kay 64-point data set x_mak /apmplified two times/ 

	x_mak=2*[1.291061 -2.086368 -1.691316 1.243138 1.641872 -0.008688 -1.659390 -1.111467 0.985908 1.991979 -0.046613...
	-1.649269 -1.040818 1.054665 1.855816 -0.951182 -1.476495 -0.212242 0.780202 1.416003 0.199282 -2.027026... 
	-0.483577 1.664913 0.614114 -0.791469 -1.195311 0.119801 0.807635 0.895236 -0.012734 -1.763842 0.309840...
	1.212892 -0.119905 -0.441686 -0.879733 0.306181 0.795431 0.189598 -0.342332 -0.328700 0.197881 0.071179...
	0.185931 -0.324595 -0.366092 0.368467 -0.191935 0.519116 0.008328 -0.425946 0.651478 -0.639978 -0.344389...
	0.814130 -0.385168 0.064218 -0.380008 -0.163008 1.180961 0.114206 -0.667626 -0.814997];

% Calculate DFTs and Power spectrums for plot

	disp('Calculating DFT output...');	
	dft_x_uni=fftshift(fft(x_uni,N))/K;
	NK=N-N/4-1;
	[Y,I]=max(abs(dft_x_uni(NK+1:N)));AM=abs(dft_x_uni(I+NK));PH=angle(dft_x_uni(I+NK));
	disp(['Uniform sequence: DFT estimated frequency=',num2str(fn(I+NK)),' Amplitude=',num2str(AM),' Phase=',num2str(PH)]);
	dft_x_non=x_non*En/K;
	[Y,I]=max(abs(dft_x_non(NK+1:N)));AM=abs(dft_x_non(I+NK));PH=angle(dft_x_non(I+NK));
	disp(['Nonuniform sequence: DFT estimated frequency=',num2str(fn(I+NK)),' Amplitude=',num2str(AM),' Phase=',num2str(PH)]);
	dft_x_mak=fftshift(fft(x_mak,N))/K;
        dft_f1=20*log10(abs(dft_x_uni));
        dft_f2=20*log10(abs(dft_x_non));
        dft_f3=20*log10(abs(dft_x_mak));

% Calculate EDFTs and Power spectrums for plot

	disp('Calculating EDFT output...');
	[F1,S1]=edft(x_uni,N,it);
	S1=fftshift(S1);
	[Y,I]=max(abs(S1(NK+1:N)));AM=abs(S1(I+NK));PH=angle(S1(I+NK));
	disp(['Uniform sequence: EDFT estimated frequency=',num2str(fn(I+NK)),' Amplitude=',num2str(AM),' Phase=',num2str(PH)]);
	[F2,S2]=nedft(x_non,t_n,fn,it);
	[Y,I]=max(abs(S2(NK+1:N)));AM=abs(S2(I+NK));PH=angle(S2(I+NK));
	disp(['Nonuniform sequence: EDFT estimated frequency=',num2str(fn(I+NK)),' Amplitude=',num2str(AM),' Phase=',num2str(PH)]);
	[F3,S3]=edft(x_mak,N,it);
	S3=fftshift(S3);
        edft_f1=20*log10(abs(S1));
        edft_f2=20*log10(abs(S2));
        edft_f3=20*log10(abs(S3));

% Figure 1: Plot True spectrums (red) and estimates by DFT (blue) and EDFT        
      
	figure(1)

        db_min=-80;				% axis min [db]
	db_max=10;				% axix max [db]

	% True spectrum for test sequences in Subplot 1 and 2
	d_max=20*log10(20/K);
        true_sp1=[-0.5 -0.25 0 0.25 0.35 -0.5 0; -0.5 -0.25 0 0.25 0.35 -0.25 0.25;];
	true_am1=[d_max d_max d_max d_max 0 d_max d_max; db_min db_min db_min db_min db_min d_max d_max];

	% True spectrum for test sequence in Subplot 3
        fr_true=[0.1 0.2 0.21; 0.1 0.2 0.21;];
        amp_true=[-20 0 0; db_min db_min db_min];
        col_n=15*log10(0.1*(sin(pi*(eps:0.001:1))).^2); % Colored noice as described in [1]

	subplot(311)
	line(true_sp1,true_am1,'linestyle','-','color','r')
        axis([-0.5 0.5 db_min db_max])
        hold on
	plot(fn,dft_f1,'b-',fn,edft_f1)		% Plot DFT and EDFT Power Spectrum
	hold off
	xlabel('Frequency')
	ylabel('Power [dB]')
	title('Uniform sequence: True [red], DFT [blue] and Extended DFT')

	subplot(312)
	line(true_sp1,true_am1,'linestyle','-','color','r')
        axis([-0.5 0.5 db_min db_max])
        hold on
	plot(fn,dft_f2,'b-',fn,edft_f2)		% Plot DFT and EDFT Power Spectrum
	hold off
	xlabel('Frequency')
	ylabel('Power [dB]')
	title('Nonuniform sequence: True [red], DFT [blue] and Extended DFT')

	subplot(313)
        line(fr_true,amp_true,'linestyle','-','color','r')
        axis([0 0.5 db_min db_max])
        hold on
        plot(0.2:0.0003:0.5,col_n,'-r')  
	plot(fn,dft_f3,'b-',fn,edft_f3)		% Plot DFT and EDFT Power Spectrum
	hold off
	xlabel('Frequency')
	ylabel('Power [dB]')
	title('Marple&Kay sequence: True [red], DFT [blue] and Extended DFT')

% Calculate High-Resolution DFTs and Power spectrums for plot

	disp('Calculating HRDFT output...');

	W=ones(1,N);				% Initial conditions for W
	for l=1:it
	fh1=edft(x_uni,N,1,W);
        W=fh1/N;				% Weight for the next HRDFT iteration
	end 
	fh1=fftshift(fh1/N);
	[Y,I]=max(abs(fh1(NK+1:N)));AM=abs(fh1(I+NK));PH=angle(fh1(I+NK));
	disp(['Uniform sequence: HRDFT estimate frequency=',num2str(fn(I+NK)),' Amplitude=',num2str(AM),' Phase=',num2str(PH)]);
	W=ones(1,N);				% Initial conditions for W
	for l=1:it
	fh2=nedft(x_non,t_n,fn,1,W);
        W=fh2/N;				% Weight for the next HRDFT iteration
	end 	
	fh2=fh2/N;
	[Y,I]=max(abs(fh2(NK+1:N)));AM=abs(fh2(I+NK));PH=angle(fh2(I+NK));
	disp(['Nonuniform sequence: HRDFT estimated frequency=',num2str(fn(I+NK)),' Amplitude=',num2str(AM),' Phase=',num2str(PH)]);
	W=ones(1,N);				% Initial conditions for W
	for l=1:it
	fh3=edft(x_mak,N,1,W);
        W=fh3/N;				% Weight for the next HRDFT iteration
	end 
	fh3=fftshift(fh3/N);
        hrf_f1=20*log10(abs(fh1)+eps);
        hrf_f2=20*log10(abs(fh2)+eps);
        hrf_f3=20*log10(abs(fh3)+eps);

% Figure 2: Plot True spectrums (red) and estimates by DFT (blue) and HRDFT         

        figure(2)

        subplot(311)
	line(true_sp1,true_am1,'linestyle','-','color','r')
        axis([-0.5 0.5 db_min db_max])
        hold on
	plot(fn,dft_f1,'-b',fn,hrf_f1)			% Plot DFT and HRDFT Power Spectrums
	hold off
	xlabel('Frequency')
	ylabel('Power [dB]')
	title('Uniform sequence: True [red], DFT [blue] and High-Resolution DFT')

        subplot(312)
	line(true_sp1,true_am1,'linestyle','-','color','r')
        axis([-0.5 0.5 db_min db_max])
        hold on
	plot(fn,dft_f2,'b-',fn,hrf_f2)			% Plot DFT and HRDFT Power Spectrums
	hold off
	xlabel('Frequency')
	ylabel('Power [dB]')
	title('Nonuniform sequence: True [red], DFT [blue] and High-Resolution DFT')

        subplot(313)
        line(fr_true,amp_true,'linestyle','-','color','r')
        axis([0 0.5 db_min db_max])
        hold on
        plot(0.2:0.0003:0.5,col_n,'-r')  
	plot(fn,dft_f3,'b-',fn,hrf_f3)			% Plot DFT and HRDFT Power Spectrums
	hold off
	xlabel('Frequency')
	ylabel('Power [dB]')
	title('Marple&Kay sequence: True [red], DFT [blue] and High-Resolution DFT')

% Calculate Capon filter output and Power spectrums for plot
	disp('Calculating Capon filter output...');

	x_ur=(flipud(x_uni.')).';			% Re-ordering uniform input sequence for Capon filter input
	W=ones(1,N);					% Initial conditions for iterative algorithm 
	for l=1:it
	r=ifft(fftshift(W));				% Calculate autocorrelation function by applying ifft
	R=toeplitz(r(1:K)).';				% Compose and transpose the autocorrelation matrix
	ER=inv(R)*conj(Eu);
	sc1=(x_ur*ER)./sum(Eu.*ER);			% Calculate amplitude spectrum for iteration (it) 
	W=sc1.*conj(sc1);		 		% Weight for the next iteration  
	end
	[Y,I]=max(abs(sc1(NK+1:N)));AM=abs(sc1(I+NK));PH=angle(sc1(I+NK));
	disp(['Uniform sequence: Capon filter estimated frequency=',num2str(fn(I+NK)),' Amplitude=',num2str(AM),' Phase=',num2str(PH)]);

	x_nr=(flipud(x_non.')).';			% Re-odering nonuniform input sequence for Capon filter input
	t_nr=K-1-(flipud(t_n.')).';			% Calculate time vector for re-ordering nonuniform sequence
	Enr=exp(-i*2*pi*t_nr.'*fn);			% Calculate exponents matrix with nonuniform re-ordeting time, dim (KxN)	
	W=eye(N);					% Initial conditions for iterative algorithm 
	for l=1:it
	R=conj(Enr)*W*Enr.';				% Calculate autocorrelation matrix
	ER=inv(R)*conj(Enr);
	sc2=(x_nr*ER)./sum(Enr.*ER);	 		% Calculate amplitude spectrum for iteration (it) 
	W=diag(sc2.*conj(sc2));				% Weight for the next iteration
	end
	[Y,I]=max(abs(sc2(NK+1:N)));AM=abs(sc2(I+NK));PH=angle(sc2(I+NK));
	disp(['Nonuniform sequence: Capon filter estimate frequency=',num2str(fn(I+NK)),' Amplitude=',num2str(AM),' Phase=',num2str(PH)]);

	x_mr=(flipud(x_mak.')).';			% Re-ordering Marple&Kay sequence for Capon filter input
	W=ones(1,N);					% Initial conditions for iterative algorithm
	for l=1:it
	r=ifft(fftshift(W));				% Calculate autocorrelation function by applying ifft
	R=toeplitz(r(1:K)).';				% Compose and transpose the autocorrelation matrix
	ER=inv(R)*conj(Eu);
	sc3=(x_mr*ER)./sum(Eu.*ER);			% Calculate amplitude spectrum for iteration (it) 
	W=sc3.*conj(sc3);		 		% Weight for the next iteration 
	end
        cap_f1=20*log10(abs(sc1));
        cap_f2=20*log10(abs(sc2));
        cap_f3=20*log10(abs(sc3));
	
% Figure 3: Plot True spectrums (red) and estimates by DFT (blue) and Capon filter approach        

        figure(3)

        subplot(311)
	line(true_sp1,true_am1,'linestyle','-','color','r')
        axis([-0.5 0.5 db_min db_max])
        hold on
	plot(fn,dft_f1,'-b',fn,cap_f1)			% Plot DFT and Capon filter Power Spectrums
	hold off
	xlabel('Frequency')
	ylabel('Power [dB]')
	title('Uniform sequence: True [red], DFT [blue] and Capon filter output')

        subplot(312)
	line(true_sp1,true_am1,'linestyle','-','color','r')
        axis([-0.5 0.5 db_min db_max])
        hold on
	plot(fn,dft_f2,'b-',fn,cap_f2)			% Plot DFT and Capon filter Power Spectrums
	hold off
	xlabel('Frequency')
	ylabel('Power [dB]')
	title('Nonuniform sequence: True [red], DFT [blue] and Capon filter output')

        subplot(313)
        line(fr_true,amp_true,'linestyle','-','color','r')
        axis([0 0.5 db_min db_max])
        hold on
        plot(0.2:0.0003:0.5,col_n,'-r')  
	plot(fn,dft_f3,'b-',fn,cap_f3)			% Plot DFT and Capon filter Power Spectrums
	hold off
	xlabel('Frequency')
	ylabel('Power [dB]')
	title('Marple&Kay sequence: True [red], DFT [blue] and Capon filter output')