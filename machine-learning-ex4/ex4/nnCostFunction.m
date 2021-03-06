function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%



a_1 = X;
X = [ones(m, 1) X];

num_labels = max(y);

% initialize y_vec
y_vec = zeros(m,num_labels);


for i = 1:m
  y_vec(i, y(i)) = 1;
end

z_2 = X*Theta1';
a_2 = sigmoid(z_2);


% Add ones to the a_2 data matrix
a_2 = [ones(m, 1) a_2];

z_3 = a_2*Theta2';
a_3 = sigmoid(z_3);

J = 0;
for i = 1:m
    y_i = y_vec(i,:);
    h_i = a_3(i,:);
    J += (-y_i*log(h_i') - (1 - y_i)*log(1 - h_i'))/m;
end


%Implementing regularization

Theta1R=Theta1(:,2:input_layer_size+1);

Theta2R=Theta2(:,2:hidden_layer_size+1);

J = J + (lambda/(2*m))*(sum(sum(Theta1R.^2)) + sum(sum(Theta2R.^2)));

%Implementing backprop

d_3 = a_3 - y_vec;


d_2 = (Theta2'*d_3')(2:hidden_layer_size+1,:)'.*sigmoidGradient(z_2);




Theta2_grad = (d_3'*a_2)/m;

Theta1_grad = (d_2'*X)/m;

% Regularized

Theta1_grad_one = Theta1_grad(:,1);
Theta1_grad_rest = Theta1_grad(:,2:input_layer_size+1);
Theta1_one = Theta1(:,1);
Theta1_rest = Theta1(:,2:input_layer_size+1);

Theta1_grad_rest = Theta1_grad_rest + (lambda/m)*Theta1_rest;
Theta1_grad = [Theta1_grad_one Theta1_grad_rest];



Theta2_grad_one = Theta2_grad(:,1);
Theta2_grad_rest = Theta2_grad(:,2:hidden_layer_size+1);
Theta2_one = Theta2(:,1);
Theta2_rest = Theta2(:,2:hidden_layer_size+1);

Theta2_grad_rest = Theta2_grad_rest + (lambda/m)*Theta2_rest;
Theta2_grad = [Theta2_grad_one Theta2_grad_rest];


% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
