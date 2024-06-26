function [net,tr]=NN_training_new(X,y,k,code,iter,par_vec)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%  net=NN_training_new(X,y,k,code,iter,par_vec)
% Returns a trained multilayer perceptron as a MATLAB object.
% this is used in newer versions of MATLAB where newff doesn't work
%
% INPUT ARGUMENTS:
%  X:       lxN matrix whose columns are the vectors of the
%           data set.
%  y:       N-dimensional vector containing the class labels for the
%           data vectors.
%  code:    a parameter that specifies the training algorithm to be used
%           ("1" for standard BP, "2" for BP with momentum term and "3" BP
%           with adaptive learning rate).
%  iter:    the maximum number of iterations that will be performed by the
%           algorithm. 
%  par_vec: a five-dimensional vector containing the values of (i) the
%           learning rate used in the standard BP algorithm, (ii) the
%           momentum term used in the BP with momentum term and (iii) the
%           three values involved in the BP with adaptive learning rate.
%
% OUTPUT ARGUMENTS:
%  net:     the neural network as a MATLAB object
%  tr:      training record (epoch and performance)  
%
% (c) 2010 S. Theodoridis, A. Pikrakis, K. Koutroumbas, D. Cavouras
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rand('seed',0);   % Initialization of the random number generators
randn('seed',0);

% List of training methods
methods_list={'traingd'; 'traingdm'; 'traingda';'trainlm'; 'traingdx'};

% Limits of the region where data lie
limit=[min(X(:,1)) max(X(:,1)); min(X(:,2)) max(X(:,2))];



% Neural network definition - Need to be replaced for 2023a and forth
%net=newff(limit,[k 1],{'tansig','purelin'}, methods_list{code,1}); %  'traingda')
net = feedforwardnet(k) ; 

% Neural network initialization
net=init(net);

% Setting parameters
net.trainFcn = methods_list{code,1};
net.trainParam.lr=par_vec(1);
net.trainParam.epochs =iter;
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'purelin';
net.trainParam.max_fail	= 10000;
if(code==2)
    net.trainFcn = methods_list{code,1};
    net.trainParam.lr=par_vec(1);
    net.trainParam.epochs =iter;
    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'purelin';
    net.trainParam.mc=par_vec(2);
    net.trainParam.max_fail	= 10000;
elseif(code==3)
    net.trainFcn = methods_list{code,1};
    net.trainParam.lr=par_vec(1);
    net.trainParam.epochs =iter;
    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'purelin';
    net.trainParam.lr_inc=par_vec(3);
    net.trainParam.lr_dec=par_vec(4);
    net.trainParam.max_perf_inc=par_vec(5);
    net.trainParam.max_fail= 10000;
    net.divideParam.trainRatio=0.7 ;
    net.divideParam.valRatio=0.3 ;
    
end





% Neural network training 
[net,tr]=train(net,X,y);
%NOTE: During training, the MATLAB shows a plot of the MSE vs the number of
%iterations
