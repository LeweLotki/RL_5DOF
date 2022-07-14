%% CRITIC
% Create the critic network layers
criticLayerSizes = [64 32 16];
statePath = [
    featureInputLayer(numObs,'Normalization','none','Name', 'observation')
    fullyConnectedLayer(criticLayerSizes(1), 'Name', 'CriticStateFC1', ... 
            'Weights',2/sqrt(numObs)*(rand(criticLayerSizes(1),numObs)-0.5), ...
            'Bias',2/sqrt(numObs)*(rand(criticLayerSizes(1),1)-0.5))
    reluLayer('Name','CriticStateRelu1')
    fullyConnectedLayer(criticLayerSizes(2), 'Name', 'CriticStateFC2', ...
            'Weights',2/sqrt(criticLayerSizes(1))*(rand(criticLayerSizes(2),criticLayerSizes(1))-0.5), ... 
            'Bias',2/sqrt(criticLayerSizes(1))*(rand(criticLayerSizes(2),1)-0.5))
    ];
actionPath = [
    featureInputLayer(numAct,'Normalization','none', 'Name', 'action')
    fullyConnectedLayer(criticLayerSizes(2), 'Name', 'CriticActionFC1', ...
            'Weights',2/sqrt(numAct)*(rand(criticLayerSizes(2),numAct)-0.5), ... 
            'Bias',2/sqrt(numAct)*(rand(criticLayerSizes(2),1)-0.5))
    ];
commonPath = [
    additionLayer(2,'Name','add')
    reluLayer('Name','CriticCommonRelu1')
    fullyConnectedLayer(1, 'Name', 'CriticOutput',...
            'Weights',2*5e-3*(rand(1,criticLayerSizes(2))-0.5), ...
            'Bias',2*5e-3*(rand(1,1)-0.5))
    ];

% Connect the layer graph
criticNetwork = layerGraph(statePath);
criticNetwork = addLayers(criticNetwork, actionPath);
criticNetwork = addLayers(criticNetwork, commonPath);
criticNetwork = connectLayers(criticNetwork,'CriticStateFC2','add/in1');
criticNetwork = connectLayers(criticNetwork,'CriticActionFC1','add/in2');

% Create critic representation
criticOptions = rlRepresentationOptions('Optimizer','adam','LearnRate',1e-2, ... 
                                        'GradientThreshold',1,'L2RegularizationFactor',2e-4);
useGPU = false;
if useGPU
   criticOptions.UseDevice = 'gpu'; 
end
critic = rlRepresentation(criticNetwork,env.getObservationInfo,env.getActionInfo, ...
                          'Observation',{'observation'},'Action',{'action'}, ...
                          criticOptions);

%% ACTOR
% Create the actor network layers
actorLayerSizes = [64 32 16];
actorNetwork = [
    featureInputLayer(numObs,'Normalization','none','Name','observation')
    fullyConnectedLayer(actorLayerSizes(1), 'Name', 'ActorFC1', ...
            'Weights',2/sqrt(numObs)*(rand(actorLayerSizes(1),numObs)-0.5), ... 
            'Bias',2/sqrt(numObs)*(rand(actorLayerSizes(1),1)-0.5))
    reluLayer('Name', 'ActorRelu1')
    fullyConnectedLayer(actorLayerSizes(2), 'Name', 'ActorFC2', ... 
            'Weights',2/sqrt(actorLayerSizes(1))*(rand(actorLayerSizes(2),actorLayerSizes(1))-0.5), ... 
            'Bias',2/sqrt(actorLayerSizes(1))*(rand(actorLayerSizes(2),1)-0.5))
    reluLayer('Name', 'ActorRelu2')
    fullyConnectedLayer(numAct, 'Name', 'ActorFC3', ... 
            'Weights',2*5e-3*(rand(numAct,actorLayerSizes(2))-0.5), ... 
            'Bias',2*5e-5*(rand(numAct,1)-0.5))                       
    tanhLayer('Name','ActorTanh1')
    ];

% Create actor representation
actorOptions = rlRepresentationOptions('Optimizer','adam','LearnRate',1e-2, ...
                                       'GradientThreshold',1,'L2RegularizationFactor',2e-4);
if useGPU
   actorOptions.UseDevice = 'gpu'; 
end
actor = rlRepresentation(actorNetwork,env.getObservationInfo,env.getActionInfo, ... 
                         'Observation',{'observation'}, ...
                         'Action',{'ActorTanh1'},actorOptions);