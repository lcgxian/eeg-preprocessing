function outputtxtcell = speedcompose(timeAxis,numdata)

% timeAxis ���ݶ�Ӧ��ʱ���᣻
% numdata ��ֵ����

if length(timeAxis) ~= length(numdata)
    disp('����ʱ�䳤�Ȳ�ƥ�䣬�����Ҫд���������ݳ����Ƿ�һ��');
end

% 1.���ò��г���
thread = 8;
corenums = feature('numcores');
if corenums <= 8
    thread = corenums - 1;
end

% 2.�ֳɼ���blocks����ִ��
len = floor(length(numdata)/thread);% ÿ��blocks�ĳ���
datablocks = cell(1,thread);
timeblocks = cell(1,thread);
for i = 1:thread
    datablocks{i} = numdata((i-1)*len + 1:len*i,:);
    timeblocks{i} = timeAxis((i-1)*len + 1:len*i,:);
end


% 3.����ת�����ַ�������ƴ��ʱ����
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


% 4.������blocksƴ��
outputtxtcelltemp = reshape(outputtxt,[thread,1]);
outputtxtcell = vertcat(outputtxtcelltemp{:});

end


