%% The main idea of this code which is implementing PSO, is obtained from following sources:
%% 1 - https://www.mathworks.com/matlabcentral/fileexchange/52857-particle-swarm-optimization-pso
%% 2 - https://www.mathworks.com/matlabcentral/fileexchange/67429-a-simple-implementation-of-particle-swarm-optimization-pso-algorithm
%% 3 - https://www.youtube.com/@SolvingOptimizationProblems
%% 4 - https://www.youtube.com/watch?v=eby75h9HqRo

function [route, pso_path, particle, BestRecord] = ... 
    PSOsuggestRoute(initial_route, model, Population_Size)

%% Problem Definition

flag = 'pso';       % This flag is used in computeEUCDistance
cC = model.cC;      % Cities Locations
nVar=model.N;       % Number of Variables
VarSize=[1 nVar];   % Size of Variables Matrix


%% PSO Parameters

NUM_ITERATION=120;               % Maximum Number of Iterations
pop_size=Population_Size;        % Population Size (Swarm Size)
inertia=1;                       % Inertia Weight
wd=0.99;                         % Inertia Weight Damping Ratio
c1=0.2;                          % Personal Learning Coefficient
c2=0.4;                          % Global Learning Coefficient

%% Initialization

blank.Position=[];
blank.Cost=[];
blank.Sol=[];
blank.Velocity=[];
blank.Best.Position=[];
blank.Best.Cost=[];
blank.Best.Sol=[];

particle=repmat(blank,pop_size,1);  % Creating the population, size ==> [pop_size, 1]
BestRecord.Cost=inf;                % Initial cost value

for k=1:pop_size
    
    particle(k).Position=initial_route;    % Initialize Position of Particle
    particle(k).Velocity=zeros(VarSize);   % Initialize Velocity of Particle
    
    % Calculate euclidean distance
    [particle(k).Cost, particle(k).Sol]=computeEUCDistance(nVar, cC, particle(k).Position, flag);
    
    % Updating Personal Best Records
    particle(k).Best.Position=particle(k).Position;
    particle(k).Best.Cost=particle(k).Cost;
    particle(k).Best.Sol=particle(k).Sol;
    
    % Updating Global Best Records
    if particle(k).Best.Cost<BestRecord.Cost
        
        BestRecord=particle(k).Best;        
    end    
end

BestCost=zeros(NUM_ITERATION,1);

%% PSO Loop

for it=1:NUM_ITERATION
    
    for k=1:pop_size
        
        % Updating Velocity of Particle
        particle(k).Velocity = inertia*particle(k).Velocity ...
            +c1*rand(VarSize).*(particle(k).Best.Position-particle(k).Position) ...
            +c2*rand(VarSize).*(BestRecord.Position-particle(k).Position);        
        
        % Updating Position of Particle
        particle(k).Position = particle(k).Position + particle(k).Velocity;
        
        % Calculate euclidean distance
        [particle(k).Cost, particle(k).Sol]=computeEUCDistance(nVar, cC, particle(k).Position, flag);
        
        NewSol.Position=perturbRoute2(particle(k).Position);  % Using perturbRoute2
        % [~, NewSol.Position] =perturbRoute(particle(k));    % Using perturbRoute

        [NewSol.Cost, NewSol.Sol]=computeEUCDistance(nVar, cC, NewSol.Position, flag);

        if NewSol.Cost<=particle(k).Cost
            particle(k).Position=NewSol.Position;
            particle(k).Cost=NewSol.Cost;
            particle(k).Sol=NewSol.Sol;
        end
        
        % Updating Personal Best Record
        if particle(k).Cost<particle(k).Best.Cost
            
            particle(k).Best.Position=particle(k).Position;
            particle(k).Best.Cost=particle(k).Cost;
            particle(k).Best.Sol=particle(k).Sol;
            
            % Updating Global Best Record
            if particle(k).Best.Cost<BestRecord.Cost
                
                BestRecord=particle(k).Best;
                
            end 
        end        
    end
    
    NewSol.Position=perturbRoute2(BestRecord.Position);  % Using perturbRoute2
    % [~, NewSol.Position] =perturbRoute(BestRecord);    % Using perturbRoute

    [NewSol.Cost, NewSol.Sol]=computeEUCDistance(nVar, cC, NewSol.Position, flag);

    if NewSol.Cost<=BestRecord.Cost
        BestRecord=NewSol;
    end
    
    BestCost(it)=BestRecord.Cost;
    route = BestRecord.Sol.Tour;
    pso_path = BestRecord.Position;
    inertia=inertia*wd; 
end
end