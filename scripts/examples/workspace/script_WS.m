% Script file to show how to use the inverse dynamics simulator
%
% Author        : Jonathan EDEN
% Created       : 2015
% Description    :

% Load configs
clc; clear; warning off; close all;

% Set up the model 
model_type = ModelConfigType.M_2DOF_VSD;
cable_set_id = 'basic_vsd';
model_config = ModelConfig(model_type);
modelObj = model_config.getModel(cable_set_id);

% Set up the workspace simulator
% First the grid
q_step          =   0.1; n_dim           =   2;
uGrid           =   UniformGrid(0.1*ones(n_dim,1),0.9*ones(n_dim,1),q_step*ones(n_dim,1));
% Define the workspace condition and metrics
% w_condition  =   {WorkspaceCondition.CreateWorkspaceCondition(WorkspaceConditionType.WRENCH_CLOSURE,WrenchClosureMethods.M_COMBINATORIC_NULL_SPACE,[])};
w_condition  =   {WorkspaceCondition.CreateWorkspaceCondition(WorkspaceConditionType.WRENCH_CLOSURE,[],[])};
w_metric = {WorkspaceMetric.CreateWorkspaceMetric(WorkspaceMetricType.SEACM,[]),WorkspaceMetric.CreateWorkspaceMetric(WorkspaceMetricType.TENSION_FACTOR,[])};
opt = WorkspaceSimulatorOptions(false);

% Start the simulation
disp('Start Setup Simulation');
wsim            =   WorkspaceSimulator(modelObj,uGrid,w_condition,w_metric,opt);

% Run the simulation
disp('Start Running Simulation');
wsim.run([]);

% Plot the simulation
disp('Start Plotting Simulation');
wsim.plotWorkspace(WorkspaceConditionType.WRENCH_CLOSURE,[1,2],[]);
%wsim.plotWorkspace(WorkspaceMetricType.TENSION_FACTOR,[1,2],[]);