function [timestartstr,preOrPost] = getstartstr(filePath,timeaxis)
% 20220630 判断数据是preSD还是postSD，然后返回数据类型和开始的时间字符
% preSD: 9:00开始
% postSD: 1)早于15:00,从15:00开始
%         2）晚于15:00但在15:15前，从当前开始
%         3）15:15-15:30,从15:30开始，
%         4) 从15:30以后,当前时间开始



% 1. 获取文件名字
cutIndex = strfind(filePath,'\');
fileName = filePath(cutIndex(end)+1:end);

% 2.判断是preSD还是postSD数据
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
            disp(['......',fileName,'实在是太晚了！']);
            timestartstr = timeaxis{1,1}(12:end - 3);
    end
else
    disp(['......',fileName,'无法判断数据是pre还是post']);
end

end

    
    
    
    