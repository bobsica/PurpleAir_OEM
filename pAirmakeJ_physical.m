function [R, yf, J] = pAirmakeJ_physical(Q, R, x, iter)
% Call the forward model and make the Jacobian
% -Inputs-
%	Q - retrieval input data structure
%	R - structure for the Jacobians of model parameters - computed now after
%	retrieval in function R  = makeParameterJacobians(Q,x)
%   x - retrieved parameters (see below)
%   iter - required and calculated in oem, the iteration numbers of the solution
%
% -Outputs-
%	R - old retrieval Jacobians in, new out
%	yf - forward model calculated on data grid
%   J - retrieval Jacobians

m = length(Q.Y);
expo = Q.RH.*exp(-Q.b./(Q.T*Q.Dp));
yf = x(1)+Q.Y ./ (1 + x(2)*expo./(1 - expo)); % forward model

%J is an m x 3 matrix
J = zeros(m, length(x));

%J(:,1) = Q.Y ./ (1 + x(3)*expo./(1 - expo)); % 1st col is derivative wrt x(1)
J(:,1) = 1; % 2nd col is derivative wrt x(2)
J(:,2) = (Q.Y.*expo./(expo - 1))./((1+x(2)*expo./(1 - expo)).^2); % 3rd col is derivative wrt x(3)
%J(:,4) = -x(1)*Q.Y*x(3)*Q.b.*expo./(Q.T*x(4)^2.*(x(3)*expo - expo + 1).^2); % 4th col is derivative wrt x(4)

return

