clc;clear all;close all
% % ===================================================================== %
% % Artificial Bee Colony Algorithm (demo)                                %
% % ===================================================================== %
% % Author: aoyuan                                                        %
% % Release Date: November 18, 2015.                                      %
% % Modified Date:                                                        %
% % ===================================================================== %
% % ===================================================================== %
help ABC.m
path = pwd;
path = path(1:end);

%% Problem Definition
funcNum =1;
[Lb, Ub, dim] = funcRange(funcNum);  % for objFunc: twenty-three benchmark functions   
%% ABC Parameters
para = struct;
para.NGen=150000;                % Maximum Number of Iterations
para.NP = 100;                 % Population Size
para.nOnlooker=para.NP;        % Number of Onlooker Bees
para.L=round(0.6*dim*para.NP); % Abandonment Limit Parameter (Trial Limit)
para.a=1;                           % Acceleration Coefficient Upper Bound
%% Main function
Nr = 1;
for run = 1:Nr
    rand('state',sum(100*clock))
    tic;
    BestChart = ABC_func('objFunc',para,Lb, Ub, dim,funcNum);       
    t = toc;
    fprintf('R = %2d, time = %3.5f, error = %10.3e\n', run, t, BestChart(end))        
end 