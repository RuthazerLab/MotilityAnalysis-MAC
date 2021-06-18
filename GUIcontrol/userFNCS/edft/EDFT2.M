function F = EDFT2(X, mrows, ncols)

% EDFT2	Two-dimensional Extended Discrete Fourier Transform.
%	EDFT2(X) returns the two-dimensional Fourier transform of matrix X.
%	Before run EDFT2 unknown data (if any) inside of X should be replaced
%	by NaN (Not-a-Number).
%	If X is a vector, the result will have the same orientation.
%	EDFT2(X,MROWS,NCOLS) performing size MROWS-by-NCOLS Fourier transform 
%	without padding of matrix X with zeros.
%
% See also EDFT.
%	
% EDFT2 is created on basis of FFT2 (J.N. Little 12/18/1985) by Vilnis Liepins.

% No input.
if nargin==0,
    error('Not enough input arguments. See help edft2.')
end

[m, n] = size(X);
% Basic algorithm.
if (nargin == 1) & (m > 1) & (n > 1)
    F = edft(edft(X).').';
    return;
end

% Padding for vector input.

if nargin < 3 & nargin ~= 0, ncols = n; end
if nargin < 2 & nargin ~= 0, mrows = m; end
mpad = mrows; npad = ncols;
if m == 1 & mpad > m, X(2, 1) = 0; m = 2; end
if n == 1 & npad > n, X(1, 2) = 0; n = 2; end
if m == 1, mpad = npad; npad = 1; end   % For row vector.

% Transform.

F = edft(X, mpad);
if m > 1 & n > 1, F = edft(F.', npad).'; end