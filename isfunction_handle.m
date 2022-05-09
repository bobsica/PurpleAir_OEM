% ISFUNCTION_HANDLE   True for a function handle.
%
%    Determines if a variable is a (single) function handle
%
% FORMAT   bool = isfunction_handle(a)
%        
% OUT   bool   true if function handle, else false.
% IN    a      A variable of any data type.

% 2010-01-03  Created by Patrick Eriksson. 


function bool = isfunction_handle( a )

bool = isa( a, 'function_handle' );


