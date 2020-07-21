function plotAll(data, chosenBanks, month)
    bankingSector.plotBankData(data, chosenBanks, month, 'Debt-to-Equity Ratio for Bank(s) of Interest', 'Debt to Equity')
    bankingSector.plotBankData(data, chosenBanks, month, 'Debt-to-Assets Ratio for Bank(s) of Interest', 'Debt to Assets')
    bankingSector.plotBankData(data, chosenBanks, month, 'Deposits for Bank(s) of Interest', 'Deposits')
    bankingSector.plotBankData(data, chosenBanks, month, 'Loans for Bank(s) of Interest', 'Loans')
    bankingSector.plotBankData(data, chosenBanks, month, 'Market Share Percentage for Bank(s) of Interest', 'Market Share')
    bankingSector.plotBankData(data, chosenBanks, month, 'Loan-to-Deposit Ratio for Bank(s) of Interest', 'Loan to Deposit Ratio')
end