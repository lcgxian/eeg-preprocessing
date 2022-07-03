%% ����Ԥ����EEG����
% input : EEG��EMG (200Hz), Calib data;
function labels = quicklabels(data,startidx,endidx,eegdatapath,micename)
% 0. ����Ԥ��������
  load('D:\LCG\software\matlab function\0701_newnetWork_by_NewVersion.mat');
  load('D:\LCG\software\matlab function\86#preSD_calib.mat');

% 1. �����������ݺϷ���
EEG = data{1,2}(startidx:endidx,:);
EMG = data{1,3}(startidx:endidx,:);
if length(EEG) ~= length(EMG) || rem(length(EEG),800)
    disp('......����EEG���ݳ����Ƿ�һ��,ʱ���Ƿ���4s�ı���');
end

% 2. EEG����Ԥ����
% ��������128Hz
downsampledEEG = standardizeSR(EEG,200,128);
downsampledEMG = standardizeSR(EMG,200,128);

% 3.�������
[labels,~] = AccuSleep_classify(downsampledEEG,downsampledEMG,...
                                     net,128,4,calibrationData,5);
% 4.�Ż�ʵ���� ��ȥ����֡Wake�����REMS�������
labels = removeDREM(labels)';
save([eegdatapath,'\',micename,'_labels.mat'],'labels');

% 5.�洢��ͼ�ļ������ж�����׼ȷ��
s = strfind(eegdatapath,'\');
savepath = [eegdatapath(1:s(end)),'spectrum'];
 if ~exist(savepath,'dir')
    mkdir(savepath);
 end

AccuSleep_viewer(EEG, EMG, 200, 4, labels, savepath);
saveas(gca,[savepath,'\',micename,'_spectrum.jpg']);
close all;

end
                                     
                                     
                                     