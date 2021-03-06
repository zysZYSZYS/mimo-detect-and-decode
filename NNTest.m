TRAIN_SIZE = 1024;
TEST_SIZE = 1024;
INPUT_SIZE = 134;
OUTPUT_SIZE = 16;

training.Y = randi([0, 1], INPUT_SIZE, 1, 1, TRAIN_SIZE);
training.B = training.Y(1:OUTPUT_SIZE, :,:,:);
training.B = permute(training.B, [2,3,1,4]);

testing.Y = randi([0, 1], INPUT_SIZE, 1, 1, TEST_SIZE);
testing.B = testing.Y(1:OUTPUT_SIZE, :,:,:);
testing.B = permute(testing.B, [2,3,1,4]);

layers = [
    imageInputLayer([INPUT_SIZE 1 1])

    fullyConnectedLayer(300)
    reluLayer
    fullyConnectedLayer(300)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(300)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(300)
    reluLayer
    fullyConnectedLayer(300)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(300)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(OUTPUT_SIZE)
    sigmoidLayer
%    bitClassificationLayer
    sigmoidClassificationLayer
];

options =  trainingOptions('adam', ...
    'InitialLearnRate',3e-4, ...
    'MaxEpochs',200, ...
    'MiniBatchSize',64, ...
    'Plots','training-progress');

net = trainNetwork(training.Y,training.B,layers,options);
Bhat = predict(net,testing.Y);

%Bhat = 1./(1+exp(-Bhat));

disp(mean(mean(abs(squeeze(Bhat>.5) - squeeze(testing.B)'))));
