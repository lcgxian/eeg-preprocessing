function [timestartstr,preOrPost] = getstartstr(filePath,timeaxis)
% 20220630 �ж�������preSD����postSD��Ȼ�󷵻��������ͺͿ�ʼ��ʱ���ַ�
% preSD: 9:00��ʼ
% postSD: 1)����15:00,��15:00��ʼ
%         2������15:00����15:15ǰ���ӵ�ǰ��ʼ
%         3��15:15-15:30,��15:30��ʼ��
%         4) ��15:30�Ժ�,��ǰʱ�俪ʼ



% 1. ��ȡ�ļ�����
cutIndex = strfind(filePath,'\');
fileName = filePath(cutIndex(end)+1:end);

% 2.�ж���preSD����postSD����
if contains(fileName,'pre')
    preOrPost = 1;
    timestartstr = '09:00:00.';
elseif contains(fileName,'post')
    preOrPost = 2;
    startTime = datevec(timeaxis{1,1});
    now = startTime(4:6) * [3600;60;1];
    timeLineLate = [15 15 0]* [3600;60;1];
    timeLineEarly = [15 0 0]*[3600;60;1];
    timeLineTooLate = [15 30 0]*[3600;60;1];
    
    if now <= timeLineLate && now >= timeLineEarly 
        timestartstr = timeaxis{1,1}(12:end - 3);
    elseif now < timeLineEarly
        timestartstr = '15:00:00.';
    elseif now > timeLineLate && now <= timeLineTooLate
        timestartstr = '15:30:00.';
    elseif now > timeLineTooLate
            disp(['......',fileName,'ʵ����̫���ˣ�']);
            timestartstr = timeaxis{1,1}(12:end - 3);
    end
else
    disp(['......',fileName,'�޷��ж�������pre����post']);
end

end

    
    
    
    