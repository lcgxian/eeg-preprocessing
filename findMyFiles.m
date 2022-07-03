function [fileList] = findMyFiles(folderName,fileType)

% check  nargin
if nargin == 0
    folderName = uigetdir('选择包含文件的文件夹');
    fileType = inputdlg('文件名特征值，如preSD,postSD等');
    fileType = fileType{1,1}; % extract str
end
    


fileInfo = dir(folderName);
isDir = [fileInfo.isdir];

% get the file included in the folder
folderInfo = dir(folderName);
fileName = {folderInfo(~isDir).name};
totalFileNum = length(fileName);
validFileName = {};
for k = 1:totalFileNum
    if contains(fileName{k},fileType)
        validFileName = [validFileName,fileName(k)];
    end
end
validFileNum = length(validFileName);
fileList = cell(validFileNum,1);
for i = 1:validFileNum
    fileList{i,1} = fullfile(folderName,validFileName{i});
end

% get the file among the subfolders
if find(isDir) ~= 0
    dirList = {fileInfo(isDir).name}';% get the directory list among the selected order.
    dirIndex = ~ismember(dirList,{'.','..'}); % remove the "./ and ../"
    validDirList = cellfun(@(x)fullfile(folderName,x),dirList(dirIndex),'UniformOutput',false);
    for j = 1:length(validDirList)
        fileList = [fileList;findMyFiles(validDirList{j,1},fileType)];
    end
    
end

end
