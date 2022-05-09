% ATMLAB   Handling of Atmlab settings.
%
%   This function is based on *prstnt_struct* and for general help see 
%   the on-line help for that function. 
%
%   Existing fields, and possible settings, are listed below. 
%
%   For adding personal settings at startup, see the file CONFIGURE. To 
%   add or change settings after startup, follow the example below. 
%
%   To check all present settings
%      atmlab;
%
%   A specific setting is obtained as
%      value = atmlab( 'FMODEL_NAME' );
%
%   To set a field to a specic value
%      atmlab( 'FMODEL_NAME', 'arts' );
%
%   To set all fields to default
%      atmlab( 'defaults' );
%
% FORMAT   value = atmlab( [varargin] )
%        
% OUT   value      Setting, if a field is selected. See further 
%                  *prstnt_struct*.
% OPT   varargin   Field, field and setting or any option supported by
%                  *prstnt_struct*.
%
%----------------------------------------------------------------------------
% ARTS_INCLUDES
%
% Path to main folder for ARTS include files. 
% For example '/home/patrick/ARTS/arts2/include'.
%----------------------------------------------------------------------------
% ARTS_PATH
%
% Path to executable for ARTS. For example '/home/patrick/ARTS/arts2/src/arts'.
%----------------------------------------------------------------------------
% ARTS_XMLDATA_PATH
%
% Path to main folder of arts-xml-data. 
% The arts-xml-data is a compilation of useful data for ARTS calculations.
% Contact the ARTS team if you want access to the data. The data is used
% as input for ARTS example/utility functions. 
%----------------------------------------------------------------------------
% ATMLAB_DATA_PATH
%
% Path to main directory of atmlab-data
% atmlab-data is a compilation of useful data for various atmlab tasks.
% It is available in the atmlab-data/trunk directory of the rt svn repo.
%--------------------------------------------------------------------------
% ATMLAB_PATH
%
% Path to main directory of atmlab.
% Can be used by the user to override automatic determination of this file,
% or is otherwise set by initialisation functions for other functions to
% use.
%----------------------------------------------------------------------------
% DEBUG
%
% Flag to set to simplify debugging. No overall effect, but this flag is
% recognised by some functions. For example, if this flag is set the temporary
% work folders are not removed, to make it possible to check the content
% in these folders.
%----------------------------------------------------------------------------
% ERR
%
% Stream to log error messages to. Used by some subsystems.
%----------------------------------------------------------------------------
% FMODEL_VERBOSITY
%
% Verbosity of forward model, if such a feature is supported. If field is
% is empty, this is interpreted as no verbosity. The forward models work as:
%   ARTS (both versions):
%     A number between 0 and 3, where 3 means highest level of verbosity.
%----------------------------------------------------------------------------
% LEGACY_MODE
%
% Include deprecated functions and settings. Used by some subsystems.
%----------------------------------------------------------------------------
% OUT
%
% Stream to log ordinary messages to. Used by some subsystems.
%----------------------------------------------------------------------------
% PYTHON
%
% Path to Python interpreter to use in relevant situations.
%----------------------------------------------------------------------------
% RAND_STATE
%
% Initialisation of random states (for rand and randn). Either NaN or an
% integer. If set to NaN, a semi-random state is generated. Otherwise the
% specified value is used as state for both rand and randn.
% A new state is initialised directly by this function.
%----------------------------------------------------------------------------
% SITE
%
% Location, system, e.g. Kiruna, Chalmers. If there is a directory
% site-specific/SITE, this will be used to initialise default values for
% the settings for some subsystems (for example, datasets will 'know' where to
% find data).
%----------------------------------------------------------------------------
% SCREEN_WIDTH
% 
% The width, in number of characters, of the Matlab window.
% Used by the function *out* to make a frame around screen output.
%----------------------------------------------------------------------------
% STRICT_ASSERT
% 
% Some parts of atmlab performs quite strict checks of input arguments and
% data. Such asserts and checks can in some cases take a significant fraction
% of the calculation time in a function (or even dominate the time) and, to
% allow faster calculations, some functions use this flag to possibly
% deactivate the checks. Default is true and the checks are performed. If you
% have a stable set-up, you can set this field to false and potentially improve
% the calculation speed. That is, if you are sure that the assertions
% are not needed (only applies to assertions in "if amtlab('STRICT_ASSERT')"
% environments), then set atmlab('STRICT_ASSERT')=false;
%----------------------------------------------------------------------------
% VERBOSITY
% 
% The verbosity of Atmlab functions.  
% Functions writing to the screen set a report level for each output. If the
% the set report level is higher than VERBOSITY, the output is ignored.
% Output obeying this setting is most easily produced with the function *out*.
% Functions can also use VERBOSITY to decide if figures shall be produced
% (which is most easily checked by using *out*).
%----------------------------------------------------------------------------
% WORK_AREA
% 
% A folder to be used for calculations outside Matlab. For each calculation
% session, a temporary folder is created in the given folder. Atmlab tries to
% keep the given folder clean by removing the temporary folders when ready, but
% if there is a crash the temporary folder can occasionaly be left. The
% temporary folders are not re-used and it can be a good idea to now and then
% remove old temporary folders. 
% The full path shall be given. A normal choice for work area on Unix type
% platforms is '/tmp'. The work area is primarily used for forward model
% calculations, but there could be other applications.
% ----------------------------------------------------------------------------

% 2003-07-06   Created by Patrick Eriksson.


function value = atmlab( varargin )
            
persistent A

[A,value] = prstnt_struct( A, @atmlab_defs, varargin );


%- Some settings require direct action
  
if length(varargin) == 2

  switch varargin{1}
    
   case 'RAND_STATE'
    %
    rand_state = varargin{2}
    %
    if isnan( rand_state )
      %- Create random state. Add window number to get different states for
      %  different matlab runs (works only for linux).
      %
      nr = getenv('WINDOWID');
      if isempty(nr)
        nr = 0;
      else
        nr = str2double( nr );
      end
      %
      rand( 'state', sum(100*clock) + nr );
      randn( 'state', sum(100*clock) + nr );
     
    else
      rand( 'state', rand_state );
      randn( 'state', rand_state );
    end

   case 'SITE'
    %
    addsite;

    case {'ATMLAB_DATA_PATH', 'ARTS_XMLDATA_PATH', 'ARTS_INCLUDES', ...
          'ATMLAB_PATH'}
      %
      if ~exist(varargin{2}, 'dir')
        warning('atmlab:dirnotfound', ['Warning: ' varargin{1} ' set to ' ...
            varargin{2} ' which is not found or not a directory']);
      end

    case {'ARTS_PATH', 'PYTHON'}
      %
      ind = strfind( varargin{2}, '-' );
      if isempty(ind)
        name = varargin{2};
      else
        name = varargin{2}(1:ind(1)-1);
      end
      if ~exist(deblank(name), 'file')
        warning('atmlab:filenotfound', ['Warning: ' varargin{1} ' set to ' ...
            varargin{2} ' which is not found']);
      end
    
  end
end
%
return

end
  
%---------------------------------------------------------------------------
function A = atmlab_defs

A.ARTS_INCLUDES     = NaN;
A.ARTS_PATH         = NaN;
A.ARTS_XMLDATA_PATH = NaN;
A.ATMLAB_PATH       = NaN;
A.ATMLAB_DATA_PATH  = NaN;
A.DEBUG             = false;
A.ERR               = 2;
A.FMODEL_VERBOSITY  = 0;
A.LEGACY_MODE       = false;
A.OUT               = 1;
[u,X] = system('type -p python');
A.PYTHON            = strtrim(X);
A.RAND_STATE        = NaN;
A.SCREEN_WIDTH      = 70;
A.SITE              = NaN;
A.STRICT_ASSERT     = true;
A.VERBOSITY         = 1;
A.WORK_AREA         = tempdir();
A.STRICT_ASSERT     = true;

end
