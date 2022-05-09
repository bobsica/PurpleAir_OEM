% ISTENSOR0   True for scalar (tensor 0) variables.
%
%    Determines if a variable is a scalar, that is, a numeric of size 1x1.
%
% FORMAT   bool = istensor0(a)
%        
% OUT   bool   true if matrix, else false.
% IN    a      A variable of any data type.

% 2005-03-16  Created by Patrick Eriksson. 


function bool = istensor0( a )

bool = isnumeric( a )  &&  isscalar(a);
