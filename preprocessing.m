%% 预处理长时间记录的EEG数据，将其分割成每天的数据进行计算
clear,clc,close all
folder = uigetdir(pwd,'选择分割的EEG数据存放的文件夹');
fileList = findMyFiles(folder,'SD.txt');
miceNum = length(fileList);

% 询问是否需要不标定并直接写入标定文件
labelsOrNot = questdlg('是否需要自动分析结果（选否只切割文件）？','是否只切割文件',...
                       '是','否','否');

disp(['......共找到',num2str(miceNum),'个数据，正在处理中...']);

for i = 1:miceNum
    % 读取每只小鼠信息
    filePath = fileList{i,1};
    micename = getFileName(filePath);
    fid = fopen(filePath);
    data = textscan(fid,'%s%f%f%f%*[^\n]','delimiter',',','headerlines',1);
    fclose(fid);
    
    % 找到数据开始的时间点
    timeaxis = data{1,1};
    [timestartstr,preOrPost] = getstartstr(filePath,timeaxis);
    idx = timesearch(timeaxis,timestartstr);

    %% 分割和存储数据
    % 先建好文件夹
    days = length(idx);
    datainfo = cell(days,4);
    for j = 1:days
        startidx = idx(j);
        endidx = startidx + 17280000-1; %向后截取24小时的点
        dayfolderpath = [folder,'\',['day',num2str(j)]];
        if ~exist(dayfolderpath,'dir')
            mkdir(dayfolderpath);
        end
        eegdatapath = [dayfolderpath,'\',micename];
        mkdir(eegdatapath);
        datainfo{j,1} = startidx;
        datainfo{j,2} = endidx;
        datainfo{j,3} = eegdatapath;
        datainfo{j,4} = micename;
    end
    
    %% 预分析数据
    if strcmp(labelsOrNot,'是')
        daylabels = cell(1,days);
        for m = 1:days
            daylabels{1,m} = quicklabels(data,datainfo{m,1},...
                                              datainfo{m,2},...
                                              datainfo{m,3},...
                                              datainfo{m,4});
        end
        disp(['......',micename,'已预分析完毕。']); 
    end
    
    %% 切割EEG EMG数据
    for k = 1:days
        cutEEG(data,datainfo{k,1},...
                    datainfo{k,2},...
                    datainfo{k,3},...
                    datainfo{k,4});

    end
    disp(['......',micename,'数据已分割完毕。']);
    
%% 写入预分析结果
    if strcmp(labelsOrNot,'是')
        for q = 1:days
        encodelabels(daylabels{1,q},data,...
                         datainfo{q,1},...
                         datainfo{q,2},...
                         datainfo{q,3},...
                         datainfo{q,4});

        end
        disp(['......',micename,'已识别数据已输出。']);
    end
    % 显示当前进度
    disp(['...已分割完 ',num2str(i),' 只数据,', '剩余 ',num2str(miceNum - i),' 只数据']); 
 
end

  
%% 内建函数
function cutEEG(data,startidx,endidx,eegdatapath,micename) 

% 1)输出EEG,EMG文件
EEG = data{1,2}(startidx:endidx,:);
EMG = data{1,3}(startidx:endidx,:);
save([eegdatapath,'\',micename,'_EEG.mat'],'EEG');
save([eegdatapath,'\',micename,'_EMG.mat'],'EMG');
clear EEG EMG;

% 2)拼装切割文件数据
datamat = cell2mat(data(1,2:4)); % 数值数据
numericdata = datamat(startidx:endidx,:);
clear datamat;
outdata = speedcompose(data{1,1}(startidx:endidx),numericdata);
slicedinfo = outdata([1:10,end-10:end],:);

% 3)输出切割后的原始数据
fid2 = fopen([eegdatapath,'\',micename,'.txt'],'w+');
fprintf(fid2,'Timeaxis,EEG,EMG,LOC\n'); % 数据表头
fprintf(fid2,'%s\n',outdata{:});
fclose(fid2);

% 4)输出剪切信息（sliced_info.txt)
fid3 = fopen([eegdatapath,'\',micename,'_sliced.txt'],'w+');
fprintf(fid3,'%s\n',slicedinfo{:});
fclose(fid3);

end
