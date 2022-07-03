%% д��Ԥ�������labels
% update 20220630
function encodelabels(labels,data,startidx,endidx,eegdatapath,micename)

% labels : AccuSleep��������1 = R; 2 = W ; 3 = NR)
% data: ԭʼ���ݾ��� time/EEG/EMG/LOC
% startidx: ����д�뿪ʼλ��
% endidx: ����д����ֹλ��
% eegdatapath: ����data��labels���ļ���
% micename: С������xxx#preSD/xxx#postSD


% 1)����labels����
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

% 2)�����������
datamat = cell2mat(data(1,2:4)); % ��ֵ����
numericdata = datamat(startidx:endidx,:); 
clear datamat;
labeledoutdata = [numericdata(:,1:2),labelsData,numericdata(:,3)];
clear numericdata;
labeledtxt = speedcompose(data{1,1}(startidx:endidx),labeledoutdata);
clear labeledoutdata;

% 3) �������
s = strfind(eegdatapath,'\');
daystr = eegdatapath(s(end-1)+1:s(end)-1);


if length(data) - endidx >= 0 % һ������ݺ��治�ü�day1 day2�ĺ�׺
    fid = fopen([eegdatapath,'\',micename,'_',daystr,'_��ʶ��.txt'],'w+');
else
    fid = fopen([eegdatapath,'\',micename,'_��ʶ��.txt'],'w+');
end

fprintf(fid,'TimeAxis,EEG,EMG,labels,LOC\n');
fprintf(fid,'%s\n',labeledtxt{:});
fclose(fid);

end
