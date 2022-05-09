% PRSTNT_STRUCT   Handles a persistent structure.
%
%    This a help function to handle the setting and extraction of fields
%    values of a structure, defined as persistent in some function. 
%
%    A persistent structure can be used for several purposes. The application
%    in mind here is that the structure contains a number of settings of 
%    global type. How this function works is best described by an example.
%    Let's say that we want to have a function that tells various plotting 
%    function what color map to use, without having that as input to each 
%    function. We create then a function called *cmap* with a local
%    sub-function *cmap_def*:
%
%       function value = cmap( varargin )
%         persistent A
%         [A,value] = prstnt_struct( A, @cmap_def, varargin );
%       
%       function A = cmap_def
%         A.map = 'gray';
%
%    By executing 
%       map = cmap('map'); 
%    we get the present setting for the color map. A new color map is set as 
%       cmap('map','jet');"
%    The existing fields and their values are returned by
%       cmap;
%    The default settings are re-created by:
%       cmap('defaults');
%    That fields exist and are not NaN can be performed as:
%       cmap('require', {'map','dummy'} );
%    where in this case an error will occur as the field 'dummy' does not 
%    exist.
%
%    This is a very simple example. The technique is of course more powerful
%    if more settings variables are involved.
%
%    More fields are added to the structure by adding a definition in the 
%    function setting the default values. It is not allowed to add fields
%    not defined in the default function.
%
%    If the structure will contain large variables it could be worth the
%    effort to copy the code of this function (with some modifications) to 
%    the function where the persistent structure is defined to avoid un-
%    necassary copying of data.
%
% FORMAT   [A,value] = prstnt_struct( A, def_fun, varargin )
%        
% OUT   A          The structure.
%       value      Extracted value (if applicable, otherwise []).
% IN    A          The structure.
%       def_func   Handle to function setting default values for fields.
%       varargin   The input to the calling function.

% 2002-12-14   Created by Patrick Eriksson.


function [A,value] = prstnt_struct( A, def_fun, varargin )


rqre_nargin( 3, nargin );


if isempty( A )
  A = feval( def_fun );
end


%=== As this function is called with a varargin argument, we have to extract
%=== varargin as given to the calling function.
%
varg = varargin{1};


value = [];

switch length( varg )

  case 0
    %
    value = A;

  case 1
    %
    if strcmp( varg{1}, 'defaults' )
      A = feval( def_fun );
 
    else

      if ~isfield( A, varg{1} )
          error('atmlab:input:undefined', ...
            'The field %s is not defined', varg{1}); 
      end

      value = getfield( A, varg{1} );

    end


  case 2

    if strcmp( varg{1}, 'require' )
      for i = 1 : length(varg{2})
        if ~isfield( A, varg{2}{i} )
          error('atmlab:input','\nThe field %s is required.\n\n', varg{2}{i}); 
        end
        if isnan( getfield( A, varg{2}{i} ) )
          error('atmlab:input:undefined' ,...
              'The field %s is required but is NaN.\n\n', varg{2}{i} ); 
        end
      end

    else
      if ~isfield( A, varg{1} )
          error('atmlab:input:undefined' ,...
              'The field %s is not defined.', varg{1} );
      end

      value = getfield( A, varg{1} );
      
      A = setfield( A, varg{1}, varg{2} );

    end

  otherwise
    %
    error('atmlab:input','Too many input arguments.');
end