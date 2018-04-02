function plotIT2(xUMF,uUMF,xLMF,uLMF,domain)

%
% plotIT2(xUMF,uUMF,xLMF,uLMF,domain)
%
% function to plot an IT2 FS in a specified domain
%
% Dongrui WU (dongruiw@usc.edu), 3/24/2009
%
% IF there are more than two inputs, the function implements
% plotIT2(xUMF,uUMF,xLMF,uLMF,domain), where
% xUMF: x-coordinates of the UMF
% uUMF: u-coordinates of the UMF
% xLMF: x-coordinates of the LMF
% uLMF: u-coordinates of the LMF
% domain: [l, r], the universe of discourse. Default [min(xUMF), max(xUMF)].
%
% IF there are one or two inputs, the function implements
% plotIT2(A,domain), where
% A: nine-parameter representation of an IT2 FS A
% domain: [l, r], the universe of discourse. Default [A(1), A(4)]

if ~find(nargin==[1 2 4 5])
    error('The number of inputs must be 1, 2, 4 or 5.');
end

if nargin>2
    if length(xUMF)~=length(uUMF)
        error('xUMF and uUMF must have the same length.');
    end
    if length(xLMF)~=length(uLMF)
        error('xLMF and uLMF must have the same length.');
    end
    if nargin==4
        domain=[min(xUMF), max(xUMF)];
    end
elseif nargin==1
    A=xUMF;
    domain=[A(1), A(4)];
    xUMF=linspace(domain(1),domain(2),100);
    xLMF=xUMF;
    uUMF=mg(xUMF,A(1:4),[0 1 1 0]);
    uLMF=mg(xLMF,A(5:8),[0 A([9 9]) 0]);
elseif nargin==2
    A=xUMF;
    domain=uUMF;
    xUMF=linspace(domain(1),domain(2),100);
    xLMF=xUMF;
    uUMF=mg(xUMF,A(1:4),[0 1 1 0]);
    uLMF=mg(xLMF,A(5:8),[0 A([9 9]) 0]);
end

fill([xUMF xLMF(end:-1:1)],[uUMF uLMF(end:-1:1)],[0.9 0.9 0.9]);
hold on
plot([xUMF xLMF(end:-1:1)],[uUMF uLMF(end:-1:1)],'k-','linewidth',1.2);
if nargin==4
    domain=[min(xUMF), max(xUMF)];
end
axis([domain 0 1.1]);

