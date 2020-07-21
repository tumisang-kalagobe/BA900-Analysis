classdef bankingSector
    
    properties
        Year
        Month
        Banks
    end
    
    
    methods
        function obj = bankingSector(yr,mth)
            
            if strlength(mth) == 1
                obj.Month = '0' + mth;
                obj.Year = yr;
            else
                obj.Month = mth;
                obj.Year = yr;
            end
            
            names = {
                'Capitec';
                'Investec';
                'ABSA';
                'FNB';
                'Standard Bank';
                'Nedbank';
                'TOTAL'
                };
            
            codes = {
                '333107';
                '25054';
                '34118';
                '416053';
                '416061';
                '416088';
                'TOTAL'
                };
            
            obj.Banks = struct('Name', names, 'BranchCode', codes);
        end
        
        function bankArray = selectBanks(chosenBanks, obj)
            noOfBanks = length(chosenBanks);
            for k = 1:noOfBanks
                bankArray(k) = bank(...
                    chosenBanks(k), obj.Year, obj.Month);
            end
        end
    end
    
    
    
    methods (Static)
        function plotBankData(data, chosenBanks, month, titleOfGraph, desiredField)
            monthArray = fieldnames(data);
            dataFields = fieldnames(data.(monthArray{1}));
            column = zeros(length(chosenBanks), length(monthArray));
            
            for i = 1:1:length(monthArray)
                column(:, i) = [data.(monthArray{i}).(dataFields{strcmpi(bank.lowertrim(dataFields), bank.lowertrim(erase(desiredField, [" ", "-"])))})];
            end
            
            fig = figure;
            plot(month, column)
            plot(month, column)
            set(gca, 'xticklabel', monthArray.')
            title(titleOfGraph)
            legend({data.(monthArray{1}).Name}, 'Location', 'northeast', 'NumColumns', 2)
            legend('boxoff')
            
            size = 18;
            set(gcf, 'PaperPosition', [0 0 size size]); %Position plot at left hand corner with width 5 and height 5.
            set(gcf, 'PaperSize', [size size]); %Set the paper to have width 5 and height 5.
            print(fig, strcat('Graphs/',bank.lowertrim(erase(titleOfGraph, [" ", "-"]))), '-dpdf', '-bestfit', '-r400')
            close all
        end
    end
end

