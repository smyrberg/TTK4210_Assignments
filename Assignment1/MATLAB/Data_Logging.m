clear all
clc

%% Get data from the log file
% Make sure to use the correct path for the log file
fileID=fopen('Data_Logging.lst.txt','r'); % This loads the data log file
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
Time = Data(:,1);            % Time
LIC0001 = Data(:,2:4);       % Controller: LIC0001
LIC0002 = Data(:,5:7);       % Controller: LIC0002
% Where the:
% First column is the Process Value, PV
% Second column is the Set-Point, SP
% Third column is the Control Signal, OP
% Ex. 
% LIC0001(:,1) = Process Value, PV 
% LIC0001(:,2) = Set-Point, SP
% LIC0001(:,3) = Control signal, OP
%% Example plot
clf
% Plot for controller LIC0001
figure(1)
xmin = 0;
xmax = Time(end);
ymin = min(LIC0001(:,1));
ymax = max(LIC0001(:,1));
subplot(2,1,1)
plot(Time,LIC0001(:,1:2))
title('Level Control')
legend('Process Value, PV', 'Set-Point, SP')
legend('Location','southeast')
legend('Location','southeast')
xlabel('Time (s)')
ylabel('frac')
xlim([xmin xmax])
ylim([ymin-0.01*ymin ymax+0.01*ymax])

subplot(2,1,2)
ymin = min(LIC0001(:,3));
ymax = max(LIC0001(:,3));
plot(Time,LIC0001(:,3))
legend('Controller output, OP')
legend('Location','southeast')
xlabel('Time (s)')
ylabel('frac')
xlim([xmin xmax])
ylim([ymin-0.1*ymin ymax+0.1*ymax])

% Plot for controller LIC0002
figure(2)
xmin = 0;
xmax = Time(end);
ymin = min(LIC0002(:,1));
ymax = max(LIC0002(:,1));
subplot(2,1,1)
plot(Time,LIC0002(:,1:2))
title('Level Control')
legend('Process Value, PV', 'Set-Point, SP')
legend('Location','southeast')
xlabel('Time (s)')
ylabel('frac')
xlim([xmin xmax])
ylim([ymin-0.01*ymin ymax+0.01*ymax])

subplot(2,1,2)
ymin = min(LIC0002(:,3));
ymax = max(LIC0002(:,3));
plot(Time,LIC0002(:,3))
legend('Controller output, OP')
legend('Location','southeast')
xlabel('Time (s)')
ylabel('frac')
xlim([xmin xmax])
ylim([ymin-0.1*ymin ymax+0.1*ymax])