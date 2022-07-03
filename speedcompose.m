function outputtxtcell = speedcompose(timeAxis,numdata)

% timeAxis 数据对应的时间轴；
% numdata 数值数据

if length(timeAxis) ~= length(numdata)
    disp('数据时间长度不匹配，检查需要写的两个数据长度是否一致');
end

% 1.设置并行池数
thread = 8;
corenums = feature('numcores');
if corenums <= 8
    thread = corenums - 1;
end

% 2.分成几个blocks并行执行
len = floor(length(numdata)/thread);% 每个blocks的长度
datablocks = cell(1,thread);
timeblocks = cell(1,thread);
for i = 1:thread
    datablocks{i} = numdata((i-1)*len + 1:len*i,:);
    timeblocks{i} = timeAxis((i-1)*len + 1:len*i,:);
end


% 3.并行转化成字符串，并拼接时间轴
outputtxt = cell(1,thread);
if isempty(gcp('nocreat'))
    parpool(thread);
end

strspecLen = size(numdata,2);
strspec = ['%f',repmat(',%f',1,strspecLen - 1)];
parfor j = 1:thread
    outputtxt{j} = cellfun(@(x,y)[x,',',y],...
                    timeblocks{j},compose(strspec,datablocks{j}),'un',0);
end


% 4.将各个blocks拼好
outputtxtcelltemp = reshape(outputtxt,[thread,1]);
outputtxtcell = vertcat(outputtxtcelltemp{:});

end


