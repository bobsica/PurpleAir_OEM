% ISWHOLE   True for whole numbers (integers).
%
%    Determines if all the elements of an array are integers.
%
%    Note that this function differs from *isinteger*, which is a type test. 
%    Here also double numbers are accapted, as long they have no decimal part.
%
% FORMAT   bool = iswhole(n)
%        
% OUT   bool   true if integer, else false.
% IN    n      A variable of any valid numeric data type.

% 2005-11-22  Renamed to avoid clash in newer Matlab versions (PE).
% 2002-12-10  Adapted to Atmlab from arts/ami.
% 2000-12-18  Created by Patrick Eriksson. 


function bool = iswhole(n)

bool = isnumeric(n)  &&  all( n(:) - round(n(:)) == 0 );
