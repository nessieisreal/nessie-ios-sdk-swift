
//
//  NSEFunctionalTests.swift
//  Nessie-iOS-Wrapper
//
//  Created by Lopez Vargas, Victor R. on 10/5/15.
//  Copyright (c) 2015 Nessie. All rights reserved.
//

import Foundation
import NessieFmwk

class AccountTests {
    let client = NSEClient.sharedInstance

    init() {
        client.setKey("bca7093ce9c023bb642d0734b29f1ad2")
        self.testGetAccounts()
    }
    
    func testGetAccounts() {
        let accountType = AccountType.Savings
        
        AccountRequest().getAccounts(accountType, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let array = response as Array<Account>? {
                    if array.count > 0 {
                        let account = array[0] as Account?
                        self.testGetAccount(account!.accountId)
                        print(array)
                    } else {
                        print("No accounts found")
                    }
                }
            }
        })
    }
    
    func testGetAccount(accountId: String) {
        AccountRequest().getAccount(accountId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let account = response as Account? {
                    print(account)
                    self.testGetCustomerAccounts(account.customerId)
                }
            }
        })
    }

    func testGetCustomerAccounts(customerId: String) {
        AccountRequest().getCustomerAccounts(customerId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let array = response as Array<Account>? {
                    print(array)
                    let account = array[0] as Account?
                    self.testPostAccount(account!.customerId)
                    self.testPutAccount(account!.accountId, nickname: "New nickname", accountNumber: "0987654321123456")
                    self.testDeleteAccount(account!.accountId)
                }
            }
        })
    }
    
    func testPostAccount(customerId: String) {
        let accountType = AccountType.Savings
        let accountToCreate = Account(accountId: "", accountType:accountType, nickname: "Hola", rewards: 10, balance: 100, accountNumber: "1234567890123456", customerId: customerId)
        AccountRequest().postAccount(accountToCreate, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let accountResponse = response as BaseResponse<Account>?
                let message = accountResponse?.message
                let accountCreated = accountResponse?.object
                print("\(message): \(accountCreated)")
            }
        })
    }

    func testPutAccount(accountId: String, nickname: String, accountNumber: String?) {
        AccountRequest().putAccount(accountId, nickname: nickname, accountNumber: accountNumber, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let accountResponse = response as BaseResponse<Account>?
                let message = accountResponse?.message
                let accountCreated = accountResponse?.object
                print("\(message): \(accountCreated)")
            }
        })
    }

    func testDeleteAccount(accountId: String) {
        AccountRequest().deleteAccount(accountId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let accountResponse = response as BaseResponse<Account>?
                if let message = accountResponse?.message {
                    print(message)
                }
            }
        })
    }
}

class ATMTests {
    let client = NSEClient.sharedInstance

    init() {
        client.setKey("bca7093ce9c023bb642d0734b29f1ad2")
        
        self.testGetAtms()
    }
    
    func testGetAtms() {
        let latitude = 38.9283 as Float
        let longitude = -77.1753 as Float
        let radius = "1" as String
        
        ATMRequest().getAtms(latitude, longitude: longitude, radius: radius, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let array = response as AtmResponse?
                print(array!.requestArray)
                
                self.testGetNextAtms(array!.nextPage)
            }
        })
    }
    
    func testGetNextAtms(nextString: String) {
        ATMRequest().getNextAtms(nextString, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let array = response as AtmResponse?
                print(array!.requestArray)
                
                self.testGetPreviousAtms(array!.previousPage)
            }
        })
    }

    func testGetPreviousAtms(previousString: String) {
        ATMRequest().getPreviousAtms(previousString, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let array = response as AtmResponse?
                print(array!.requestArray)
            }
        })
    }

}

class BillTests {
    let client = NSEClient.sharedInstance
    
    init() {
        client.setKey("bca7093ce9c023bb642d0734b29f1ad2")

        testGetAllBills()
    }
    
    var accountToAccess: Account = Account(accountId: "57d213d71fd43e204dd4841e", accountType:.CreditCard, nickname: "Hola", rewards: 10, balance: 100, accountNumber: "1234567890123456", customerId: "57d0c20d1fd43e204dd48282")
    var accountToPay: Account = Account(accountId: "123", accountType:.CreditCard, nickname: "Hola", rewards: 10, balance: 100, accountNumber: "1234567890123456", customerId: "")
    
    func testGetAllBills() {
        BillRequest().getAccountBills(accountToAccess.accountId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let array = response as Array<Bill>? {
                    if array.count > 0 {
                        let bill = array[0] as Bill!
                        print(array)
                        self.testGetBill(bill.billId)
                    } else {
                        print("No accounts found")
                    }
                }
            }
        })
    }
    
    func testGetBill(billId: String) {
        BillRequest().getBill(billId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let bill = response as Bill? {
                    print(bill)
                    self.testGetCustomerBills()
                }
            }
        })
    }
    
    func testGetCustomerBills() {
        BillRequest().getCustomerBills(accountToAccess.customerId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let array = response as Array<Bill>? {
                    if array.count > 0 {
                        print(array)
                        self.testPostBill()
                    } else {
                        print("No accounts found")
                    }
                }
            }
        })
    }
    
    func testPostBill() {
        let billToCreate = Bill(status: .Pending, payee: "Victor", nickname: "Nickname", creationDate: NSDate(), paymentDate: nil, recurringDate: 1, upcomingPaymentDate: NSDate(), paymentAmount: 123, accountId: accountToAccess.accountId)
        BillRequest().postBill(billToCreate, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let billResponse = response as BaseResponse<Bill>?
                let message = billResponse?.message
                let billCreated = billResponse?.object
                print("\(message): \(billCreated)")
                self.testPutBill(billCreated!)
            }
        })
    }

    func testPutBill(bill: Bill) {
        bill.payee = "Raul"
        BillRequest().putBill(bill, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let billResponse = response as BaseResponse<Bill>?
                let message = billResponse?.message
                print("\(message)")
                self.testDeleteBill(bill.billId)
            }
        })
    }
    
    func testDeleteBill(billId: String) {
        BillRequest().deleteBill(billId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let billResponse = response as BaseResponse<Bill>?
                let message = billResponse?.message
                print("\(message)")
            }
        })
    }
}

class BranchTests {
    let client = NSEClient.sharedInstance
    
    init() {
        client.setKey("bca7093ce9c023bb642d0734b29f1ad2")
        self.testGetBranches()
    }
    
    func testGetBranches() {
        BranchRequest().getBranches({(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let array = response as Array<Branch>? {
                    if array.count > 0 {
                        let branch = array[0] as Branch?
                        self.testGetBranch(branch!.branchId)
                        print(array)
                    } else {
                        print("No branches found")
                    }
                }
            }
        })
    }
    
    func testGetBranch(branchId: String) {
        BranchRequest().getBranch(branchId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let branch = response as Branch? {
                    print(branch)
                }
            }
        })
    }
}

class CustomerTests {
    let client = NSEClient.sharedInstance
    
    init() {
        client.setKey("bca7093ce9c023bb642d0734b29f1ad2")
        testGetCustomers()
    }
    
    func testGetCustomers() {
        CustomerRequest().getCustomers({(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let array = response as Array<Customer>? {
                    if array.count > 0 {
                        let customer = array[0] as Customer?
                        self.testGetCustomer(customer!.customerId)
                        print(array)
                    } else {
                        print("No accounts found")
                    }
                }
            }
        })
    }
    
    func testGetCustomer(customerId: String) {
        CustomerRequest().getCustomer(customerId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let customer = response as Customer? {
                    print(customer)
                    self.testGetCustomers(from: "57d20f881fd43e204dd48418")
                }
            }
        })
    }
    
    func testGetCustomers(from accountId: String) {
        CustomerRequest().getCustomer(from: accountId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let customer = response as Customer? {
                    print(customer)
                    self.testPostCustomer()
                }
            }
        })
    }
    
    func testPostCustomer() {
        let address = Address(streetName: "Street", streetNumber: "1", city: "City", state: "VA", zipCode: "12345")
        let customerToCreate = Customer(firstName: "Victor", lastName: "Lopez", address: address, customerId: "asd")
        CustomerRequest().postCustomer(customerToCreate, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let customerResponse = response as BaseResponse<Customer>?
                let message = customerResponse?.message
                let customerCreated = customerResponse?.object
                print("\(message): \(customerCreated)")
                self.testPutCustomer(customerCreated!)
            }
        })
    }
    
    func testPutCustomer(customerToBeModified: Customer) {
        customerToBeModified.firstName = "Raul"
        CustomerRequest().putCustomer(customerToBeModified, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let accountResponse = response as BaseResponse<Customer>?
                let message = accountResponse?.message
                let accountCreated = accountResponse?.object
                print("\(message): \(accountCreated)")
            }
        })
    }
}

//class DepositTests {
//    let client = NSEClient.sharedInstance
//    
//    init() {
//        client.setKey("2c54c85dc28e084930c0e06703711a14")
//        
//        testGetAllDeposits()
//    }
//    
//    var accountToAccess:Account!
//    
//    func testGetAllDeposits() {
//        
//        AccountRequest().getAccounts(nil, completion:{(response, error) in
//            if (error != nil) {
//                print(error)
//            } else {
//                let accountsArray = response as Array<Account>?
//                print(accountsArray)
//                
//                self.accountToAccess = accountsArray?[0]
//                self.testPostDeposit()
//            }
//        })
//    }
//    
//    func testGetOneDeposit(deposit:Transaction) {
//        DepositRequest(block: {(builder:DepositRequestBuilder) in
//            builder.requestType = HTTPType.GET
//            builder.depositId = deposit.transactionId
//        })?.send(completion: {(result:DepositResult) in
//            var depositResult = result.getDeposit()
//            print(depositResult, terminator: "")
//        })
//    }
//    
//    func testPostDeposit() {
//        DepositRequest(block: {(builder:DepositRequestBuilder) in
//            builder.requestType = HTTPType.POST
//            builder.amount = 10
//            builder.depositMedium = TransactionMedium.BALANCE
//            builder.description = "test"
//            builder.accountId = self.accountToAccess.accountId
//            
//        })?.send(completion: {(result) in
//            DepositRequest(block: {(builder:DepositRequestBuilder) in
//                builder.requestType = HTTPType.GET
//                builder.accountId = self.accountToAccess.accountId
//            })?.send(completion: {(result:DepositResult) in
//                var deposits = result.getAllDeposits()
//                
//                if deposits!.count > 0 {
//                    let depositToGet = deposits![deposits!.count-1]
//                    var depositToDelete:Transaction? = nil;
//                    for deposit in deposits! {
//                        if deposit.status == "pending" {
//                            depositToDelete = deposit
////                            self.testDeleteDeposit(depositToDelete)
//                        }
//                    }
//                    
//                    //                    self.testGetOneDeposit(depositToGet)
//                                        self.testPutDeposit(depositToDelete)
//                    
//                }
//            })
//
//        })
//    }
//    
//    func testPutDeposit(deposit:Transaction?) {
//        
//        if (deposit == nil) {
//            return
//        }
//        DepositRequest(block: {(builder:DepositRequestBuilder) in
//            builder.depositId = deposit!.transactionId
//            print(deposit!.status)
//            builder.requestType = HTTPType.PUT
//            builder.amount = 4300
//            builder.depositMedium = TransactionMedium.REWARDS
//            builder.description = "updated"
//            
//        })?.send(completion: {(result:DepositResult) in
////            self.testDeleteDeposit(deposit!)
//        })
//    }
//    
//    func testDeleteDeposit(deposit:Transaction?) {
//        DepositRequest(block: {(builder:DepositRequestBuilder) in
//            builder.depositId = deposit!.transactionId
//            print(deposit!.status)
//
//            builder.requestType = HTTPType.DELETE
//            builder.accountId = self.accountToAccess.accountId
//        })?.send(completion: {(result) in
//            
//        })
//    }
//}
//
//class PurchaseTests {
//    let client = NSEClient.sharedInstance
//    
//    init() {
//        client.setKey("2c54c85dc28e084930c0e06703711a14")
//        
//        testGetAllPurchases()
//    }
//    
//    var accountToAccess:Account!
//    
//    func testGetAllPurchases() {
//        
//        //get an account
//        AccountRequest().getAccounts(nil, completion:{(response, error) in
//            if (error != nil) {
//                print(error)
//            } else {
//                let accountsArray = response as Array<Account>?
//                print(accountsArray)
//
//                self.accountToAccess = accountsArray?[0]
//                self.testPostPurchase()
//            }
//        })
//    }
//    
//    func testGetOnePurchase(purchase:Transaction) {
//        PurchaseRequest(block: {(builder:PurchaseRequestBuilder) in
//            builder.requestType = HTTPType.GET
//            builder.purchaseId = purchase.transactionId
//        })?.send(completion: {(result:PurchaseResult) in
//            var purchaseResult = result.getPurchase()
//            print(purchaseResult, terminator: "")
//        })
//    }
//    
//    func testPostPurchase() {
//        PurchaseRequest(block: {(builder:PurchaseRequestBuilder) in
//            builder.requestType = HTTPType.POST
//            builder.amount = 10
//            builder.purchaseMedium = TransactionMedium.BALANCE
//            builder.description = "Victor"
//            builder.accountId = self.accountToAccess.accountId
//            builder.merchantId = "55e94a6af8d8770528e60f20"
//            builder.purchaseDate = "2015-10-10"
//            
//        })?.send(completion: {(result) in
//            PurchaseRequest(block: {(builder:PurchaseRequestBuilder) in
//                builder.requestType = HTTPType.GET
//                builder.accountId = self.accountToAccess.accountId
//            })?.send(completion: {(result:PurchaseResult) in
//                var purchases = result.getAllPurchases()
//                
//                if purchases!.count > 0 {
//                    let purchaseToGet = purchases![purchases!.count-1]
//                    var purchaseToDelete:Purchase? = nil;
//                    for purchase in purchases! {
//                        if purchase.status == "pending" {
//                            purchaseToDelete = purchase
////                            self.testDeletePurchase(purchaseToDelete)
//                        }
//                    }
//                    
//                    //self.testGetOnePurchase(purchaseToGet)
//                    self.testPutPurchase(purchaseToDelete)
//                    
//                }
//            })
//            
//        })
//    }
//    
//    func testPutPurchase(purchase:Purchase?) {
//        
//        if (purchase == nil) {
//            return
//        }
//        PurchaseRequest(block: {(builder:PurchaseRequestBuilder) in
//            builder.purchaseId = purchase!.purchaseId
//            print(purchase!.status)
//            builder.requestType = HTTPType.PUT
//            builder.amount = 4300
//            builder.purchaseMedium = TransactionMedium.REWARDS
//            builder.description = "updated"
//            builder.payerId = "55e94a6af8d8770528e60f20"
//        })?.send(completion: {(result:PurchaseResult) in
//            //            self.testDeletePurchase(purchase!)
//        })
//    }
//    
//    func testDeletePurchase(purchase:Purchase?) {
//        PurchaseRequest(block: {(builder:PurchaseRequestBuilder) in
//            builder.purchaseId = purchase!.purchaseId
//            print(purchase!.status)
//            
//            builder.requestType = HTTPType.DELETE
//            builder.accountId = self.accountToAccess.accountId
//        })?.send(completion: {(result) in
//            
//        })
//    }
//}
//
//class TransferTests {
//    let client = NSEClient.sharedInstance
//    
//    init() {
//        client.setKey("2c54c85dc28e084930c0e06703711a14")
//        
//        testGetAllTransfers()
//    }
//    
//    var accountToAccess:Account!
//    
//    func testGetAllTransfers() {
//        
//        //get an account
//        AccountRequest().getAccounts(nil, completion:{(response, error) in
//            if (error != nil) {
//                print(error)
//            } else {
//                let accountsArray = response as Array<Account>?
//                print(accountsArray)
//
//                self.accountToAccess = accountsArray?[0]
//                self.testPostTransfer()
//            }
//        })
//    }
//    
//    func testGetOneTransfer(transfer:Transfer) {
//        TransferRequest(block: {(builder:TransferRequestBuilder) in
//            builder.requestType = HTTPType.GET
//            builder.transferId = transfer.transferId
//        })?.send(completion: {(result:TransferResult) in
//            var transferResult = result.getTransfer()
//            print(transferResult, terminator: "")
//        })
//    }
//    
//    func testPostTransfer() {
//        TransferRequest(block: {(builder:TransferRequestBuilder) in
//            builder.requestType = HTTPType.POST
//            builder.amount = 10
//            builder.transferMedium = TransactionMedium.BALANCE
//            builder.description = "test"
//            builder.accountId = self.accountToAccess.accountId
//            builder.payeeId = "55e94a1af8d877051ab4f6c1"
//            
//        })?.send(completion: {(result) in
//            
//        })
//    }
//    
//    func testPutTransfer(transfer:Transfer?) {
//        
//        if (transfer == nil) {
//            return
//        }
//        TransferRequest(block: {(builder:TransferRequestBuilder) in
//            builder.transferId = transfer!.transferId
//            print(transfer!.status)
//            builder.requestType = HTTPType.PUT
//            builder.amount = 4300
//            builder.transferMedium = TransactionMedium.REWARDS
//            builder.description = "updated"
//            builder.payeeId = "55e94a1af8d877051ab4f6c2"
//        })?.send(completion: {(result:TransferResult) in
//            //            self.testDeleteTransfer(transfer!)
//        })
//    }
//    
//    func testDeleteTransfer(transfer:Transfer?) {
//        TransferRequest(block: {(builder:TransferRequestBuilder) in
//            builder.transferId = transfer!.transferId
//            print(transfer!.status)
//            
//            builder.requestType = HTTPType.DELETE
//            builder.accountId = self.accountToAccess.accountId
//        })?.send(completion: {(result) in
//            
//        })
//    }
//}
//
//class WithdrawalTests {
//    let client = NSEClient.sharedInstance
//    
//    init() {
//        client.setKey("2c54c85dc28e084930c0e06703711a14")
//        
//        testGetAllWithdrawals()
//    }
//    
//    var accountToAccess:Account!
//    
//    func testGetAllWithdrawals() {
//        
//        //get an account
//        AccountRequest().getAccounts(nil, completion:{(response, error) in
//            if (error != nil) {
//                print(error)
//            } else {
//                let accountsArray = response as Array<Account>?
//                print(accountsArray)
//
//                self.accountToAccess = accountsArray?[0]
//                self.testPostWithdrawal()
//            
//            }
//        })
//    }
//    
//    func testGetOneWithdrawal(withdrawal:Withdrawal) {
//        WithdrawalRequest(block: {(builder:WithdrawalRequestBuilder) in
//            builder.requestType = HTTPType.GET
//            builder.withdrawalId = withdrawal.withdrawalId
//        })?.send(completion: {(result:WithdrawalResult) in
//            var withdrawalResult = result.getWithdrawal()
//            print(withdrawalResult, terminator: "")
//        })
//    }
//    
//    func testPostWithdrawal() {
//        WithdrawalRequest(block: {(builder:WithdrawalRequestBuilder) in
//            builder.requestType = HTTPType.POST
//            builder.amount = 10
//            builder.withdrawalMedium = TransactionMedium.BALANCE
//            builder.description = "test"
//            builder.accountId = self.accountToAccess.accountId
//            
//        })?.send(completion: {(result) in
//            WithdrawalRequest(block: {(builder:WithdrawalRequestBuilder) in
//                builder.requestType = HTTPType.GET
//                builder.accountId = self.accountToAccess.accountId
//            })?.send(completion: {(result:WithdrawalResult) in
//                var withdrawals = result.getAllWithdrawals()
//                
//                if withdrawals!.count > 0 {
//                    let withdrawalToGet = withdrawals![withdrawals!.count-1]
//                    var withdrawalToDelete:Withdrawal? = nil;
//                    for withdrawal in withdrawals! {
//                        if withdrawal.status == "pending" {
//                            withdrawalToDelete = withdrawal
//                            //self.testDeleteWithdrawal(withdrawalToDelete)
//                        }
//                    }
//                    
//                    //self.testGetOneWithdrawal(withdrawalToGet)
//                    self.testPutWithdrawal(withdrawalToDelete)
//                    
//                }
//            })
//            
//        })
//    }
//    
//    func testPutWithdrawal(withdrawal:Withdrawal?) {
//        
//        if (withdrawal == nil) {
//            return
//        }
//        WithdrawalRequest(block: {(builder:WithdrawalRequestBuilder) in
//            builder.withdrawalId = withdrawal!.withdrawalId
//            print(withdrawal!.status)
//            builder.requestType = HTTPType.PUT
//            builder.amount = 4300
//            builder.withdrawalMedium = TransactionMedium.REWARDS
//            builder.description = "updated"
//        })?.send(completion: {(result:WithdrawalResult) in
//            //            self.testDeleteWithdrawal(withdrawal!)
//        })
//    }
//    
//    func testDeleteWithdrawal(withdrawal:Withdrawal?) {
//        WithdrawalRequest(block: {(builder:WithdrawalRequestBuilder) in
//            builder.withdrawalId = withdrawal!.withdrawalId
//            print(withdrawal!.status)
//            
//            builder.requestType = HTTPType.DELETE
//            builder.accountId = self.accountToAccess.accountId
//        })?.send(completion: {(result) in
//            
//        })
//    }
//}
//
//class MerchantTests {
//    let client = NSEClient.sharedInstance
//    
//    init() {
//        client.setKey("2c54c85dc28e084930c0e06703711a14")
//        
//        testMerchants()
//    }
//    
//    func testMerchants() {
//        
//        self.testPostMerchant()
//        
//        var merchantGetAllRequest = MerchantRequest(block: {(builder:MerchantRequestBuilder) in
//            builder.requestType = HTTPType.GET
//            builder.latitude = 38.9283
//            builder.longitude = -77.1753
//            builder.radius = "1000"
//        })
//        
//        merchantGetAllRequest?.send({(result:MerchantResult) in
//            var merchants = result.getAllMerchants()
//            print("Merchants fetched:\(merchants)\n", terminator: "")
//            var merchantID = merchants![0].merchantId
//            
//            self.testPutMerchant(merchants![0])
//            
//            var getOneMerchantRequest = MerchantRequest(block: {(builder:MerchantRequestBuilder) in
//                builder.requestType = HTTPType.GET
//                builder.merchantId = merchantID
//            })
//            
//            getOneMerchantRequest?.send({(result:MerchantResult) in
//                var merchant = result.getMerchant()
//                print("Merchant fetched:\(merchant)\n", terminator: "")
//            })
//            
//        })
//
//    }
//    
//    func testPutMerchant(merchant:Merchant?) {
//        
//        if (merchant == nil) {
//            return
//        }
//        MerchantRequest(block: {(builder:MerchantRequestBuilder) in
//            builder.merchantId = merchant!.merchantId
//            builder.requestType = HTTPType.PUT
//            builder.name = "Victorrrrr"
//            builder.address = Address(streetName: "1", streetNumber: "1", city: "1", state: "DC", zipCode: "12312")
//            builder.latitude = 38.9283
//            builder.longitude = -77.1753
//            
//        })?.send({(result:MerchantResult) in
//
//        })
//    }
//    
//    func testPostMerchant() {
//        
//        MerchantRequest(block: {(builder:MerchantRequestBuilder) in
//            builder.requestType = HTTPType.POST
//            builder.name = "Fun Merchant"
//            builder.address = Address(streetName: "1", streetNumber: "1", city: "1", state: "DC", zipCode: "12312")
//            builder.latitude = 38.9283
//            builder.longitude = -77.1753
//            
//        })?.send({(result:MerchantResult) in
//            
//        })
//    }
//}
//
//class TransactionTests {
//    let client = NSEClient.sharedInstance
//    
//    init() {
//        client.setKey("2c54c85dc28e084930c0e06703711a14")
//        
//        testGetAllTransactions()
//    }
//    
//    var accountToAccess:Account!
//    var accountToPay:Account!
//
//    func testGetAllTransactions() {
//        
//        //get an account
//        AccountRequest().getAccounts(nil, completion:{(response, error) in
//            if (error != nil) {
//                print(error)
//            } else {
//                let accountsArray = response as Array<Account>?
//                print(accountsArray)
//            
//                self.accountToAccess = accountsArray?[0]
//                self.accountToPay = accountsArray?[1]
//                
//                self.testPostTransaction()
//                
//                //test get all
//                TransactionRequest(block: {(builder:TransactionRequestBuilder) in
//                    builder.requestType = HTTPType.GET
//                    builder.accountId = self.accountToAccess.accountId
//                })?.send(completion: {(result:TransactionResult) in
//                    var transactions = result.getAllTransactions()
//                    
//                    let transactionToGet = transactions![0]
//                    var transactionToDelete:Transaction? = nil;
//                    for transaction in transactions! {
//                        if transaction.status == "pending" {
//                            transactionToDelete = transaction
//                        }
//                    }
//                    
//                    self.testGetOneTransaction(transactionToGet)
//                    self.testPutTransaction(transactionToDelete)
//                    
//                })
//            }
//        })
//    }
//    
//    func testGetOneTransaction(transaction:Transaction) {
//        TransactionRequest(block: {(builder:TransactionRequestBuilder) in
//            builder.requestType = HTTPType.GET
//            builder.accountId = self.accountToAccess.accountId
//            builder.transactionId = transaction.transactionId
//        })?.send(completion: {(result:TransactionResult) in
//            var transactionResult = result.getTransaction()
//        })
//    }
//    
//    func testPostTransaction() {
//        TransactionRequest(block: {(builder:TransactionRequestBuilder) in
//            builder.requestType = HTTPType.POST
//            builder.amount = 10
//            builder.transactionMedium = TransactionMedium.BALANCE
//            builder.description = "test"
//            builder.accountId = self.accountToAccess.accountId
//            builder.payeeId = self.accountToPay.accountId
//        })?.send(completion: {(result) in
//            
//        })
//    }
//    
//    func testPutTransaction(transaction:Transaction?) {
//        
//        if (transaction == nil) {
//            return
//        }
//        TransactionRequest(block: {(builder:TransactionRequestBuilder) in
//            builder.transactionId = transaction!.transactionId
//            print(transaction!.status)
//            builder.requestType = HTTPType.PUT
//            builder.accountId = self.accountToAccess.accountId
//            builder.transactionMedium = TransactionMedium.REWARDS
//            builder.description = "updated"
//            
//        })?.send(completion: {(result:TransactionResult) in
//            self.testDeleteTransaction(transaction!)
//        })
//    }
//    
//    func testDeleteTransaction(transaction:Transaction) {
//        TransactionRequest(block: {(builder:TransactionRequestBuilder) in
//            builder.transactionId = transaction.transactionId
//            print(transaction.status)
//            
//            builder.requestType = HTTPType.DELETE
//            builder.accountId = self.accountToAccess.accountId
//        })?.send(completion: {(result) in
//            
//        })
//    }
//}

class EnterpriseTests {
    let client = NSEClient.sharedInstance
    
    init() {
        client.setKey("2c54c85dc28e084930c0e06703711a14")
        
        testEnterpriseGets()
    }
    
    func testEnterpriseGets() {
//        EnterpriseAccountRequest()?.send({(result:AccountResult) in
//            var accounts = result.getAllAccounts()
//            var bills = 0
//            for tmp in accounts! {
//                if (tmp.billIds != nil) {
//                    bills += tmp.billIds!.count
//                }
//            }
//            EnterpriseAccountRequest(accountId: accounts![0].accountId)?.send({(result:AccountResult) in
//                var account = result.getAccount()
//            })
//        })
        
//        EnterpriseBillRequest()?.send({(result:BillResult) in
//            var bills = result.getAllBills()
//            var x:NSMutableSet = NSMutableSet()
//            for bill in bills! {
//                x.addObject(bill.billId)
//            }
//            EnterpriseBillRequest(billId: bills![0].billId)?.send({(result:BillResult) in
//                var bill = result.getBill()
//            })
//        })
        
//        EnterpriseCustomerRequest()?.send({(result:CustomerResult) in
//            var customers = result.getAllCustomers()
//            EnterpriseCustomerRequest(customerId: customers![0].customerId)?.send({(result:CustomerResult) in
//                var customer = result.getCustomer()
//            })
//        })
        
        EnterpriseTransferRequest()?.send({(result:TransferResult) in
            var transfers = result.getAllTransfers()
            print("\(transfers)\n", terminator: "")
            EnterpriseTransferRequest(transactionId: transfers![0].transferId)?.send({(result:TransferResult) in
                var transfer = result.getTransfer()
                print("\(transfer)\n", terminator: "")
            })
        })
        EnterpriseDepositRequest()?.send({(result:DepositResult) in
            var deposits = result.getAllDeposits()
            print("\(deposits)\n", terminator: "")
            EnterpriseDepositRequest(transactionId: deposits![0].transactionId)?.send({(result:DepositResult) in
                var deposit = result.getDeposit()
                print("\(deposit)\n", terminator: "")
            })
        })
        EnterpriseWithdrawalRequest()?.send({(result:WithdrawalResult) in
            var withdrawals = result.getAllWithdrawals()
            print("\(withdrawals)\n", terminator: "")
            EnterpriseWithdrawalRequest(transactionId: withdrawals![0].withdrawalId)?.send({(result:WithdrawalResult) in
                var withdrawal = result.getWithdrawal()
                print("\(withdrawal)\n", terminator: "")
            })
        })
        EnterpriseMerchantRequest()?.send({(result:MerchantResult) in
            var merchants = result.getAllMerchants()
            print("\(merchants)\n", terminator: "")
            EnterpriseMerchantRequest(merchantId: merchants![0].merchantId)?.send({(result:MerchantResult) in
                var merchant = result.getMerchant()
                print("\(merchant)\n", terminator: "")
            })
        })
    }
}


