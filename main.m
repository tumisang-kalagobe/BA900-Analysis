clc
%{
Author:             Tumisang Kalagobe 
Date finalised:     31/10/2019
Description:        Function that determines the BA900  data for the big
                    banks in South Africa, as given in the monthly audits
                    by the South African Reserve Bank.
Version:            1.3.0.0
%}

tic
%% User inputs
year = 2019;
month = 1:1:8;
chosenBanks = {'FNB'; 'ABSA'; 'Nedbank'; 'Investec'; 'Capitec';...
    'Standard Bank'};

%% Execute Main Function
data = bank_analysis(year, month, chosenBanks);
toc