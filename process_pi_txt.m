inputfile = fopen('pifast.txt');
outputfile = fopen('pi.txt','wt');

tline = fgetl(inputfile);
szamjegyek = '';
allapot = 'kezdes';
%allapot = 'szures';
szamlalo = 0;


while ischar(tline)
%    disp(tline)
    str = regexprep(strread(tline,'%s',1,'delimiter',':'),' ','');
    
    switch allapot
        case 'kezdes'
            if (strcmp(str,'Pi=3.'))
                allapot = 'szures';
            end
        case 'szures'
%            disp(str)

            if (size(str) == [1 1])
                szamlalo = szamlalo+1;
                fprintf(outputfile, '%s', str{1,1});
            end

              if mod(szamlalo, 10000) == 0
                 disp(szamlalo*50)
              end
            
    end
    
    tline = fgetl(inputfile);
end
fclose(inputfile);
fclose(outputfile);

