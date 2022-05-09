% RQRE_IN_RANGE   Require that a variable is inside a range
%
%    Issues an error if criterion not fulfilled.
%
%    The check considers all values and *a* can be a matrix or a higher order
%    tensor.
%
% FORMAT   rqre_in_range( a, [, lowlim, highlim, nonstdname ] )
%        
% IN    a             Variable value. Can be of any numeric type.
% OPT   lowlim        It is required that a >= lowlim. Default is -Inf.
%       highlim       It is required that a >= highlim. Default is Inf.
%       nonstdname    Name of variable to use in error message. Default is
%                     to use the function *inputname* to determine the
%                     variable name.

% 2004-09-07   Created by Patrick Eriksson.


function rqre_in_range( a, lowlim, highlim, nonstdname )

if nargin < 2  ||  isempty( lowlim )
  lowlim = -Inf;
end
if nargin < 3  ||  isempty( highlim )
  highlim = Inf;  
end
                                                                            %&%
assert( isnumeric( a ) );                                                   %&%
assert( istensor0( lowlim ) );                                              %&%
assert( istensor0( highlim ) );                                             %&%

if any( a(:) < lowlim )  ||  any( a(:) > highlim )
  if nargin < 4  ||  isempty(nonstdname)
    vname = sprintf( 'The variable *%s*', inputname(1) );
  else
    assert( ischar( nonstdname ) );
    vname = sprintf( '%s', nonstdname );
  end
  error(['atmlab:' mfilename ':invalid'], ...
      '%s is required to be in the range [%d,%d].', vname, lowlim, highlim );
end

end
