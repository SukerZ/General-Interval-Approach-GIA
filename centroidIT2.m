function [CA, CAl, CAr]=centroidIT2(A)

%
% [CA, CAl, CAr]=centroidIT2(A)
%
% To compute the centroid of an IT2 FS, which is defined by nine
% parameters (a, b, c, d, e, f, g, i, h) shown in Fig. 1 of Readme.doc. 
%
% D. Wu and J.M. Mendel, "Uncertainty measures for interval type-2 fuzzy
% set," Information Sciences, 177, pp. 5378-5393, 2007.
%
% Dongrui WU (dongruiw@usc.edu), 3/24/2009
%
% A: an IT2 FS represented by 9 parameters.
% CA: center of centroid of A
% CAl: left bound of the centroid
% CAr: right bound of the centroid

if length(A)~=9
    error('The input vector must be a 9-point representation of an IT2 FS.');
end

Xs=linspace(A(1),A(4),100);
UMF=mg(Xs,A(1:4),[0 1 1 0]);
LMF=mg(Xs,A(5:8),[0 A(9) A(9) 0]);
CAl=EKM(Xs,LMF,UMF,-1);
CAr=EKM(Xs,LMF,UMF,1);
CA=(CAl+CAr)/2;
