close all
clear variables 
clc

%% Get logging file
Import_Logging_lst

%% normalize data
cut = 1;

controller = LC1016;
controller_cut = controller(cut:end,:);
y = controller_cut(:,1) - controller_cut(1,1);
y_ref =  controller_cut(:,2) - controller_cut(1,2);
u = controller_cut(:,3) - controller_cut(1,3);
Time_cut = Time(cut:end) - Time(cut);


%% system identification
Ts = 1;
data = iddata(y,u,Ts);
nx = 2;
sys = n4sid(data,nx);

%% simulate
%y_sim = lsim(sys,u);
sim('lc1016');

plot(y_out);
