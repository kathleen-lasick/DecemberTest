
This script subtracts the background from images 
Files must use the data-xy-channel-timpoint naming convention, e.g.:
2018-12-06-xy11c2t011.tif
Path: the path of the folder containing your images e.g. C:\Users\AndrewPaek\Desktop\Movies\2018-12-06\RAW_DATA
Channel: the image channels you wish to background subtract e.g. [2,3]
would do background subtraction on channels 2 and 3
This requires imbackground.m which is part of p53CinemaManual
you can adjust the size of the structuring elements with varargin. The
default is 10 and 100. This size works well for images taken with the 20x
objective
function y = BkgdSubIF (Path, Channels, varargin)
newdir=[Path '\' 'Background_Subtraction'];
mkdir(newdir);
disp(nargin)
if (nargin == 3)
    se1Size = varargin{3};
    
elseif (nargin ==4)
    se1Size = varargin{3};
    se2Size = varargin{4};
else
    se1Size = 10;
    se2Size = 100;
end
dirContents = dir(Path); 

for i = 1:length(dirContents) %Go through every filename
    Going through all file names looking for the extension .TIF, but not
    _thumb. The indeces of these files are storeBkg   d in TifFiles.
    if ((length(dirContents(i).name) > 3) & (strcmp(dirContents(i).name(end-3:end), '.TIF') | strcmp(dirContents(i).name(end-3:end), '.tif'))  & isempty(strfind(dirContents(i).name,'_thumb')))
        
        temp = regexp(dirContents(i).name,'(.+)well(.+)-c(\d+).*\.tif', 'tokens','once');
        if sum((str2num(temp{3}) == Channels)) %Check to see if this channel is included
            fname = [Path '\' dirContents(i).name];
             Temp = double(imread(fname));
             Temp = imread(fname);
        
             Temp = medfilt2(Temp, [2,2]);
             Temp = imbackground(Temp, 10, 100);
             NewFileName = [newdir '\' dirContents(i).name];
             imwrite(Temp,NewFileName);
        end
            
    
    end
end