function im_hatch = applyhatch_plus(h,patterns,colorlist,dpi,hatchsc)
%APPLYHATCH_PLUS Apply hatched patterns to a figure
%  im_hatch = applyhatch_plus(h,patterns,colorlist,dpi,hatchsc)
%
%  APPLYHATCH(H,PATTERNS) creates a new figure from the figure H by
%  replacing distinct colors in H with the black and white
%  patterns in PATTERNS. The format for PATTERNS can be
%    a string of the characters '/', '\', '|', '-', '+', 'x', '.'
%    a cell array of matrices of zeros (white) and ones (black)
%
%  APPLYHATCH(H,PATTERNS,COLORS) maps the colors in the n by 3
%  matrix COLORS to PATTERNS. Each row of COLORS specifies an RGB
%  color value.
%
%  Note this function makes a bitmap image of H and so is limited
%  to bitmap output.
%
%  Example 1:
%    bar(rand(3,4));
%    im_hatch = applyhatch_plus(gcf,'\-x.',150);
%    imwrite(im_hatch,'im_hatch.tiff','tiff')
%
%  Example 2:
%    colormap(cool(6));
%    pie(rand(6,1));
%    legend('Jan','Feb','Mar','Apr','May','Jun');
%    im_hatch = applyhatch_plus(gcf,'|-+.\/',cool(6),150,4);
%    imwrite(im_hatch,'im_hatch.tiff','tiff')
%
% Modification of APPLYHATCH to allow higher resolution output
% Modified Brian FG Katz    8-aout-03
%  im_hatch = applyhatch_plus(h,patterns,colorlist,dpi,hatchsc)
%
%   input   DPI         allows specification of bitmap resolution, making plot resolution
%                       better for printing
%           HATCHSC     multiplier for hatch scale to increase size of pattern for better operation
%                       at higher resolutions
%                       default [] uses screen resolution as in APPLYHATCH
%   output  IM_HATCH    RGB bitmap matrix of new figure
%                       use IMWRITE to output in desired format
%
%  See also: APPLYHATCH, MAKEHATCH, MAKEHATCH_PLUS

%  By Ben Hinkle, bhinkle@mathworks.com
%  This code is in the public domain. 
  
oldppmode = get(h,'paperpositionmode');
oldunits = get(h,'units');
oldcolor = get(h,'color');
oldpos = get(h,'position');
set(h,'paperpositionmode','auto');
set(h,'units','pixels');
set(h,'color',[1 1 1]);
figsize = get(h,'position');

if nargin < 5; hatchsc = 1      ; end
if nargin < 4; dpi = 0          ; end     % defaults to screen resolution
if nargin < 3; colorlist = []   ; end

bits = hardcopy(h,'-dzbuffer',['-r' num2str(dpi)]);
set(h,'paperpositionmode',oldppmode);
set(h,'color',oldcolor);

bwidth = size(bits,2);
bheight = size(bits,1);
bsize = bwidth * bheight;
if ~isempty(colorlist)
  colorlist = uint8(255*colorlist);
  [colors,colori] = nextnonbw(0,colorlist,bits);
else
  colors = (bits(:,:,1) ~= bits(:,:,2)) | ...
	   (bits(:,:,1) ~= bits(:,:,3));
end
pati = 1;
colorind = find(colors);
while ~isempty(colorind)
  colorval(1) = bits(colorind(1));
  colorval(2) = bits(colorind(1)+bsize);
  colorval(3) = bits(colorind(1)+2*bsize);
  if iscell(patterns)
    pattern = patterns{pati};
  elseif isa(patterns,'char')
    pattern = makehatch_plus(patterns(pati),6*hatchsc);
  else
    pattern = patterns;
  end
  pattern = uint8(255*(1-pattern));
  pheight = size(pattern,2);
  pwidth = size(pattern,1);
  ratioh = ceil(bheight/pheight);
  ratiow = ceil(bwidth/pwidth);
  bigpattern = repmat(pattern,[ratioh ratiow]);
  if ratioh*pheight > bheight
    bigpattern(bheight+1:end,:) = [];
  end
  if ratiow*pwidth > bwidth
    bigpattern(:,bwidth+1:end) = [];
  end
  bigpattern = repmat(bigpattern,[1 1 3]);
  color = (bits(:,:,1) == colorval(1)) & ...
	  (bits(:,:,2) == colorval(2)) & ...
	  (bits(:,:,3) == colorval(3));
  color = repmat(color,[1 1 3]);
  bits(color) = bigpattern(color);
  if ~isempty(colorlist)
    [colors,colori] = nextnonbw(colori,colorlist,bits);
  else
    colors = (bits(:,:,1) ~= bits(:,:,2)) | ...
	     (bits(:,:,1) ~= bits(:,:,3));
  end
  colorind = find(colors);
  pati = (pati + 1);
  if pati > length(patterns)
    pati = 1;
  end
end

newfig = figure('units','pixels','visible','off');
imaxes = axes('parent',newfig,'units','pixels');
im = image(bits,'parent',imaxes);
%fpos = get(newfig,'position');
%set(newfig,'position',[fpos(1:2) figsize(3) figsize(4)+1]);
set(newfig,'position',oldpos)
set(imaxes,'position',[0 0 figsize(3) figsize(4)+1],'visible','off');
set(newfig,'visible','on');

set(newfig,'units','normalized');
set(imaxes,'units','normalized');
set(imaxes,'DataAspectRatio',[1 1 1],'DataAspectRatioMode','manual');


if nargout == 1,    im_hatch = bits; end

function [colors,out] = nextnonbw(ind,colorlist,bits)
out = ind+1;
colors = [];
while out <= size(colorlist,1)
  if isequal(colorlist(out,:),[255 255 255]) | ...
	isequal(colorlist(out,:),[0 0 0])
    out = out+1;
  else
    colors = (colorlist(out,1) == bits(:,:,1)) & ...
	     (colorlist(out,2) == bits(:,:,2)) & ...
	     (colorlist(out,3) == bits(:,:,3));
    return
  end
end