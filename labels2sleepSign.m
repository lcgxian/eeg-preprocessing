% ������С��˯��״̬��labels��*_labels.mat,1 * N��������д�뵽ԭʼEEG�ļ���txt��
% �����˹�У���Զ���ǽ��
% ��Ҫ����ӦС���ԭʼ�����ļ���*_preSD.txt��*_preSD_sliced.txt,*_labels.mat
% ����ͬһ���ļ����У�ʹ��ʱ��ѡ�������ļ��У��������С��ģ�

% update: 20220630
%% 
clear,clc,close all;
folder = uigetdir('ѡ�������ݵ��ļ���');
labelsList = findMyFiles(folder,'SD_labels.mat');


for i = 1:length(labelsList)
    
    % 1.��ȡ�ļ���ַ
    labelspath = labelsList{i,1};
    labelsname = getFileName(labelspath);
    micename = labelsname(1:end-7);
    a = strfind(labelspath,'\');
    eegdatapath = labelsList{i,1}(1:a(end)-1);
    
    % 2. ��ȡ����,���ҵ�����λ��
    slicedPath = [eegdatapath,'\',micename,'_sliced.txt'];
    dataPath =  [eegdatapath,'\',micename,'.txt'];
    labelsPath = [eegdatapath,'\',micename,'_labels.mat'];
    if exist(dataPath,'file') ~= 2
        disp(['......',micename,'.txt�ļ�û���ҵ�']);
    elseif exist(slicedPath,'file') ~= 2
        disp(['......',micename,'_sliced.txt�ļ�û���ҵ�']);
    elseif exist(labelsPath,'file') ~= 2
        disp(['......',micename,'_labels.mat�ļ�û���ҵ�)']);
    end
    
    % 2.1 ԭʼ����
    datafid = fopen(dataPath,'r');
    data = textscan(datafid,'%s%f%f%f','delimiter',',','HeaderLines',1);
    fclose(datafid);
    
    % 2.2 �����Ϣ
    load(labelsPath);
    
    
    % 2.3 �и���Ϣ
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
    
    disp(['......',micename,'�����ļ��ҵ�����ʼд��...']);
    encodelabels(labels,data,startidx,endidx,eegdatapath,micename)
    disp(['......��д����',num2str(i),'����ʣ��',num2str(length(labelsList) -i),...
        '��δд�롣']);
    
end
