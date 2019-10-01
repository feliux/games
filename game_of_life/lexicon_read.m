function [X,fullname] = lexicon_read(name)
% LEXICON_READ  Obtain a named population from lexicon.txt.
%  [X,fullname] = lexicon_read(name) obtains the named population.
%  With no arguments, or an empty string, a random population is returned.
%  The lexicon is obtained from the Web site if a local copy does not exist.
%  The name may be abbreviated to a sufficient number of leading characters.
%    ex: [X,fullname] = lexicon_read('Gosper') 

% Cleve Moler
% MathWorks, Inc.
% See Cleve's Corner Blog, Game of Life
%   http://blogs.mathworks.com/cleve/2012/09/03/game-of-life 
% Copyright 2012 The MathWorks, Inc.

   persistent names
   
   % If necessary download lexicon.txt.
   if ~exist('lexicon.txt')
      url = 'http://www.argentum.freeserve.co.uk/lex_asc.zip';
      files = unzip(url);
      delete(files{1:3})
      % files{4} is lexicoon.txt.
   end

   % Open lexicon.txt.
   lexfid = fopen('lexicon.txt');
   if lexfid == -1
      error('Sorry, cannot find lexicon.txt.')
   end
   
   % If required, find all names and pick a random one.
   if nargin == 0 || isempty(name)
      if isempty(names)
         names = findnames(lexfid);
      end
      k = ceil(rand*length(names));
      name = names{k};
   end
   
   % Look for a line beginning with colon followed by name.
   name = [':' name];
   k = 1;
   while ~feof(lexfid)
      line = fgetl(lexfid);
      if strncmpi(name,line,length(name))
         break
      end
   end
   if feof(lexfid) 
      error(['Sorry, cannot find ' name(2:end) ' in lexicon.txt.']) 
   end
   
   % Get the full name.
   e = find(line==':',2);
   fullname = line(2:e(2)-1);
   
   % Look a line starting with a tab, followed by '.' or '*'.
   tab = char(9);
   task = [tab '*'];
   tdot = [tab '.'];
   while isempty(line) || (any(line(1:2) ~= task) && any(line(1:2) ~= tdot))
      line = fgetl(lexfid);
   end
   
   % Form sparse matrix by rows from '.' and '*'.
   S = sparse(0,0);
   m = 0;
   while ~isempty(line) && (line(1) == tab)
      row = sparse(line(2:end) == '*');
      m = m+1;
      n = length(row);
      S(m,n) = 0;
      S(m,1:n) = row;
      line = fgetl(lexfid);
   end
   
   % Make the result square.
   [m,n] = size(S);
   p = max(m,n);
   m0 = floor((p-m)/2);
   n0 = floor((p-n)/2);
   X = sparse(p,p);
   X(m0+1:m0+m,n0+1:n0+n) = S;

   fclose(lexfid);

end % lexicon_read

% ------------------------------

function names = findnames(lexfid);
% Find all the names in the lexicon that have associated matrices.
% Matrix lines begin with a tab followed by an asterisk or dot.
% Names are enclosed in colons, :name:.
% 866 lines in lexicon.txt begin with a colon.
% 447 of them are followed by matrices.
% The others are just descriptive.
% Activate the fprintf statement below to see the list of names.

   names = cell(447,1);
   k = 0;
   tab = char(9);
   skip = true;
   while ~feof(lexfid)
      line = fgetl(lexfid);
      if isempty(line) || (line(1) == tab && skip)
         continue
      elseif line(1) == ':'
         % A potential name.
         e = find(line==':',2);
         x = line(2:e(2)-1);
         skip = false;
      elseif line(1) == tab && (line(2) == '*' || line(2) == '.') && ~skip
         % Accept the most recent name.
         k = k+1;
         names{k} = x;
         skip = true;
         % fprintf('%3d %s\n',k,x)
      end
   end
   frewind(lexfid);
end %findnames
