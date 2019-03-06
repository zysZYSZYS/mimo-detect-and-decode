classdef bitClassificationLayer < nnet.layer.RegressionLayer
    methods
        function loss = forwardLoss(layer, Y, T)
            % Return the loss between the predictions Y and the 
            % training targets T.
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %         loss  - Loss between Y and T

            % Layer forward loss function goes here.
            N = size(Y,4);
            Y = squeeze(Y);
            T = squeeze(T);
   
            loss = -sum(sum(T.*log(Y) + (1-T).*log(1-Y)))/N;
        end
        
        function dLdY = backwardLoss(layer, Y, T)
            % Backward propagate the derivative of the loss function.
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %         dLdY  - Derivative of the loss with respect to the predictions Y        

            % Layer backward loss function goes here.
            [~,~,K,N] = size(Y);
            Y = squeeze(Y);
            T = squeeze(T);
			
            dLdY = -(T./Y)/N + ((1-T)./(1-Y))/N;
            dLdY = reshape(dLdY,[1 1 K N]);
        end
    end
end
