%% 快速预分析EEG数据
% input : EEG，EMG (200Hz), Calib data;
function labels = quicklabels(data,startidx,endidx,eegdatapath,micename)
% 0. 加载预分析参数
  load('D:\LCG\software\matlab function\0701_newnetWork_by_NewVersion.mat');
  load('D:\LCG\software\matlab function\86#preSD_calib.mat');

% 1. 检验输入数据合法性
EEG = data{1,2}(startidx:endidx,:);
EMG = data{1,3}(startidx:endidx,:);
if length(EEG) ~= length(EMG) || rem(length(EEG),800)
    disp('......请检查EEG数据长度是否一致,时间是否是4s的倍数');
end

% 2. EEG数据预处理
% 降采样到128Hz
downsampledEEG = standardizeSR(EEG,200,128);
downsampledEMG = standardizeSR(EMG,200,128);

% 3.分析结果
[labels,~] = AccuSleep_classify(downsampledEEG,downsampledEMG,...
                                     net,128,4,calibrationData,5);
% 4.优化实验结果 （去除两帧Wake后面接REMS的情况）
labels = removeDREM(labels)';
save([eegdatapath,'\',micename,'_labels.mat'],'labels');

% 5.存储谱图文件用于判断数据准确率
s = strfind(eegdatapath,'\');
savepath = [eegdatapath(1:s(end)),'spectrum'];
 if ~exist(savepath,'dir')
    mkdir(savepath);
 end

AccuSleep_viewer(EEG, EMG, 200, 4, labels, savepath);
saveas(gca,[savepath,'\',micename,'_spectrum.jpg']);
close all;

end
                                     
                                     
                                     