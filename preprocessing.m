%% Ԥ����ʱ���¼��EEG���ݣ�����ָ��ÿ������ݽ��м���
clear,clc,close all
folder = uigetdir(pwd,'ѡ��ָ��EEG���ݴ�ŵ��ļ���');
fileList = findMyFiles(folder,'SD.txt');
miceNum = length(fileList);

% ѯ���Ƿ���Ҫ���궨��ֱ��д��궨�ļ�
labelsOrNot = questdlg('�Ƿ���Ҫ�Զ����������ѡ��ֻ�и��ļ�����','�Ƿ�ֻ�и��ļ�',...
                       '��','��','��');

disp(['......���ҵ�',num2str(miceNum),'�����ݣ����ڴ�����...']);

for i = 1:miceNum
    % ��ȡÿֻС����Ϣ
    filePath = fileList{i,1};
    micename = getFileName(filePath);
    fid = fopen(filePath);
    data = textscan(fid,'%s%f%f%f%*[^\n]','delimiter',',','headerlines',1);
    fclose(fid);
    
    % �ҵ����ݿ�ʼ��ʱ���
    timeaxis = data{1,1};
    [timestartstr,preOrPost] = getstartstr(filePath,timeaxis);
    idx = timesearch(timeaxis,timestartstr);

    %% �ָ�ʹ洢����
    % �Ƚ����ļ���
    days = length(idx);
    datainfo = cell(days,4);
    for j = 1:days
        startidx = idx(j);
        endidx = startidx + 17280000-1; %����ȡ24Сʱ�ĵ�
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
    
    %% Ԥ��������
    if strcmp(labelsOrNot,'��')
        daylabels = cell(1,days);
        for m = 1:days
            daylabels{1,m} = quicklabels(data,datainfo{m,1},...
                                              datainfo{m,2},...
                                              datainfo{m,3},...
                                              datainfo{m,4});
        end
        disp(['......',micename,'��Ԥ������ϡ�']); 
    end
    
    %% �и�EEG EMG����
    for k = 1:days
        cutEEG(data,datainfo{k,1},...
                    datainfo{k,2},...
                    datainfo{k,3},...
                    datainfo{k,4});

    end
    disp(['......',micename,'�����ѷָ���ϡ�']);
    
%% д��Ԥ�������
    if strcmp(labelsOrNot,'��')
        for q = 1:days
        encodelabels(daylabels{1,q},data,...
                         datainfo{q,1},...
                         datainfo{q,2},...
                         datainfo{q,3},...
                         datainfo{q,4});

        end
        disp(['......',micename,'��ʶ�������������']);
    end
    % ��ʾ��ǰ����
    disp(['...�ѷָ��� ',num2str(i),' ֻ����,', 'ʣ�� ',num2str(miceNum - i),' ֻ����']); 
 
end

  
%% �ڽ�����
function cutEEG(data,startidx,endidx,eegdatapath,micename) 

% 1)���EEG,EMG�ļ�
EEG = data{1,2}(startidx:endidx,:);
EMG = data{1,3}(startidx:endidx,:);
save([eegdatapath,'\',micename,'_EEG.mat'],'EEG');
save([eegdatapath,'\',micename,'_EMG.mat'],'EMG');
clear EEG EMG;

% 2)ƴװ�и��ļ�����
datamat = cell2mat(data(1,2:4)); % ��ֵ����
numericdata = datamat(startidx:endidx,:);
clear datamat;
outdata = speedcompose(data{1,1}(startidx:endidx),numericdata);
slicedinfo = outdata([1:10,end-10:end],:);

% 3)����и���ԭʼ����
fid2 = fopen([eegdatapath,'\',micename,'.txt'],'w+');
fprintf(fid2,'Timeaxis,EEG,EMG,LOC\n'); % ���ݱ�ͷ
fprintf(fid2,'%s\n',outdata{:});
fclose(fid2);

% 4)���������Ϣ��sliced_info.txt)
fid3 = fopen([eegdatapath,'\',micename,'_sliced.txt'],'w+');
fprintf(fid3,'%s\n',slicedinfo{:});
fclose(fid3);

end
