LEN = 20; % how many K-bit length messages we will send (per tx/rx)
SNR = 0;
n = 2; % number of tx and rx antennas
K = 16; % bits per msg
R = .5; % polar rate
N = (2^nextpow2(K))/R; % bits per coded symbol
qamBitSize = 2;
qamSize = 2^qamBitSize;
normAnt = 0;
normConst = 0;
precode = 0;

addpath('./samples/polar');
addpath('./samples/polar/functions');


initPC(N,K,'AWGN',SNR);
%SNR: Default: 0dB;  := Eb/N0,  where (K*Eb/N) is the energy used during BPSK modulation of coded-bits)

% Create constallation table
qamTab = ConstellationTable(qamSize, normConst);

% Channel matrix - Gaussian
H = randn(n).*exp(-1i*2*pi*rand(n,n));

% Can do precoding with full or statistical channel information for point-to-point MIMO systems
% For now, assume TX has perfect initial channel knowledge
% Can reach channel capacity with perfect channel knowledge and SVD precoding
% We aren't actually precoding right now though
H_known = H;

% Create MIMO data
X = PolarMIMOGenerator(n, LEN, N, K, R, qamBitSize, qamTab, precode, H_known);

% Receive antenna noise - AWGN
noiseVal = 10^(-SNR/10);
noiseVec = sqrt(noiseVal)*randn(n,1);
        
% Apply channel
Y = H*X + noiseVec;

Hest = ChannelEstimate(rxPilots, txPilots);

% MIMO Detect
Yhat = LinearMIMODecoder(n, Y, qamSize, qamTab, normAnt, normConst, Hest);

% Polar Decode
Xhat = PolarDecoder(n, LEN, K, SNR, Yhat)

% Compare
figure(1)
plot(X)
plot(Xhat)
