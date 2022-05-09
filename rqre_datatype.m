% RQRE_DATATYPE   Checks if variable is of any expected data types
%
%    The input argument *funchandles* is a single or a cell array of handles to
%    functions performing type checking, such as @isnumeric. For example, the
%    following will generate an error message:
%       a = 'a';
%       rqre_datatype( a, {@isnumeric,@iscell} )
%
%    Issues an error if criterion not fulfilled. This error assumes that all
%    functions are named as isxxxx, where xxxx is the name of the data type.
%
%    Use *<a href="matlab:help rqre_alltypes">rqre_alltypes</a>* to check if a combination of type checks is fullfilled.
%
% FORMAT   rqre_datatype( a, funchandles [,nonstdname] )
%        
% IN    a             Variable to check.
%       funchandles   One or several handles to type checking functions.
% OPT   nonstdname    Name of variable to use in error message. Default is
%                     to use the function *inputname* to determine the
%                     variable name.

% 2005-03-16   Created by Patrick Eriksson.


function rqre_datatype( a, funchandles, nonstdname )
 
  
%- A single function handle
%
if isa( funchandles, 'function_handle' )
  if funchandles(a)
    return                     % Return, a match has been found
  end
  % Repack for error message
  funchandles = { funchandles };  

  
%- A cell array of function handles (?)
%
else
                                                                            %&%
  assert( all( cellfun( 'isclass', funchandles, 'function_handle' ) ), ...  %&%
        'The argument *funchandles* does not contain function handles.' );  %&%
  %                                                                         %&%
  if ~isvector( funchandles )                                               %&%
    error( 'The argument *funchandles* must be a vector (row or column).' );%&%
  end                                                                       %&%

  for i = 1:length(funchandles)
    if funchandles{i}(a)
      return                     % Return, a match has been found
    end
  end
end


%- Error messages
%
if nargin < 3
  vname = sprintf( 'The variable *%s*', inputname(1) );
else
  assert( ischar( nonstdname )  &&  ~isempty( nonstdname ) );               %&%
  vname = nonstdname;
end

if length(funchandles) == 1
  s = func2str( funchandles{1} );
  error( '%s must be %s.', vname, s(3:end) );
else
  fprintf('Accepted data types are\n');
  for i = 1:length(funchandles)
    s = func2str( funchandles{i} );
    fprintf('   %s\n', s(3:end) );
  end
  error( sprintf( '%s is not of any accepted types, listed above.', vname ) );
end
