clc
clear
close all

%% Part 1
f = @(x) 1 + 3*x + 4*(x^2) + 0.0001*(x^3) + 0.0001*(x^4);  % Underlying function
numberOfSamples = 100;
t = 1:100;
normalized_inputs = normalize(t, 'range', [-1, 1]);  % Data Normalization
samples = [];
for t1 = 1:numberOfSamples
    samples = [samples, f(normalized_inputs(t1))];   % Normalized samples
end


%% Part 2
noisy_samples = [];
for t2 = 1:numberOfSamples
    noise_coefficient = -0.25 + (0.5).*rand(1,1);  % Choosing random number in [a b] ==> a + (b-a)*rand(1,1); Here a = -0.25 && b = 0.25
    noise = noise_coefficient*samples(t2) + samples(t2);
    noisy_samples = [noisy_samples, noise];  % Normalized noisy samples
end


%% Part 3

Nonreg_theta = rand(5, 1); % We have 5 thetas (features)
reg_theta = rand(5, 1);
% theta = [1,3.1,4,0.001,0.001];  % For testing the algorithm
iteration = 100000;  % Number of iterations
iter = 1;  % Counter
alpha = 0.001;   % Learning Rate
patience = 3000; % If cost does not improve for #patience iterations, algorithm will stop updating the thetas.
p = 0;  % Counter
lambda = 0.1; % Used for regularization

% Defining variables for storing parameters
Nonreg_theta0_history = zeros(1, iteration);
Nonreg_theta1_history = zeros(1, iteration);
Nonreg_theta2_history = zeros(1, iteration);
Nonreg_theta3_history = zeros(1, iteration);
Nonreg_theta4_history = zeros(1, iteration);
reg_theta0_history = zeros(1, iteration);
reg_theta1_history = zeros(1, iteration);
reg_theta2_history = zeros(1, iteration);
reg_theta3_history = zeros(1, iteration);
reg_theta4_history = zeros(1, iteration);
Nonreg_cost_history = zeros(1, iteration);
reg_cost_history = zeros(1, iteration);
Nonreg_gradient_history0 = zeros(1, iteration);
Nonreg_gradient_history1 = zeros(1, iteration);
Nonreg_gradient_history2 = zeros(1, iteration);
Nonreg_gradient_history3 = zeros(1, iteration);
Nonreg_gradient_history4 = zeros(1, iteration);


while iter < iteration
    Nonreg_error_list = [];
    reg_error_list = [];
    Nonreg_gradient_list_theta0 = [];
    Nonreg_gradient_list_theta1 = [];
    Nonreg_gradient_list_theta2 = [];
    Nonreg_gradient_list_theta3 = [];
    Nonreg_gradient_list_theta4 = [];
   
    h_Nonreg = @(x) Nonreg_theta(1) + Nonreg_theta(2)*x + Nonreg_theta(3)*(x^2) + Nonreg_theta(4)*(x^3) + Nonreg_theta(5)*(x^4);  % Prediction function
    h_reg = @(x) reg_theta(1) + reg_theta(2)*x + reg_theta(3)*(x^2) + reg_theta(4)*(x^3) + reg_theta(5)*(x^4);  % Prediction function

    grads0 = 0;
    grads1 = 0; 
    grads2 = 0;
    grads3 = 0;
    grads4 = 0;
    
    
    for i = 1:numberOfSamples
        Nonreg_pred = h_Nonreg(normalized_inputs(i));  % non-regularized prediction
        Nonreg_error = Nonreg_pred - noisy_samples(i); % non-regularized loss
        Nonreg_error_list = [Nonreg_error_list, Nonreg_error];
        
        reg_pred = h_reg(normalized_inputs(i));  % regularized prediction
        reg_error = reg_pred - noisy_samples(i); % regularized loss
        reg_error_list = [reg_error_list, reg_error];
        
        
        
        %non-regularized gradient calculation
        Nonreg_grad0 = Nonreg_error;
        Nonreg_grad1 = Nonreg_error * normalized_inputs(i);
        Nonreg_grad2 = Nonreg_error * (normalized_inputs(i)^2);
        Nonreg_grad3 = Nonreg_error * (normalized_inputs(i)^3);
        Nonreg_grad4 = Nonreg_error * (normalized_inputs(i)^4);
        
        %Regularized gradient calculation
        reg_grad0 = reg_error;
        reg_grad1 = (reg_error * (normalized_inputs(i)) + lambda*reg_theta(2));
        reg_grad2 = (reg_error * (normalized_inputs(i)^2) + lambda*reg_theta(3));
        reg_grad3 = (reg_error * (normalized_inputs(i)^3) + lambda*reg_theta(4));
        reg_grad4 = (reg_error * (normalized_inputs(i)^4) + lambda*reg_theta(5));
        
        
        %Storing non-regularized gradients
        Nonreg_gradient_list_theta0 = [Nonreg_gradient_list_theta0, Nonreg_grad0];
        Nonreg_gradient_list_theta1 = [Nonreg_gradient_list_theta1, Nonreg_grad1];
        Nonreg_gradient_list_theta2 = [Nonreg_gradient_list_theta2, Nonreg_grad2];
        Nonreg_gradient_list_theta3 = [Nonreg_gradient_list_theta3, Nonreg_grad3];
        Nonreg_gradient_list_theta4 = [Nonreg_gradient_list_theta4, Nonreg_grad4];
        
        %Storing regularized gradients
        grads0 = grads0 + reg_grad0;
        grads1 = grads1 + reg_grad1;
        grads2 = grads2 + reg_grad2;
        grads3 = grads3 + reg_grad3;
        grads4 = grads4 + reg_grad4;
        
    end
    
    theta_sum = sum(reg_theta(1)^2 + reg_theta(2)^2 + reg_theta(3)^2 + reg_theta(4)^2 + reg_theta(5)^2);

    % Updating non-regularized thetas
    Nonreg_theta(1) = Nonreg_theta(1) - alpha * (mean(Nonreg_gradient_list_theta0));
    Nonreg_theta(2) = Nonreg_theta(2) - alpha * (mean(Nonreg_gradient_list_theta1));
    Nonreg_theta(3) = Nonreg_theta(3) - alpha * (mean(Nonreg_gradient_list_theta2));
    Nonreg_theta(4) = Nonreg_theta(4) - alpha * (mean(Nonreg_gradient_list_theta3));
    Nonreg_theta(5) = Nonreg_theta(5) - alpha * (mean(Nonreg_gradient_list_theta4));
    
    % Updating regularized thetas
    reg_theta(1) = reg_theta(1) - alpha * (0.01*(grads0));
    reg_theta(2) = reg_theta(2) - alpha * (0.01*(grads1));
    reg_theta(3) = reg_theta(3) - alpha * (0.01*(grads2));
    reg_theta(4) = reg_theta(4) - alpha * (0.01*(grads3));
    reg_theta(5) = reg_theta(5) - alpha * (0.01*(grads4));
    
    
    
    % Storing non-regularized thetas
    Nonreg_theta0_history(iter) = Nonreg_theta(1);
    Nonreg_theta1_history(iter) = Nonreg_theta(2);
    Nonreg_theta2_history(iter) = Nonreg_theta(3);
    Nonreg_theta3_history(iter) = Nonreg_theta(4);
    Nonreg_theta4_history(iter) = Nonreg_theta(5);
    
    % Storing Regularized thetas
    
    reg_theta0_history(iter) = reg_theta(1);
    reg_theta1_history(iter) = reg_theta(2);
    reg_theta2_history(iter) = reg_theta(3);
    reg_theta3_history(iter) = reg_theta(4);
    reg_theta4_history(iter) = reg_theta(5);
    
    % Storing non-regularized gradients
    Nonreg_gradient_history0(iter) = mean(Nonreg_gradient_list_theta0);
    Nonreg_gradient_history1(iter) = mean(Nonreg_gradient_list_theta1);
    Nonreg_gradient_history2(iter) = mean(Nonreg_gradient_list_theta2);
    Nonreg_gradient_history3(iter) = mean(Nonreg_gradient_list_theta3);
    Nonreg_gradient_history4(iter) = mean(Nonreg_gradient_list_theta4);
    
    Nonreg_cost = mean((Nonreg_error_list).^2);  % Calculating non-regularized cost
    reg_cost = 0.05*(sum(reg_error_list.^2) + lambda*theta_sum); %Calculating regularized cost
    Nonreg_cost_history(iter) = Nonreg_cost;   % Storing non-regularized cost
    reg_cost_history(iter) = reg_cost;
    
    % Print magnitude of cost each 1000 iterations
    if mod(iter, 1000) == 0
    fprintf('Iteration %d \t Non-regularized cost = %f \t Regularized cost = %f\n', iter, Nonreg_cost, reg_cost);
    end
    
    %% Early Stopping  (Monitoring non-regilarized cost)
    if iter>=2
        temp1 = str2num(sprintf('%.4f',Nonreg_cost_history(iter)));
        temp2 = str2num(sprintf('%.4f',Nonreg_cost_history(iter-1))); % We crate temp1 & temp2 to scape from round of error.
    if temp1 == temp2
       p = p+1;
       if p == patience
           disp('-------------------------------------------------------------');
           disp('Algorithm is <strong>not</strong> improving, Stopping the learning ...');
           break;
       end
    else
        p = 0;
    end
    end
    iter = iter + 1;
end


%===================Part1 plots==============================
figure('Name', 'Part1');
plot(normalized_inputs, samples, 'black', 'LineWidth', 2);
hold on;
plot(normalized_inputs, samples, 'r*', 'LineWidth', 2, 'MarkerSize', 5);
title('Part1 - Dot/Line plot of samples');
xlabel('t (inputs)');
ylabel('f(t) = 1 + 3x + 4x^2 + 0.0001x^3 + 0.0001x^4');
legend('Line Plot', 'Samples', 'Location', 'northwest');

%===================Part2 plots==============================
figure('Name', 'Part2');
plot(normalized_inputs, noisy_samples, 'b.', normalized_inputs, samples, 'r.', 'MarkerSize', 13);
title('Part2 - Plotting original and noisy data');
xlabel('t (Normalized inputs)');
ylabel('f(t) (+noise)');
legend('Noisy Data (#set2)', 'Clean Data (#set1)', 'Location', 'northwest');
% ===================Part3 plots===============================

figure('Name', 'Part3');
subplot(4,2,1:2);
plot(1:iter, Nonreg_cost_history(1:iter), 'LineWidth', 2);
title('cost function (non-regularized)');
xlabel('Iteration');
ylabel('Cost Magnitude');

subplot(423);
plot(1:iter, Nonreg_theta0_history(1:iter), 'LineWidth', 2);
title('\theta0 changes over iterations. (non-regularized)');
xlabel('Iteration');
ylabel('\theta0 value');

subplot(424);
plot(1:iter, Nonreg_theta1_history(1:iter), 'LineWidth', 2);
title('\theta1 changes over iterations. (non-regularized)');
xlabel('Iteration');
ylabel('\theta1 value');

subplot(425);
plot(1:iter, Nonreg_theta2_history(1:iter), 'LineWidth', 2);
title('\theta2 changes over iterations. (non-regularized)');
xlabel('Iteration');
ylabel('\theta2 value');

subplot(426);
plot(1:iter, Nonreg_theta3_history(1:iter), 'LineWidth', 2);
title('\theta3 changes over iterations. (non-regularized)');
xlabel('Iteration');
ylabel('\theta3 value');

subplot(427);
plot(1:iter, Nonreg_theta4_history(1:iter), 'LineWidth', 2);
title('\theta4 changes over iterations. (non-regularized)');
xlabel('Iteration');
ylabel('\theta4 value');

%=============Gradient Plots=======================
figure('Name', 'Gradient changes ');
subplot(3,2,1:2);
plot(1:iter, Nonreg_gradient_history0(1:iter), 'LineWidth', 2);
title('Gradient of \theta0 (non-regularized)');
xlabel('iteration');
ylabel('Magnitude of gradient');

subplot(3,2,3);
plot(1:iter, Nonreg_gradient_history1(1:iter), 'LineWidth', 2);
title('Gradient of \theta1 (non-regularized)');
subplot(3,2,4);
plot(1:iter, Nonreg_gradient_history2(1:iter), 'LineWidth', 2);
title('Gradient of \theta2 (non-regularized)');
xlabel('iteration');
ylabel('Magnitude of gradient');

subplot(3,2,5);
plot(1:iter, Nonreg_gradient_history3(1:iter), 'LineWidth', 2);
title('Gradient of \theta3 (non-regularized)');
xlabel('iteration');
ylabel('Magnitude of gradient');

subplot(3,2,6);
plot(1:iter, Nonreg_gradient_history4(1:iter), 'LineWidth', 2);
title('Gradient of \theta4 (non-regularized)');
xlabel('iteration');
ylabel('Magnitude of gradient');

% =================Plotting results of regularized and non-regularized method=========================
z = @(x) Nonreg_theta(1) + Nonreg_theta(2)*x + Nonreg_theta(3)*(x.^2) + Nonreg_theta(4)*(x.^3) + Nonreg_theta(5)*(x.^4);  % Prediction function
z = z(normalized_inputs);
z1 = @(x) reg_theta(1) + reg_theta(2)*x + reg_theta(3)*(x.^2) + reg_theta(4)*(x.^3) + reg_theta(5)*(x.^4);  % Prediction function
z1 = z1(normalized_inputs);

figure('Name', 'Part3');
plot(normalized_inputs, noisy_samples, 'b.', 'MarkerSize', 15);
hold on;
plot(normalized_inputs, z, 'r.', 'MarkerSize', 15);
hold on;
plot(normalized_inputs, z1, 'k.', 'MarkerSize', 15);
xlabel('t (inputs)');
ylabel('f(t)');
legend('Original Data (Noisy Data)', 'Estimated by non-regularized regression','Estimated by regularized regression', 'Location', 'northwest');

% ====================Printing Results==========================
text = sprintf('Algorithm stopped at iteration <strong>%d</strong>', iter);
disp(text);
disp('Calculated parameters are as follows:');
T = table([Nonreg_theta(1);Nonreg_theta(2); Nonreg_theta(3); Nonreg_theta(4); Nonreg_theta(5)], ...
    [reg_theta(1);reg_theta(2); reg_theta(3); reg_theta(4); reg_theta(5)],[1; 3; 4; 0.0001; 0.0001],...
    'VariableNames',{'Estimated_by_Nonregularized_regression', 'Estimated_by_regularized_regression',...
    'Real_values'},'RowName', {'theta0','theta1', 'theta2', 'theta3', 'theta4'});
disp(T);
    