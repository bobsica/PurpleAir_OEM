% QCHECK   Ensures that a structure only contains recognised fields.
%
%    The function compares the fields of *Q* with the structure provided by
%    *qfun*. The argument *qfun* shall be a pointer to a function 
%    (e.g. @qdefault) that has a structure as first output argument and
%    works without input arguments. This function should normally be a 
%    function setting default values for all recognised fields. 
%
%    This function is complemented with *qinfo*. If the functionality
%    provided by these functions will be used, *qfun* shall have as
%    second output argument an information structure. That is:
%      [Q,INFO] = qdefaults;
%    where the INFO structure shall have the same fields as Q, and each
%    field of INFO holds a basic string with a description of the field.
%
%    For a practical example, see e.g. the function *qarts*. Test e.g.
%      more on
%      qinfo(@qarts,'all');
%    or 
%      qinfo(@qarts,'W*');
%
% FORMAT   qcheck( qfun, Q )
%        
% IN    qfun   Pointer to function providing default structure.
%       Q      Structure to check.

% 2004-09-07   Created by Patrick Eriksson.


function qcheck( qfun, Q )


Qref = feval( qfun );

f1 = fieldnames( Q ); 
f2 = fieldnames( Qref ); 

ok = 1;

for i = 1 : length(f2)
  if ~isfield( Q, f2{i} )
    fprintf('The field %s is missing.\n', f2{i} );
    ok = 0;
  end
end


if length(f1) ~= length(f2)  | ~ok
  for i = 1 : length(f1)
    if ~isfield( Qref, f1{i} )
      fprintf('The field %s is not defined.\n', f1{i} );
      ok = 0;
    end
  end
end


if ~ok
  fprintf('\n');
  error('See above.');
end