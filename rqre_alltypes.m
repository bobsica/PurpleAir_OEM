% RQRE_ALLTYPES   Checks if a variable matches a combination of type checks
%
%    The input argument *funchandles* is a cell array of handles to
%    functions performing type checking. For example, the following  
%    is a check if *a* is a scalar integer number:
%       rqre_alltypes( a, {@istensor0,@iswhole} )
%
%    Issues an error if criterion not fulfilled. This error assumes that all
%    functions are named as isxxxx, where xxxx is the name of the data type.
%
%    Use *<a href="matlab:help rqre_datatype">rqre_datatype</a>* for check with respect to a single or one of several
%    types.
%
% FORMAT   rqre_alltypes( a, funchandles [,nonstdname] )
%        
% IN    a             Variable to check.
%       funchandles   Handles to type checking functions.
% OPT   nonstdname    Name of variable to use in error message. Default is
%                     to use the function *inputname* to determine the
%                     variable name.

% 2005-03-16   Created by Patrick Eriksson.


function rqre_alltypes( a, funchandles, nonstdname )
                                                                            %&%
                                                                            %&%
assert( all( cellfun( 'isclass', funchandles, 'function_handle' ) ), ...    %&%
      'The argument *funchandles* does not contain function handles.' );    %&%
%                                                                           %&%
if ~isvector( funchandles )                                                 %&%
  error( 'The argument *funchandles* must be a vector (row or column).' );  %&%
end                                                                         %&%
%                                                                           %&%
if length( funchandles ) < 2                                                %&%
  error( 'Use *rqre_datetype* for match with single data types.' );         %&%
end                                                                         %&%


%- Perform check
%  
all_ok = true;
%
for i = 1:length(funchandles)
  if ~funchandles{i}(a)
    all_ok = false;
    break                     
  end
end
%
if all_ok
  return
end


%- Error messages
%
if nargin < 3
  vname = sprintf( 'The variable *%s*', inputname(1) );
else
  assert( ischar( nonstdname )  &&  ~isempty( nonstdname ) );               %&%
  vname = nonstdname;
end
%
fprintf('Expected data type combination is\n');
for i = 1:length(funchandles)
  s = func2str( funchandles{i} );
  fprintf('   %s\n', s(3:end) );
end
error( '%s fails to match one or several of type checks, listed above.', vname );
