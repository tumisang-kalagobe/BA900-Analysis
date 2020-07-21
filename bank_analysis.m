function data = bank_analysis(year, month, chosenBanks)
%{
Author:             Tumisang Kalagobe 
Date finalised:     31/10/2019
Description:        Function that determines the BA900  data for the big
                    banks in South Africa, as given in the monthly audits
                    by the South African Reserve Bank.

Inputs:
year        =   the year of interest as a scalar double
month       =   vector of the months desired, where each month is
                a numerical value (i.e January = 1, February = 2, etc.)
chosenBanks =   cell array of the banks of interest as strings

Outputs:
data        =   struct containing the BA900 data of interest
%}

bankArray = [];
total = struct('Name', 'TOTAL', 'BranchCode', 'TOTAL');

for n=1:length(month)
    %% Creating banking sector and bank objects
    time = {string(year), string(month(n))};
    
    totalMarket = bank(total, time{1}, time{2});
    totalDeposits = bank.dataExtract(totalMarket.BalanceSheet, 'deposits', 'total');
    
    sector = bankingSector(time{1}, time{2});
    check = contains({sector.Banks.Name}, chosenBanks);
    filteredBanks = sector.Banks(check);
    
    if isempty(bankArray)
        bankArray = selectBanks(filteredBanks, sector);
    else 
        bankArray = [bankArray, selectBanks(filteredBanks, sector)]; %#ok<AGROW>
    end
    
    %% data extraction
    switch double(time{2})
        case 1
            data.January = dataArray(bankArray, totalDeposits, '01');
        case 2
            data.February = dataArray(bankArray, totalDeposits, '02');
        case 3
            data.March = dataArray(bankArray, totalDeposits, '03');
        case 4
            data.April = dataArray(bankArray, totalDeposits, '04');
        case 5
            data.May = dataArray(bankArray, totalDeposits, '05');
        case 6
            data.June = dataArray(bankArray, totalDeposits, '06');
        case 7
            data.July = dataArray(bankArray, totalDeposits, '07');
        case 8
            data.August = dataArray(bankArray, totalDeposits, '08');
        case 9
            data.September = dataArray(bankArray, totalDeposits, '09');
        case 10
            data.October = dataArray(bankArray, totalDeposits, '10');
        case 11
            data.November = dataArray(bankArray, totalDeposits, '11');
        case 12
            data.December = dataArray(bankArray, totalDeposits, '12');
    end
    
end

