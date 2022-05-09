% ISBOOLEAN   True for boolean variables.
%
%    Determines if a variable is a boolean, that is, a logical with size 1x1.
%
% FORMAT   bool = isboolean(a)
%        
% OUT   bool   true if boolean, else false.
% IN    a      A variable of any data type.

% 2010-01-03  Created by Patrick Eriksson. 


function bool = isboolean( a )

bool = islogical( a )  &&  max(size(a)) == 1;


