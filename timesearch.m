function idx = timesearch(timecell,timestr)
% timecell = time; for debugging
% timestr = '09:00:00.00';

datalength = length(timecell);
containedIdx = find(contains(timecell,timestr));
rawidx = containedIdx(1);

days = floor((datalength-rawidx+1)/(24*900*800));

for i = 2:length(containedIdx)-1
    if containedIdx(i+1)-containedIdx(i) > 12*900*800 % 大于12小时后的index
        rawidx = [rawidx,containedIdx(i+1)];
    end
end

idx = rawidx(1:days);

end
