% This function produces a vector of jittered ISIs distributed according to
% the exponential function (a la Wager & Nichols).
%
% Input: mean jitter time (in s), length of output (i.e. number of
% ISIs needed), and whether to sample from a gamma distribution with a long
% tail (0 if not [default], 1 if so)
% 
% x = jitter(mean, length, gamma)
% 
% Produces a vector (x) with lenght of "length" and mean of "mean".

function x = jitter(mn, length, varargin)

% Figure out if you want the gamma distribution or not
if nargin==2
    gFlag=0; 
elseif nargin==3
    gFlag=varargin{1};
end

switch gFlag
    case 0  % truncated distribution
        x = zeros(length,1);	% Initialize
        
        % Call the supplementary function, jitter_one, in a loop of length "length"
        for i = 1:length
            x(i) = jitter_one(mn);
        end

        %fprintf('The mean ISI is %1.2f seconds.  (Range = %1.2fs to %1.fs).\n\n',mean(x), min(x), max(x));
        
    case 1  % Gamma distribution
        U = rand(length,mn);
        x = sum( -log(U), 2);
        
        %fprintf('The mean ISI is %1.2f seconds.  (Range = %1.2fs to %1.fs).\n\n',mean(x), min(x), max(x));
end
end


% A supplementary function that produces a single jitter event randomly
% from an empirical exponential distribution

function y = jitter_one(mn)

y = [];						% Initialize
const = (mn / 395.5989);	% Empirical constant

loc = unifrnd(0,1);			% Random uniform (0-1) location

% The jitter time percentiles...
if (loc<.22),       y = 300*const;
elseif (loc<.55),   y = 350*const;
elseif (loc<.81),   y = 400*const;
elseif (loc<.91),   y = 500*const;
elseif (loc<.97),   y = 600*const;
else                y = 800*const;
end
 
end