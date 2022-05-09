% OPTARGS   A help function to handle optional arguments
%
%    The function provides a simple way to define default values for function
%    input. Only the cases of the type somefun(a,b,c,d) are handled. Use e.g.
%    Matlab's inputParser for functions using parameter-value pairs (such as
%    ('LineWidth',2) for plot).
%    
%    The length of *defaults* determines the number of optional arguments. The
%    output is a merge of *userin* and *defaults*. Both these variables are cell
%    vectors. Data are taken from *defaults* where *userin* has [] or is lacking
%    a value. For example,
%       [a,b] = optargs( {1,[]}, {0,'a'} )
%    gives a=1 and b='a'. However, the normal usage of the function should
%    be to set *userin* to *varargin*:
%       [a,b] = optargs( varargin, {0,'a'} )
%
% FORMAT   varargout = optargs( userin, defaults )
%        
% OUT   varargout  Merged input arguments.  
% IN    userin     User provided optional settings (captured by *varargin*).
%       defaults   Cell array with default values for optional arguments. 

% 2010-01-03   Created by Patrick Eriksson.


function varargout = optargs( userin, defaults )

  
%- Lengths
%
nin = length( userin );
nd  = length( defaults );
                                                                            %&%
                                                                            %&%
%- Checks                                                                   %&%
%                                                                           %&%
assert( iscell( userin ) );                                                 %&%
assert( iscell( defaults ) );                                               %&%
assert( nargout == nd );                                                    %&%
%
if nin > nd
  [st,i] = dbstack; 
  error( 'Too many input arguments for *%s*.', st(i+1).name );
end 


%- Set everything to default
%
varargout = defaults;


%- Include user settings
%
for i =1:nin
  if ~isempty( userin{i} )
    varargout{i} = userin{i};
  end
end
