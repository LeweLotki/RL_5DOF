close all
clearvars
clc

initManipulatorParameters

desire_position = [0, -12.4675, 16.2833, 11.7267]; % Z->X Y->Z X->Y
mdl = 'main';
open_system(mdl);

numObs = 8;
obsInfo = rlNumericSpec([numObs 1]);
obsInfo.Name = 'observations';

numAct = 5;
actInfo = rlNumericSpec([numAct 1],'LowerLimit',-1e2,'UpperLimit', 1e2);
actInfo.Name = 'torque';

blk = [mdl, '/RL Agent'];
env = rlSimulinkEnv(mdl,blk,obsInfo,actInfo);

env.ResetFcn = @ResetFcn;

createNetwork

agentOptions = rlDDPGAgentOptions;
agentOptions.SampleTime = Ts;
agentOptions.DiscountFactor = 0.99;
agentOptions.MiniBatchSize = 250;
agentOptions.ExperienceBufferLength = 1e6;
agentOptions.TargetSmoothFactor = 1e-3;
agentOptions.NoiseOptions.MeanAttractionConstant = 0.15;
agentOptions.NoiseOptions.StandardDeviation = 0.1;

agent = rlDDPGAgent(actor,critic,agentOptions);

maxEpisodes = 10000;
maxSteps = floor(Tf/Ts);  
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxEpisodes,...
    'MaxStepsPerEpisode',maxSteps,...
    'ScoreAveragingWindowLength',50,...
    'Verbose',true,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',190,...                   
    'SaveAgentCriteria','EpisodeReward',... 
    'SaveAgentValue',200);     

trainOpts.UseParallel = false;                    
trainOpts.ParallelizationOptions.Mode = 'sync';
trainOpts.ParallelizationOptions.StepsUntilDataIsSent = 32;
trainOpts.ParallelizationOptions.DataToSendFromWorkers = 'Experiences';

doTraining = true;
if doTraining    
    % Train the agent.
    trainingStats = train(agent,env,trainOpts);
% else
    % Load a pretrained agent for the example.
%     load('ManipulatorAgent.mat','agent')
end

rng(0)

simOptions = rlSimulationOptions('MaxSteps',maxSteps);
experience = sim(env,agent,simOptions);