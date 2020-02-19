classdef Beast

    properties
        Name
        Species
        Mind
        Category
        Summary
        HP
        FP
        hasFP
        Speed
        FIT
        PRS
        SPR
        CHR
        INT
        PCP
        POW
        EVL
        
        Skills
        hasSkills
        Block
        Dodge
        Immune
        hasImmune
        Resistant
        hasResistant
        Susceptible
        hasSusceptible
        Abilities
        
        hasAbilities
        hasAbilitiesBlock
        Actions
        hasActions
        Habitat
        SizeName
        Size
        Description
        Order
        
        Image
        hasImage
        ImagePos
    end
    
    methods
        function obj = Beast(tableLine)
            obj.Order = tableLine.SpeciesOrder(1);
            obj.Name = tableLine.Name{1};
            obj.Species = tableLine.Species{1};
            obj.Mind = tableLine.Mind{1};
            obj.Category = tableLine.Category{1};
            obj.Summary = tableLine.Summary{1};
            obj.HP = tableLine.HP(1);
            obj.FP = tableLine.FP(1);
            
            obj.hasFP = false;
            if ~isnan(obj.FP) && (obj.FP > 0)
                obj.hasFP = true;
            end
            
            obj.Speed = tableLine.Speed{1};
            obj.FIT = tableLine.FIT(1);
            obj.PRS = tableLine.PRS(1);
            obj.SPR = tableLine.SPR(1);
            obj.CHR = tableLine.CHR(1);
            obj.INT = tableLine.INT(1);
            obj.PCP = tableLine.PCP(1);
            obj.POW = tableLine.POW(1);
            obj.EVL = tableLine.EVL(1);
            
            obj.Skills = tableLine.Skills{1};
            obj.hasSkills = false;
            if ~isempty(obj.Skills)
                obj.hasSkills=true;
            end
            obj.Block = tableLine.Block(1);
            obj.Dodge = tableLine.Dodge(1);
            
            obj.Immune = tableLine.Immune{1};
            obj.hasImmune = false;
            if ~isempty(obj.Immune)
                obj.hasImmune = true;
            end
            obj.Resistant = tableLine.Resistant{1};
            obj.hasResistant = false;
            if ~isempty(obj.Resistant)
                obj.hasResistant= true;
            end
            obj.Susceptible = tableLine.Susceptible{1};
            obj.hasSusceptible = false;
            if ~isempty(obj.Susceptible)
                obj.hasSusceptible = true;
            end
            
            obj.Abilities = tableLine.Abilities{1};
            obj.hasAbilities = false;
            if ~isempty(obj.Abilities)
                obj.hasAbilities = true;
            end
            obj.hasAbilitiesBlock = any([obj.hasAbilities,obj.hasImmune,obj.hasResistant,obj.hasSusceptible,obj.hasSkills]);
            obj.Actions = tableLine.Actions{1};
            obj.hasActions = false;
            if ~isempty(obj.Actions)
                obj.hasActions= true;
            end
            obj.Habitat = tableLine.Habitat{1};
            
            obj.SizeName = tableLine.SizeName{1};
            obj.Size = tableLine.SizeValue{1};
            obj.Description = tableLine.Description;
            
            obj.hasImage = false;
            obj.Image =tableLine.Image{1};
            if ~isempty(obj.Image)
                obj.hasImage = true;
            end
            obj.ImagePos = 0;
        end
        
        function text = print(obj)
            
            text = "\\beast{";
            titles = ["name", "species","mind","category","summary","speed","habitat","sizeName","size"];
            array = [string(obj.Name), string(obj.Species), string(obj.Mind), string(obj.Category), string(obj.Summary), string(obj.Speed), string(obj.Habitat), string(obj.SizeName), string(obj.Size)];
            
            for i = 1:length(array)
                text = text + prepareText(titles(i)) + " = " + prepareText(array(i)) + ", ";
            end
            
            text = text + obj.statBlock();
            
            numTitles = ["hp","block","dodge","abilityBlock"];
            numArray = [obj.HP, obj.Block, obj.Dodge,obj.hasAbilitiesBlock];
            for i = 1:length(numArray)
                text = text + numTitles(i) + "="+num2str(numArray(i)) + ", ";
            end
            
            hasTitles = ["hasFP","hasImmune","hasResistance","hasSusceptible","hasAbilities","hasActions","hasSkills","hasImage"];
            hasTriggers = [obj.hasFP, obj.hasImmune,obj.hasResistant, obj.hasSusceptible, obj.hasAbilities, obj.hasActions,obj.hasSkills,obj.hasImage];
            includeTitles = ["fp", "immune", "resistance", "susceptible","abilities","actions","skills","image"];
            includeVals = [num2str(obj.FP), string(obj.Immune), string(obj.Resistant), string(obj.Susceptible), string(obj.Abilities), string(obj.Actions), string(obj.Skills),string(obj.Image)];
            
            for i = 1:length(hasTitles)
               if hasTriggers(i) 
                  text = text +  hasTitles(i) + " = 1, " + prepareText(includeTitles(i)) + " = " + prepareText(includeVals(i)) + ", ";
               end
            end
            text = text + "imPosition = " + num2str(obj.ImagePos) + ",";
            text = text + "description = " + prepareText(obj.Description) + "}";
        end
        
        function s = statBlock(obj)
            names = ["fit", "prs","spr","chr","int","pcp","pow","evl"];
            vals = [obj.FIT, obj.PRS, obj.SPR, obj.CHR, obj.INT, obj.PCP, obj.POW, obj.EVL];
            
            s = "";
            for i = 1:length(names)
                
                v = vals(i);
                if isnan(v)
                    v = 0;
                end
                mod = floor((v - 10)/2);
                
                sMod = num2str(mod);
                
                if mod > 0
                    sMod = "+"+sMod;
                end
                val = num2str(v) + " (" + sMod + ")";
                
                s = s + names(i) + " = " + val + ",";
            end
                
        end
    end
end
