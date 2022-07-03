%% 写入预分析结果labels
% update 20220630
function encodelabels(labels,data,startidx,endidx,eegdatapath,micename)

% labels : AccuSleep输出结果（1 = R; 2 = W ; 3 = NR)
% data: 原始数据矩阵 time/EEG/EMG/LOC
% startidx: 数据写入开始位置
% endidx: 数据写入终止位置
% eegdatapath: 包含data和labels的文件夹
% micename: 小鼠名称xxx#preSD/xxx#postSD


% 1)构建labels数列
dataNum = length(labels)*800;
labelsData = -0.400001*ones(dataNum,1);
for i = 1:length(labels)
    if labels(i) == 1
        labelsData(400 + 800*(i-1)) = 0;
    elseif labels(i) == 2
        labelsData(400 + 800*(i-1)) = 1;
    elseif labels(i) == 3
        labelsData(400 + 800*(i-1)) = 2;
    elseif labels(i) == 4
        labelsData(400 + 800*(i-1)) = 1.8;
    end
end

% 2)构建输出矩阵
datamat = cell2mat(data(1,2:4)); % 数值数据
numericdata = datamat(startidx:endidx,:); 
clear datamat;
labeledoutdata = [numericdata(:,1:2),labelsData,numericdata(:,3)];
clear numericdata;
labeledtxt = speedcompose(data{1,1}(startidx:endidx),labeledoutdata);
clear labeledoutdata;

% 3) 输出矩阵
s = strfind(eegdatapath,'\');
daystr = eegdatapath(s(end-1)+1:s(end)-1);


if length(data) - endidx >= 0 % 一天的数据后面不用加day1 day2的后缀
    fid = fopen([eegdatapath,'\',micename,'_',daystr,'_已识别.txt'],'w+');
else
    fid = fopen([eegdatapath,'\',micename,'_已识别.txt'],'w+');
end

fprintf(fid,'TimeAxis,EEG,EMG,labels,LOC\n');
fprintf(fid,'%s\n',labeledtxt{:});
fclose(fid);

end
