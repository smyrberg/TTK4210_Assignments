%% cleanup
close all
clear variables
clc

%% Get data from the log file
% Make sure to use the correct path for the log file
fileID=fopen('Logging.lst.txt','r'); % This loads the data log file
for m = 1:35
    String_Row=fgetl(fileID); % Ignore first 35 rows in the txt file	
end

i = 1;    
while(ischar(String_Row));        % Continue until the end of file 
       String_Row=fgetl(fileID);  % Read row from txt file 
    if ischar(String_Row) ~= 0    
        Num_Vector = str2num(String_Row);   % Converts string number a vector 
        Data(i,:) = Num_Vector;             % Store rows into a "Data" Matrix
    end
     i = i + 1;
end
fclose(fileID); % Close the data log file 

%% Controller data
Time = Data(:,1);           % Time
PC1024 = Data(:,2:4);       % Controller: 24_PC1024
FC1005 = Data(:,5:7);       % Controller: 24_FC1005
FC1019 = Data(:,8:10);      % Controller: 24_FC1019
LC1016 = Data(:,11:13);     % Controller: 24_LC1016
LC1015 = Data(:,14:16);     % Controller: 24_LC1015
FC1015 = Data(:,17:19);     % Controller: 24_FC1015
LC1028 = Data(:,20:22);     % Controller: 24_LC1028
TC1015 = Data(:,23:25);     % Controller: 24_TC1015
TC1088 = Data(:,26:28);     % Controller: 24_TC1088
% Where the:
% First column is the Process Value, PV
% Second column is the Set-Point, SP
% Third column is the Control Signal, OP
% Ex. 
% PC1024(:,1) = Process Value, PV 
% PC1024(:,2) = Set-Point, SP
% PC1024(:,3) = Control signal, OP
    
%% normalize data
cut = 1; %Where to start reading the data from

controller = LC1015; %Choose the controller we want
controller_cut = controller(cut:end,:);
y = controller_cut(:,1) - controller_cut(1,1);
y_ref =  controller_cut(:,2) - controller_cut(1,2);
u = controller_cut(:,3) - controller_cut(1,3);
Time_cut = Time(cut:end) - Time(cut);


%% system identification
Ts = 1; %Sample time
data = iddata(y,u,Ts); %Generate data of type iddata needed for n4sid
nx = 1; %Order of model
sys = n4sid(data,nx, 'inputdelay', 60); %Compute model with eventual input delay

%% 
y_sim = lsim(sys,u);

%% plot
figure
plot(Time_cut./60, y, 'b'); hold on;
plot(Time_cut./60, y_sim, 'r');
plot(Time_cut./60, y_ref);
%plot(Time_cut./60, u);
xlabel('min');
legend('Process Value, PV',['Fitted model of order ' num2str(nx)] , 'Reference value');