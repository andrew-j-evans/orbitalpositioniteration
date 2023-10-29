clc;
clear;

a = 7000; %Semimajor axis in km
e = 0.1; %Eccentricity

mu = 398600; %Mu of earth
T = 1; %Days
%Plot magnitude of position, velocity, and specific mechanical energy
%throughout the day

R0 = a*(1 - e); %Initial Position
V0 = sqrt(mu*(2/R0-1/a)); %Initial Velocity
X = [R0; 0; 0; V0]; %State Vector
fXt = [0;V0;-(mu*R0)/(R0^3);0]; %Formula for fXt, caclculated iwth initial values
dt = 0.1; %Time step 

%Iteration Preallocation
n=T*60*60*24;
R = zeros(1,n);
V = zeros(1,n);
Rpqw = zeros(3,n);
SME = zeros(1,n);

R(1) = R0;
V(1) = V0;
Rpqw(:,1) = [X(1,1); X(2,1); 0];
SME(1) = (V0^2/2)-(mu/R0);
Xn = X;

%Looping through time
for t=1:(n-1)
    %Setting value for X of next iteration using formula
    % X(n+1)=X(n)+fXt dt

    Xnp1 = Xn + fXt*dt
    Xn = Xnp1;
    
    %Setting next R and V magnitudes to new magnitudes
    R(t+1) = norm(Xn(1:2));
    V(t+1) = norm(Xn(3:4));

    %Setting vector values
    Rpqw(:,t+1) = [Xn(1,1); Xn(2,1); 0];

    %Calculating new value for fXt based on new variables
    fXt = [Xn(3);Xn(4);-(mu*Xn(1)/(R(t+1)^3));-(mu*Xn(2)/(R(t+1)^3))];

    %Calculating specific mechanical energy and saving in array
    SME(t+1) = (V(t+1)^2/2)-(mu/R(t+1));

end

%%

%2D plots of position, velcoity, and specific mechanical energy vs time
subplot(3,3,1);
plot(1:n,R);
title('Position vs Time')

subplot(3,3,2);
plot(1:n,V);
title('Velocity vs Time')

subplot(3,3,3);
plot(1:n,SME);
title('Specific ME vs Time')

%3D plot of the orbit in a PQW frame
subplot(3,3,4:9);
hold on
plot3(Rpqw(1,:),Rpqw(2,:),Rpqw(3,:),'linewidth',3);
title('PQW Orbit')

%Setting axis labels and displays
line(2*xlim, [0,0], [0,0], 'LineWidth', 1, 'Color', 'k', 'DisplayName','P');
line([0,0], 2*ylim, [0,0], 'LineWidth', 1, 'Color', 'k', 'DisplayName','Q');
line([0,0], [0,0], 2*zlim, 'LineWidth', 1, 'Color', 'k', 'DisplayName','W');
view(3)
box on
plot(1:10)
set(gca,'Visible','off')

hold off