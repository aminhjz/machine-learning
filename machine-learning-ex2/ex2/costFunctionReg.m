function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta
theta_1=theta(1);
theta_rest=theta([2:length(theta)]);

X_1=X(:,1);
X_rest=X(:,[2:size(X)(2)]);

J = (-y'*log(sigmoid(X*theta)) - (1-y')*log(1 - sigmoid(X*theta)))/m + (lambda/(2*m))*sum(theta_rest.^2)

grad_1 = (sigmoid(X*theta) - y)'*X_1/m;
grad_rest =(sigmoid(X*theta) - y)'*X_rest/m + (lambda/m)*theta_rest'

grad = [grad_1, grad_rest];





% =============================================================

end
