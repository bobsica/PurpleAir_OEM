% DIMENS  Effective dimension of data
%
%    As *ndims*, but returns 1 for a column vector and 0 for scalar values.
%
% FORMAT   n = dimens(A)
%        
% OUT   n   Dimensionality.
% IN    A   Data (no type check is performed).

% 2006-08-2   Created by Patrick Eriksson.


function n = dimens(A)

n = max( [ 0 find( size(A) > 1 ) ] );
