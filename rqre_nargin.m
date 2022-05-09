% RQRE_NARGIN   Checks if minimum number of input arguments is reached
%
%    If the required minimum number of input arguments is three, the
%    function should normally be used as:
%
%        rqre_nargin( 3, nargin );
%
%    An error is issued if the requirement not is met (in contrast to
%    nargchk that just returns an error message).
%
% FORMAT   rqre_nargin( nreq, narg )
%        
% IN    nreq   Number of required arguments.
%       narg   Number of input arguments. 

% 2005-03-16   Created by Patrick Eriksson.


function rqre_nargin( nreq, narg )
                                                                            %&%
                                                                            %&%
%- Checks                                                                   %&%
%                                                                           %&%
assert( istensor0( nreq )  &&  nreq >= 0 );                                 %&%
assert( istensor0( narg )  &&  narg >= 0 );                                 %&%


if narg < nreq
  [st,i] = dbstack;  
  error( 'The function *%s* requires at least %d arguments.', ...
                                                          st(i+1).name, nreq );
end  