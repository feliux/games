function life_lex(X)
% LIFE_LEX  Game of Life with populations from the Life Lexicon.
%   life_lex with no arguments reads a random population from lexicon.txt.
%   life_lex(X) with a matrix X starts with the given population.
%   life_lex('name') with a string 'name' obtains the named population.
%
%   The visible universe expands when necessary to encompass the population.
%   See lexicon.txt for the background on hundreds of populations.
%
%   The simulation runs until interrupted by one of these buttons:
%    'lex' restarts with a random population from lexicon.txt.
%    'again' restarts with the same population.
%    'quit' quits.
%
%   Ex:  life_lex([1 1 1; 1 0 0; 0 1 0])
%        life_lex('glider')
%        are the same.

% Cleve Moler
% MathWorks, Inc.
% See Cleve's Corner Blog, Game of Life
%   http://blogs.mathworks.com/cleve/2012/09/03/game-of-life 
% Copyright 2012 The MathWorks, Inc.

%  Initialize.

   if nargin == 0
      X = '';
   end
   name = '';
   buttons = make_buttons;

%  Outer loop over populations.

   while 1
      if ischar(X)
         [X,name] = lexicon_read(X);
      end

%     Save the current population.

      S = X;

%     Inner loop over time steps.

      t = 0;
      while all(getvals(buttons) == 0)
          
%        Expand the universe when the population gets near the edge.

         X = expand(X);   

%        Use spy to plot.  Title shows name and time.

         spy(X)
         title(sprintf('%s %4d',name,t))
         pause(.025)
         t = t+1;
      
         % Whether cells stay alive, die, or generate new cells depends
         % upon how many of their eight possible neighbors are alive.
         % Generate an index vector that avoids the outer edge.

         m = size(X,1);
         p = 2:m-1;

         % Count how many of the eight neighbors are alive.
          
         N = sparse(m,m);
         N(p,p) = X(p-1,p-1) + X(p,p-1) + X(p+1,p-1) + X(p-1,p) + ...
             X(p-1,p+1) + X(p,p+1) + X(p+1,p+1) + X(p+1,p);
        
         % A live cell with two live neighbors, or any cell with
         % three live neigbhors, is alive at the next step.
         
         X = (X & (N == 2)) | (N == 3);

      end  % Inner loop

%     Check buttons to determine what to do next.
    
      if get(buttons.lex,'val') == 1
         X = '';
      elseif get(buttons.again,'val') == 1
         X = S;
      else % get(buttons.quit,'val')
         break
      end
      set([buttons.lex,buttons.again],'val',0)
   end  % Outer loop
   close(gcf)

end  % life_lex

% ------------------------

function X = expand(X)
% Expand the universe if the population is near the edge.
   if all(size(X) == 2) || any(any(X([1:3 end-2:end],:))) || ...
      any(any(X(:,[1:3 end-2:end])))
         edge = 20;
         [m,n] = size(X);
         mb = max(m,n)+2*edge;
         T = X;
         X = sparse(mb,mb);
         X(edge+1:edge+m,edge+1:edge+n) = T;
   end
end  % expand
   
% ------------------------

function buttons = make_buttons
% Make three buttons.
   bigscreen
   buttons.lex = uicontrol('style','tog','str','lex','pos',[20 20 60 20]);
   buttons.again = uicontrol('style','tog','str','again','pos',[100 20 60 20]);
   buttons.quit = uicontrol('style','tog','str','quit','pos',[180 20 60 20]);
end  % make_buttons
   
% ------------------------

function v = getvals(buttons)
% Get values.
   v=[get(buttons.lex,'val') get(buttons.again,'val') get(buttons.quit,'val')];
end  % getvals
