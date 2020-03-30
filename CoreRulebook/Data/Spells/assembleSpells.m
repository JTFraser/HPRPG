function assembleSpells(maxLevel,fileNameRoot)
   
    %if no target given, assume that called directly, else assume called by
    %master
   
    if nargin < 2
        disp('Insufficient inputs provided');
        if nargin < 1
            maxLevel = 6;
        end
        addpath('../Functions/');
        fileNameRoot = '../../Chapters/Part5_Lists/';
    end
    %% open file
    
    opts = detectImportOptions('AllSpells.xlsx','NumHeaderLines',2);
    opts.VariableNamesRange = 'A1';
    f = readtable("AllSpells.xlsx",opts,'ReadVariableNames',true);

    %% read in the file line by line and sort into schools and disciplines
    schools = SpellSchool.empty;
    allSpells = Spell.empty;
    for i = 1:height(f)
        newSpell = Spell();
        newSpell.ReadLine(f(i,:));
        allSpells(end+1) = newSpell;
        
        if newSpell.Level <= maxLevel
            schoolFound= false;
            for j = 1:length(schools)
                if strcmp(schools(j).Name,newSpell.School) == 1            
                    schoolFound = true;
                    disc = schools(j).hasDiscipline(newSpell.Discipline);
                    if disc > 0    
                        schools(j).Discipline(disc).Spells{newSpell.Level}(end+1) = newSpell;
                    else
                        newDisc = SpellDiscipline(newSpell.Discipline);
                        newDisc.Spells{newSpell.Level}(1) = newSpell;
                        schools(j).Discipline(end+1) = newDisc;
                    end
                end
            end

            if schoolFound == false
               newSchool = SpellSchool(newSpell.School);
               newDisc = SpellDiscipline(newSpell.Discipline);
               newDisc.Spells{newSpell.Level}(1) = newSpell;
               newSchool.Discipline(1) = newDisc;
               schools(end+1) = newSchool;
            end
        end
    end
    
    %% sort alphabetically
    [~,I] =sort({schools.SortName});
    schools = schools(I);
    for i = 1:length(schools)
       [~,I]= sort({schools(i).Discipline.Name});
       schools(i).Discipline = schools(i).Discipline(I);
       for j = 1:length(schools(i).Discipline)
            for k = 1:6
                [~,I] = sort({schools(i).Discipline(j).Spells{k}.Name});
                schools(i).Discipline(j).Spells{k} = schools(i).Discipline(j).Spells{k}(I);
            end
       end
    end
    [~,I] = sort({allSpells.Name});
    allSpells = allSpells(I);
    
    
    %% create text for discipline tables
    disciplineTableText =  '\\scriptsize';
    
    for i = 1:length(schools)
        t = "\\vbox{\n\\subsection{" + schools(i).Name + "}\n";
        
        for j = 1:length(schools(i).Discipline)
            disc = schools(i).Discipline(j);
            t = t + "\n\\vbox{\n"; 
            
            col = ">{\\centering\\arraybackslash}m{\\w cm} >{\\centering\\arraybackslash}m{\\s cm}";
            t = t + "\\begin{rndtable}{"+ col + col + col + col + col + col + "}\n";
            t =t + "\\multicolumn{12}{c}{\\bf \\normalsize " + disc.Name + "} \n\\\\\n ";
			array = ["Beginner", "Novice", "Adept", "Expert", "Master", "Ascendant"];
            for q = 1:6
                t = t + "\\multicolumn{2}{c}{\\cellcolor{\\tablecolorhead} \\bf " + array(q)+ "}";
                if q <6
                    t = t + "&";
                end
            end
            
            for row = 1:disc.maxSpellNumber()
                t = t + "\n \\\\ \n";
                for column = 1:6
                    
                    if row <= length(disc.Spells{column})
                        sp = disc.Spells{column}(row);
                        t = t + prepareText(sp.Name) + " & " +sp.Symbol;
                    else
                        t = t + "~\t & ~\t";
                    end
                    
                    if column < 6
                        t = t + " & ";
                    end
                end        
            end
            t= t + "\n\\end{rndtable}\n\\vspace{3ex}\n}";
        end
        
        t = t + "\n}";
        disciplineTableText = disciplineTableText + t + "\n\n";
    end
    
    %% create text for description list
   
    listText = '\n \\normalsize \\clearpage \n\\begin{multicols}{3}\n';
    
    for i = 1:length(allSpells)
       listText = listText +  allSpells(i).output() + "\n";
    end
    listText = listText + "\\end{multicols}";
    
	%% output to file
    
    fileName = strcat(fileNameRoot, 'SpellList.tex');

    
	readFile = fileread(fileName);
	insertPoint = strfind(readFile, '%%SpellBegin');
    endPoint = strfind(readFile, '%%SpellEnd');
    firstHalf = prepareText(readFile(1:insertPoint+12),0);

    secondHalf = prepareText(readFile(endPoint:end),0);
	
	fullText = firstHalf + disciplineTableText + listText + "\n" + secondHalf;
	FID = fopen(fileName,'w');
    fprintf(FID, fullText);
    fclose(FID);
    
    spellBook(schools,fileNameRoot)
end

function spellBook(schools,fileNameRoot)

    f = readtable("bookNames.xlsx");
    text = "";
    for q = 1:6
    for i = 1:length(schools)
       for j = 1:length(schools(i).Discipline)
          disc = schools(i).Discipline(j);
          tit = ["Beginner", "Novice", "Adept", "Expert","Master","Ascendant"];
          
          x = string(transpose(f{:,1}));
          rowID = (x==disc.Name);
 
          
             bName = prepareText(f{rowID,1+q}{1});
             sub =  tit(q) + "-level " + disc.Name;
             
             text = text + "\n \\spellBook{"+bName+"}{"+sub+"}{\n";
             
             for k = 1:length(disc.Spells{q})
				 
                 text = text + disc.Spells{q}(k).output() + "\n";
             end
             
             text = text + "}";
             
          end
     
       end
    end
    

     fileName = strcat(fileNameRoot, '../../../GameMasterGuide/SpellBooks.tex');

    readFile = fileread(fileName);
    insertPoint = strfind(readFile, '%%SpellbookBegin');
    endPoint = strfind(readFile, '%%SpellbookEnd');
    firstHalf = prepareText(readFile(1:insertPoint+16),0,0);

    secondHalf = prepareText(readFile(endPoint:end),0,0);

    fullText = firstHalf + text + "\n" + secondHalf;
    FID = fopen(fileName,'w');
    fprintf(FID, fullText);
    fclose(FID);
    
end