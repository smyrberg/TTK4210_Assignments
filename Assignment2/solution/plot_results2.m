close all

% Plot results for PI controller
figure(1)
    subplot 211
    y=y_PI;
    plot(y_ref.time,y_ref.signals.values(:,1),'r')
    title('PI controller, y_1');
    hold on
    plot(y.time,y.signals.values(:,1),'b')
    ylim([-3 3])

    subplot 212
    plot(y_ref.time,y_ref.signals.values(:,2),'r')
    title('PI controller, y_2');
    hold on
    plot(y.time,y.signals.values(:,2),'b')
    ylim([-3 3])

% Plot results for Dynamic decoupling controller
figure(2)
    subplot 211
    y=y_Dec;
    plot(y_ref.time,y_ref.signals.values(:,1),'r')
    title('Dynamic decoupling, y_1');
    hold on
    plot(y.time,y.signals.values(:,1),'b')
    ylim([-3 3])

    subplot 212
    plot(y_ref.time,y_ref.signals.values(:,2),'r')
    title('Dynamic decoupling, y_2');
    hold on
    plot(y.time,y.signals.values(:,2),'b')
    ylim([-3 3])

% Plot results for inverted decoupling controller
figure(3)
    subplot 211
    y=y_Inv_Dec;
    plot(y_ref.time,y_ref.signals.values(:,1),'r')
    title('Inverted decoupling, y_1');
    hold on
    plot(y.time,y.signals.values(:,1),'b')
    ylim([-3 3])

    subplot 212
    plot(y_ref.time,y_ref.signals.values(:,2),'r')
    title('Inverted decoupling, y_2');
    hold on
    plot(y.time,y.signals.values(:,2),'b')
    ylim([-3 3])

    % Plot results for LQG controller (Kalman+LQR+int)
figure(4)
    subplot 211
    y=y_KFLQR;
    plot(y_ref.time,y_ref.signals.values(:,1),'r')
    title('LQG (Kalman+LQR) controller with integral action, y_1');
    hold on
    plot(y.time,y.signals.values(:,1),'b')
    ylim([-3 3])

    subplot 212
    plot(y_ref.time,y_ref.signals.values(:,2),'r')
    title('LQG (Kalman+LQR) controller with integral action, y_2');
    hold on
    plot(y.time,y.signals.values(:,2),'b')
    ylim([-3 3])

% Plot results for PI controller anti windup
figure(5)
    subplot 211
    y=y_PI_antiwindup;
    plot(y_ref.time,y_ref.signals.values(:,1),'r')
    title('PI controller anti-windup, y_1');
    hold on
    plot(y.time,y.signals.values(:,1),'b')
    ylim([-3 3])

    subplot 212
    plot(y_ref.time,y_ref.signals.values(:,2),'r')
    title('PI controller anti-windup, y_2');
    hold on
    plot(y.time,y.signals.values(:,2),'b')
    ylim([-3 3])

    
    
% 
% print(1,'-dpdf','gfx/Response-PI-noSat.pdf');
% print(2,'-dpdf','gfx/Response-LQG-noSat.pdf');
% print(3,'-dpdf','gfx/Response-Dec-noSat.pdf');
% print(4,'-dpdf','gfx/Response-inv-Dec-noSat.pdf');