function [output, newLen, enc, enc_old] = ApplyPolarQAM(data, n, LEN, N, K, R, qamBitSize, qamTab, precode, H)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulate polar coding of bits in MIMO systems.
% Optionally can apply SVD precoding based on known channel matrix
%
% Inputs:
%   data - the generated MIMO messages
%   n - number of antennas.
%   LEN - number of symbols per antenna
%   N - number of bits after encoding per symbol
%   K - number of bits per symbol per antenna
%   R - polar coding rate
%       e.g. K=16, R=.5 -> 32 bits output of polar codes
%   qamBitSize - # of bits encoded into the QAM, e.g. 1 -> +/- 1 -> 2QAM/BPSK
%   qamTab - the table generated by ConstellationTable.m
%   precode - a binary flag for SVD precoding
%   H - the known channel, if available, used for precoding
%
% Outputs:
%   output - polarized modulated MIMO
%   newLen - number of symbols per antenna after polarizing and modulating
%   enc - polar encoded bits grouped into qamBitSize groups
%   enc_old - polar encoded bits grouped into N size groups
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create constallation table
qamTable = qamTab.table;

newLen = LEN*N/qamBitSize;

enc = zeros(n, LEN, N); %antennas, nMessages, polarized bits
output = zeros(n, newLen); %antennas, nCodedMessages

if (precode)
    [U,D,V] = svd(H);
end


for (kk = 1 : LEN)
    for (i = 1 : n)
        % polar encode each set of K bits at a time
        enc(i,kk,:) = pencode(data(i,kk,:));
    end

end

% reorder each chunk of N bits so that we have qamBitSize chunks instead
enc_old = enc;
enc = reshape(enc, n, newLen, qamBitSize);

for (k = 1:n)
    msg = reshape(enc(k,:,:), newLen, qamBitSize); % [1,newLen,qamBitSize] -> [newLen, qamBitSize]
    indices = bi2de(msg)+1; % convert to decimal index of table, +1 since matlab is 1 indexed
    output(k,:) = qamTable(indices); % use encoded bits on table to get moduated symbols
end

if (precode)
    output = V.*output;
end

end

