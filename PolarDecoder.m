function dec = PolarDecoder(n, LEN, K, N, SNR, Y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulate polar decoding of bits in MIMO systems.
%
% Inputs:
%   n - number of antennas.
%   LEN - number of symbols to transmit
%   K - number of bits per symbol per antenna
%   R - polar coding rate
%       e.g. K=16, R=.5 -> 32 bits output of polar codes
%   Y - modulated data to decode
%
%   Output - MIMO signal after QAM detection linearly
%
%   Example: PolarDecoder(4,20,16,.5,Y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data = reshape(Y, n, LEN, N);

dec = zeros(n, LEN, K);

for (kk = 1 : LEN)
    for (i = 1 : n)
        dec(i,kk,:) = pdecode(data(i,kk,:), 'AWGN', SNR);
    end

end

end

