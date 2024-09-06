%dw 2.0
output application/xml
var motivePayload = payload  
---
{
    FuelCheckTransactions: {
        AccountHeader: {
            AccountId: motivePayload.account_id,
            ReportProcessedDate: motivePayload.ReportProcessDate,
            SubAccountHeader: motivePayload.sub_accounts map (subAccount) -> {
                SubAccountId: subAccount.sub_account_id,
                FuelTransactions: {
                    FuelCardTransaction: subAccount.sub_account_fuel_transactions map (txn) -> {
                        TransactionInfo: {
                            FuelCardNumber: txn.fuel_card_number,
                            TransactionNumber: txn.transaction_number,
                            TransactionDate: txn.TransactionDateTime as String {format: "yyyyMMdd"},  // Converts date format
                            TransactionTime: txn.TransactionDateTime as String {format: "HHmmss"},
                            TransactionStatus: txn.TransactionStatus,
                            TransactionType: txn.TransactionType,
                            TransactionBillCode: txn.TransactionBillCode
                        },
                        TransactionAmts: {
                            TractorGallons: txn.TractorGallons,
                            TractorFuelPrice: txn.TractorFuelPrice,
                            TractorFuelCost: txn.TractorFuelCost,
                            TractorFuelDiscount: txn.TractorFuelDiscount,
                            TractorFuelDescription: txn.TractorFuelDescription,
                            TractorFuelCode: txn.TractorFuelCode,
                            ReeferGallons: txn.ReeferGallons,
                            ReeferFuelPrice: txn.ReeferFuelPrice,
                            ReeferFuelCost: txn.ReeferFuelCost,
                            ReeferFuelDiscount: txn.ReeferFuelDiscount,
                            PumpedDEFGallons: txn.PumpedDEFGallons,
                            PumpedDEFPrice: txn.PumpedDEFPrice,
                            PumpedDEFCost: txn.PumpedDEFCost,
                            PumpedDEFDiscount: txn.PumpedDEFDiscount,
                            FuelDiscount: txn.FuelDiscount,
                            DirectAmt: 0,   // DirectAmt is hardcoded to 0 for funded transactions
                            FundedAmt: txn.FundedAmt
                        },
                        MiscProducts: txn.MiscProducts map (product) -> {
                            Product: {
                                ProductCode: product.ProductCode,
                                ProductDescription: product.ProductDescription,
                                ProductAmt: product.ProductAmt,
                                ProductBillCode: product.ProductBillCode
                            }
                        }
                    }
                },
                SubAccountFuelTotals: {
                    SubAccountFuelDirectCost: 0, // Since transactions are funded
                    SubAccountFuelFundedCost: subAccount.SubAccountFuelTotals.SubAccountFuelFundedCost
                }
            }
        },
        AccountFuelTotals: {
            AccountFuelTotalDirectCost: 0, // Direct is always 0 for funded transactions
            AccountFuelTotalFundedCost: motivePayload.AccountFuelTotals.AccountFuelTotalFundedCost
        }
    }
}
