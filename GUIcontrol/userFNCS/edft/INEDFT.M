function Y=inedft(F,fn,tn)

%INEDFT Inverse Nonuniform Extended Discrete Fourier Transform.
%
%	Y=inedft(F,fn,tn) is the inverse discrete Fourier transform of vector 
%	F estimated by NEDFT function at arbitrary frequency set fn:
%		F(fn) -> Y(tn),
%	where time moments tn for reconstructed sequence Y can be uniformly or
%	nonuniformly spaced in time. In the special case of uniform vectors fn and
%	tn, the INEDFT function can be replaced by well known MATLAB function IFFT.   
%
%	If input arguments are matrixes, the INEDFT operation is applied to each column.
%
% See also IFFT, EDFT, NEDFT.
%
% E-mail: 	Vilnislp@gmail.com

% Checking number of mandatory input arguments.
if nargin<3,error('Not enough input arguments. See help inedft.'),end

% Checking input arguments F,fn,tn for NaN and Inf.
if sum(~all(finite(F)))|sum(~all(finite(fn)))|sum(~all(finite(tn))),
    error('Input arguments F,fn,tn contain Inf or NaN. See help inedft.')
end

% Checking size of input arguments.
if size(F,1)==1,
    trf=1;
    F=F.';
    tn=tn.';
    else
    trf=0;
    fn=fn.';
end 
[N L]=size(F);
if size(fn,2)~=N,
    error('Sizes of input arguments F and fn must be equal. See help inedft.')
end
if size(tn,2)~=L,
    error('Incorrect size of input argument tn. See help inedft.')
end

% Performing frequency -> time transform F(fn) -> Y(tn).

for l=1:L
    E=exp(i*2*pi*tn(:,l)*fn(l,:));
    Y(:,l)=E*F(:,l)/N;
end

% Adjust size of INEDFT output.
if trf==1,Y=Y.';end