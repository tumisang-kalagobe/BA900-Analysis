classdef bank < bankingSector
    
    properties
        Name
        BranchCode
        Deposits
        Loans
        LoanToDeposit
        TotalAssets
        TotalLiabilities   
    end
    
    properties (Dependent)
        BalanceSheet
    end
    
    properties (Dependent, Hidden)
        BalanceSheetPath
    end
    
    properties (Constant, Hidden)
        DataFolder = 'BA900/BA900-'
    end
    
    methods
        function obj = bank(chosenBank, yr, mth)
            %{
            Initialising an instance of the bank object.
            
            Inputs:
            yr      = year as an integer string (e.g "2019")
            mth     = month as a number string ranging from "01" to "12"
            
            Output:
            obj     = instance of the bank object
            %}        
            obj = obj@bankingSector(yr, mth);

            if strlength(mth) == 1
                obj.Month = '0' + mth;
                obj.Year = yr;
            else
                obj.Month = mth;
                obj.Year = yr;
            end
            
            for i = 1:length(obj.Banks)
                if strcmpi(obj.Banks(i).Name, chosenBank.Name)
                    obj.Name = obj.Banks(i).Name;
                    obj.BranchCode = obj.Banks(i).BranchCode;
                end
            end

        end
        
        
        
        function path = get.BalanceSheetPath(obj)
            %{
            Retrieval of the file path based on the time period of interest
            %}
            
            path = obj.DataFolder + obj.Year + '-' + ...
                obj.Month + '-01csv/' + obj.BranchCode + '.csv';
        end
        
        
        
        function bsheet = get.BalanceSheet(obj)
            %{
            Read Balannce sheet from the BA900 data provided by the SARB
            %}
            tbl = readtable(obj.BalanceSheetPath, 'ReadVariableNames', 0);
            bsheet = table2cell(tbl);
        end
        
        
        
        function monthlyData = dataArray(bankArray, totalDeposits, month)
            monthlyData = struct('Name', {}, 'Deposits', {}, 'Loans', ...
                {}, 'MarketShare', {}, 'LoanToDepositRatio', {}, 'Assets', {},...
                'Liabilities', {}, 'Equity', {}, 'DebtToEquity', {}, ...
                'DebtToAssets', {});
            
            banks = bankArray(strcmpi([bankArray.Month], month));
            for k = 1:length(banks)
                bsheet = banks(k).BalanceSheet;
                
                % extracted data
                monthlyData(k).Name = banks(k).Name;
                monthlyData(k).Deposits = bank.dataExtract(bsheet, 'deposits', 'total');
                monthlyData(k).Loans = bank.dataExtract(bsheet, 'deposits, loans and advances', 'total assets');
                monthlyData(k).Assets = bank.dataExtract(bsheet, 'total assets', 'total assets');
                monthlyData(k).Liabilities = bank.dataExtract(bsheet, 'total liabilities', 'total');
                
                % calculated data
                monthlyData(k).MarketShare = 100*monthlyData(k).Deposits/totalDeposits;
                monthlyData(k).LoanToDepositRatio = monthlyData(k).Loans/monthlyData(k).Deposits;
                monthlyData(k).Equity = monthlyData(k).Assets - monthlyData(k).Liabilities;
                monthlyData(k).DebtToEquity = monthlyData(k).Liabilities/monthlyData(k).Equity;
                monthlyData(k).DebtToAssets = monthlyData(k).Liabilities/monthlyData(k).Assets;
                
                
                clear bsheet
            end
            
                [~,index] = sortrows([monthlyData.MarketShare].');
                monthlyData = monthlyData(index(end:-1:1));
                clear index
        end
        
    end
    
    methods (Static)
        
        function value = dataExtract(bsheet, r, c)
            %{
            Function that extracts data from the 'BalanceSheet' property,
            given the desired entry.
            
            Inputs:
            obj     =   instance of the 'bank' object
            r       =   desired row entry, given as the 'Description'
                        column in the balance sheet
            c       =   desired column entry 
            
            Outputs:
            value   =   desired value entry from the balance sheet
            %}
            
            % add 'Table 1' row to array if missing
            if ~strcmpi(bsheet{1,1}, 'Table 1')
                tableRow = cell(1, size(bsheet, 2));
                tableRow(:) = {''};
                tableRow{1} = 'Table 1';
                bsheet = vertcat(tableRow, bsheet);
            end

            % finding the desired description
            descriptions = bsheet(:,1);
            newDescriptions = bank.lowertrim(descriptions);
            rowIndex = find(strcmpi(newDescriptions, r));
            
            % isolate table of interest 
            newArray = flipud(bsheet(rowIndex+1:-1:1, :));
            if ~contains(newArray{end,1}, 'Table')
                tableBreaks = find(contains(newArray(:,1), 'Table'));
                tableHeadings = newArray(tableBreaks(end)+1, :);
            else
                newArray = newArray(1:end-1, :);
                tableBreaks = find(contains(newArray(:,1), 'Table'));
                tableHeadings = newArray(tableBreaks(end)+1, :);
            end
            
            % finding the desired column
            columns = bank.lowertrim(tableHeadings);
            columnIndex =  strcmpi(columns, c);
            
            % finallly, return the value of interest
            value = str2double(bsheet{rowIndex, columnIndex});
            
        end
        
        function y = lowertrim(x)
            y = strtrim(lower(eraseBetween(x, '(', ')', 'Boundaries', ...
                'inclusive')));
        end
    end
    
end