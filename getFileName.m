function name = getFileName(filePath)
s = strfind(filePath,'\');
name = filePath(s(end)+1:end -4);
end