clc; clear; close all;
tic;

flag = 'SA'; %* flag is used in computing euclidean distance

%% Preparing Data

cC = load('CityLocations.txt');   % Loading Data
numCities = size(cC,1);             % Number of cities
x=cC(1:numCities, 2);
y=cC(1:numCities, 3);

%* Wrapping important information in a structure
model.N = numCities;
model.x = x;
model.y = y;
Dist=zeros(numCities,numCities);  %* Storing distance between cities
for i=1:numCities-1
    for j=i:numCities
        Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
        Dist(j,i)=Dist(i,j);
    end
end
model.D = Dist;
model.cC = cC;

% Connecting the last and the first cities to have a closed route 
x(numCities+1)=cC(1,2);
y(numCities+1)=cC(1,3);

%% * Saving particle behaviour video
myVideo = VideoWriter('Particles.mp4', 'MPEG-4'); 
myVideo.FrameRate = 8;  
open(myVideo)


%% Initialization
shortestDistance = realmax;
numCoolingLoops = 12;       % Number of Cooling loops
numEquilbriumLoops = 30;    % Number of equilibrium loops
pStart = 0.6;               % Probability of accepting worse solution at the start
pEnd = 0.00005;             % Probability of accepting worse solution at the end
tStart = -1.0/log(pStart);  % Initial temperature
tEnd = -1.0/log(pEnd);      % Final temperature
frac = (tEnd/tStart)^(1.0/(numCoolingLoops-1.0));   % Fractional reduction per cycle
cityRoute_i = randperm(numCities);                  % Get initial route
cityRoute_b = cityRoute_i;
cityRoute_j = cityRoute_i;
cityRoute_o = cityRoute_i;
%* Initial distances
[D_j, ~] = computeEUCDistance(numCities, cC, cityRoute_i, flag);
D_o = D_j; D_b = D_j; D(1) = D_j;
numAcceptedSolutions = 1.0;
tCurrent = tStart;  % Current temperature = initial temperature
DeltaE_avg = 0.0;   % DeltaE Average
pop_size = 100;     %* Size of swarm
pso_path = unifrnd(0,1,[1 numCities]);  %* Pso route initialization

%% SA Main Loop
for i=1:numCoolingLoops
    % if(mod(i,1)==0)
        % disp(['Cycle: ',num2str(i),' Current temperature: ',num2str(tCurrent)]) 
    % end
    for j=1:numEquilbriumLoops
        % cityRoute_j = perturbRoute(numCities, cityRoute_b);

        %* instead of 'perturbRoute', 'PSO' yields the new route
        [cityRoute_j, pso_path, particle, GlobalBest] = PSOsuggestRoute(pso_path, ...
                                                        model, pop_size);

        % Calculating euclidean distance
        [D_j, ~] = computeEUCDistance(numCities, cC, cityRoute_j, flag);
        DeltaE = abs(D_j-D_b);

        if (D_j > D_b) % objective function is worse
            if (i==1 && j==1)
                DeltaE_avg = DeltaE; 
            end

            p = exp(-DeltaE/(DeltaE_avg * tCurrent));
            if (p > rand())
                accept = true; 
            else 
                accept = false; 
            end
        else 
            accept = true; % objective function is better
        end

        if (accept==true)
            cityRoute_b = cityRoute_j;
            D_b = D_j;
            numAcceptedSolutions = numAcceptedSolutions + 1.0;
            DeltaE_avg = (DeltaE_avg * (numAcceptedSolutions-1.0) + ... 
                                            DeltaE) / numAcceptedSolutions;
        end


    %% * Plotting behaviour of a random particles
    rand_particle = randi(pop_size);
    figure(2);
    plot(particle(rand_particle).Position, 'b.', 'MarkerSize', 10);
    hold on;
    plot(GlobalBest.Position, 'r.', 'MarkerSize', 11);
    legend('Random Particle', 'Global Best', 'Location','northeastoutside')
    xlabel('Number of Cities');
    ylabel('Particle Position');
    title('Particles Behaviour');
    hold off;
    frame = getframe(gcf); %* get frame
    writeVideo(myVideo, frame);
    end

    tCurrent = frac * tCurrent; % Lower the temperature for next cycle
    cityRoute_o = cityRoute_b;  % Update optimal route at each cycle
    D(i+1) = D_b; %record the route distance for each temperature setting

    if(D_b < shortestDistance)
        shortestDistance = D_b;
        bestRoute = cityRoute_b;
    end

    D_o = D_b; % Update optimal distance
    disp(['Iter ' num2str(i) ': Distance =  ' num2str(D_b)]);
end

% print solution
disp(['Best solution: ',num2str(cityRoute_o)]);
% Compute distance
D_b=0; cR = cityRoute_o;

for i=1:numCities-1
	D_b = D_b + sqrt((cC(cR(i),2)-cC(cR(i+1),2))^2 + (cC(cR(i),3)-cC(cR(i+1),3))^2);
end

D_b = D_b + sqrt((cC(cR(numCities),2)-cC(cR(1),2))^2 + (cC(cR(numCities),3)-cC(cR(1),3))^2);
disp(['Best algo   objective: ',num2str(D_b)]);
disp(['Best global objective: ',num2str(D_o)]);
disp(['Shortest distance: ',num2str(shortestDistance)]);

%Save city route to file
fileID = fopen('BestCR.txt','w');
fprintf(fileID,'%6.2f\n',cR);
fclose(fileID);

%% Results
hold off
figure(6)
set(0, 'defaultaxesfontname', 'Arial');
set(0, 'defaultaxesfontsize', 14);
plot(D, 'r.-', 'LineWidth', 2);
ylabel('Distance', 'fontsize', 14, 'fontname', 'Arial');
xlabel('Route Number', 'fontsize', 14, 'fontname', 'Arial');
title('Distance vs Route Number', 'fontsize', 16, 'fontname', 'Arial');


for i=1:numCities
    x(i)=cC(cR(i),2);
    y(i)=cC(cR(i),3);
end
x(numCities+1)=cC(cR(1),2);
y(numCities+1)=cC(cR(1),3);
figure
hold on
plot(x',y',...
    'r',...
    'LineWidth',1,...
    'MarkerSize',8,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[1.0,1.0,1.0])
plot(x(1),y(1),...
    'r',...
    'LineWidth',1,...
    'MarkerSize',8,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[1.0,0.0,0.0])
labels = cellstr(num2str([1:numCities]'));  % # labels correspond to their order
text(x(1:numCities)', y(1:numCities)', labels, 'VerticalAlignment','middle', ...
                             'HorizontalAlignment','center')

ylabel('Y Coordinate', 'fontsize', 18, 'fontname', 'Arial');
xlabel('X Coordinate', 'fontsize', 18, 'fontname', 'Arial');
title(['Best City Route (Distance = ' num2str(shortestDistance) ')'], 'fontsize', 20, 'fontname', 'Arial');
endTime = toc;
fprintf('Total time: %d minutes and %.1f seconds\n', floor(endTime/60), rem(endTime,60));
close(myVideo)


