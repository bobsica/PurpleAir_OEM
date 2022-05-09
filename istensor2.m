% ISTENSOR2   True for matrix (tensor 2) variables.
%
%    Determines if a variable is a matrix, that is, a numeric of size mxn 
%    where n or m (or both) can be equal to 1.
%
% FORMAT   bool = istensor2(a)
%        
% OUT   bool   true if matrix, else false.
% IN    a      A variable of any data type.

% 2005-03-16  Created by Patrick Eriksson. 


function bool = istensor2( a )

bool = isnumeric( a )  &&  dimens(a) <= 2;


