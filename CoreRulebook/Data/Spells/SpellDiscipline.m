classdef SpellDiscipline < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name;
        
        Spells;
    end
    
    methods
        function obj = SpellDiscipline(name)
            obj.Name = name;
            
            obj.Spells = {Spell.empty,Spell.empty,Spell.empty,Spell.empty,Spell.empty};
        end
        
        function max = maxSpellNumber(obj)
            max= 0;
            for j = 1:5
                ell = length(obj.Spells{j});
                if ell > max
                    max = ell;
                end
            end
        end
        
        
    end
end
