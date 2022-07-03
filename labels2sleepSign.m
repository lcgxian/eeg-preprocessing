% 将带有小鼠睡眠状态的labels（*_labels.mat,1 * N向量），写入到原始EEG文件（txt）
% 用于人工校正自动标记结果
% 需要将对应小鼠的原始数据文件，*_preSD.txt，*_preSD_sliced.txt,*_labels.mat
% 放在同一个文件夹中，使用时，选中整个文件夹（包含许多小鼠的）

% update: 20220630
%% 
clear,clc,close all;
folder = uigetdir('选择有数据的文件夹');
labelsList = findMyFiles(folder,'SD_labels.mat');


for i = 1:length(labelsList)
    
    % 1.获取文件地址
    labelspath = labelsList{i,1};
    labelsname = getFileName(labelspath);
    micename = labelsname(1:end-7);
    a = strfind(labelspath,'\');
    eegdatapath = labelsList{i,1}(1:a(end)-1);
    
    % 2. 读取数据,并找到插入位置
    slicedPath = [eegdatapath,'\',micename,'_sliced.txt'];
    dataPath =  [eegdatapath,'\',micename,'.txt'];
    labelsPath = [eegdatapath,'\',micename,'_labels.mat'];
    if exist(dataPath,'file') ~= 2
        disp(['......',micename,'.txt文件没有找到']);
    elseif exist(slicedPath,'file') ~= 2
        disp(['......',micename,'_sliced.txt文件没有找到']);
    elseif exist(labelsPath,'file') ~= 2
        disp(['......',micename,'_labels.mat文件没有找到)']);
    end
    
    % 2.1 原始数据
    datafid = fopen(dataPath,'r');
    data = textscan(datafid,'%s%f%f%f','delimiter',',','HeaderLines',1);
    fclose(datafid);
    
    % 2.2 标记信息
    load(labelsPath);
    
    
    % 2.3 切割信息
    slicefid = fopen(slicedPath);
    slicedinfo = textscan(slicefid,'%s%f%f%f','delimiter',',');
    starttimestr = slicedinfo{1,1}{1,1};
    if length(starttimestr) > 25
        slicefid = fopen(slicedPath);
        slicedinfo = textscan(slicefid,'%s%f%f%f','delimiter','\t');
        starttimestr = slicedinfo{1,1}{1,1};
    end
    fclose(slicefid);
    startidx = timesearch(data{1,1},starttimestr);
    endidx = startidx + length(labels)*800 - 1;
    
    disp(['......',micename,'所需文件找到，开始写入...']);
    encodelabels(labels,data,startidx,endidx,eegdatapath,micename)
    disp(['......已写入完',num2str(i),'个，剩余',num2str(length(labelsList) -i),...
        '个未写入。']);
    
end
