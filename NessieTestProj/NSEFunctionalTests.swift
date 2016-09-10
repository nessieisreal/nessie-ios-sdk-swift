
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
        CustomerRequest().getCustomer(accountId, completion:{(response, error) in
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

class DepositsTests {
    let client = NSEClient.sharedInstance
    
    init() {
        client.setKey("bca7093ce9c023bb642d0734b29f1ad2")
        
        testGetAllDepositsFromAccount()
    }
    
    var account: Account = Account(accountId: "57d213d71fd43e204dd4841e", accountType:.CreditCard, nickname: "Hola", rewards: 10, balance: 100, accountNumber: "1234567890123456", customerId: "57d0c20d1fd43e204dd48282")
    
    func testGetDeposit(DepositId: String) {
        DepositRequest().getDeposit(DepositId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let deposit = response as Deposit? {
                    print(deposit)
                    self.testPostDeposit()
                }
            }
        })
    }
    
    func testGetAllDepositsFromAccount() {
        DepositRequest().getDepositsFromAccountId(account.accountId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let array = response as Array<Deposit>? {
                    if array.count > 0 {
                        let deposit = array[0] as Deposit!
                        print(array)
                        self.testGetDeposit(deposit.depositId)
                    } else {
                        print("No deposits found")
                    }
                }
            }
        })
    }
    
    func testPostDeposit() {
        let depositToCreate = Deposit(depositId: "", status: .Pending, medium: .Balance, payeeId: "asd", amount: 1, type: "merchant", transactionDate: NSDate(), description: "Description")
        DepositRequest().postDeposit(depositToCreate, accountId: account.accountId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let depositResponse = response as BaseResponse<Deposit>?
                let message = depositResponse?.message
                let depositCreated = depositResponse?.object
                print("\(message): \(depositCreated)")
                self.testPutDeposit(depositCreated!)
            }
        })
    }
    
    func testPutDeposit(deposit: Deposit) {
        deposit.medium = .Rewards
        DepositRequest().putDeposit(deposit, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let depositResponse = response as BaseResponse<Deposit>?
                let message = depositResponse?.message
                print("\(message)")
                self.testDeleteDeposit(deposit.depositId)
            }
        })
    }
    
    func testDeleteDeposit(depositId: String) {
        DepositRequest().deleteDeposit(depositId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let DepositResponse = response as BaseResponse<Deposit>?
                let message = DepositResponse?.message
                print("\(message)")
            }
        })
    }
}

class PurchasesTests {
    let client = NSEClient.sharedInstance
    
    init() {
        client.setKey("bca7093ce9c023bb642d0734b29f1ad2")
        
        testGetAllPurchasesFromAccount()
    }
    
    var account: Account = Account(accountId: "57d32a5ce63c5995587e85ec",
                                   accountType:.CreditCard,
                                   nickname: "Hola",
                                   rewards: 10,
                                   balance: 100,
                                   accountNumber: "1234567890123456",
                                   customerId: "57d0c20d1fd43e204dd48282")
    let merchant: Merchant = Merchant(merchantId: "57cf75cea73e494d8675ec49",
                                      name: "Best Productions",
                                      category: ["Production"],
                                      address: Address(streetName: "Lafayette St.",
                                        streetNumber: "5901",
                                        city: "Brooklyn",
                                        state: "NY",
                                        zipCode: "07009"),
                                      geocode: Geocode(lng: -1, lat: 33))
    
    func testGetPurchase(PurchaseId: String) {
        PurchaseRequest().getPurchase(PurchaseId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let purchase = response as Purchase? {
                    print(purchase)
                    self.testPostPurchase()
                }
            }
        })
    }
    
    func testGetAllPurchasesFromMerchant() {
        PurchaseRequest().getPurchasesFromMerchantId(merchant.merchantId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let array = response as Array<Purchase>? {
                    if array.count > 0 {
                        print(array)
                    } else {
                        print("No purchases found")
                    }
                }
            }
            self.testGetAllPurchasesFromMerchantAndAccount()
        })
    }
    
    func testGetAllPurchasesFromAccount() {
        PurchaseRequest().getPurchasesFromAccountId(account.accountId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let array = response as Array<Purchase>? {
                    if array.count > 0 {
                        let purchase = array[0] as Purchase!
                        print(array)
                        self.testGetPurchase(purchase.purchaseId)
                    } else {
                        print("No purchases found")
                    }
                }
            }
        })
    }
    
    func testGetAllPurchasesFromMerchantAndAccount() {
        PurchaseRequest().getPurchasesFromMerchantAndAccountIds(merchant.merchantId, accountId: account.accountId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let array = response as Array<Purchase>? {
                    if array.count > 0 {
                        print(array)
                    } else {
                        print("No purchases found")
                    }
                }
            }
        })
    }

    func testPostPurchase() {
        let purchaseToCreate = Purchase(merchantId: "57cf75cea73e494d8675ec49", status: .Cancelled, medium: .Balance, payerId: account.accountId, amount: 4.5, type: "merchant", purchaseDate: NSDate(), description: "Description", purchaseId: "asd")
        PurchaseRequest().postPurchase(purchaseToCreate, accountId: account.accountId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let purchaseResponse = response as BaseResponse<Purchase>?
                let message = purchaseResponse?.message
                let purchaseCreated = purchaseResponse?.object
                print("\(message): \(purchaseCreated)")
                self.testPutPurchase(purchaseCreated!)
            }
        })
    }
    
    func testPutPurchase(purchase: Purchase) {
        purchase.medium = .Rewards
        PurchaseRequest().putPurchase(purchase, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let purchaseResponse = response as BaseResponse<Purchase>?
                let message = purchaseResponse?.message
                print("\(message)")
                self.testDeletePurchase(purchase.purchaseId)
            }
        })
    }
    
    func testDeletePurchase(purchaseId: String) {
        PurchaseRequest().deletePurchase(purchaseId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let PurchaseResponse = response as BaseResponse<Purchase>?
                let message = PurchaseResponse?.message
                print("\(message)")
                self.testGetAllPurchasesFromMerchant()
            }
        })
    }
}

class MerchantTests {
    let client = NSEClient.sharedInstance
    
    init() {
        client.setKey("bca7093ce9c023bb642d0734b29f1ad2")
        testGetMerchants()
    }
    
    func testGetMerchants() {
        MerchantRequest().getMerchants(completion: {(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let array = response as Array<Merchant>? {
                    if array.count > 0 {
                        let merchant = array[0] as Merchant?
                        self.testGetMerchant(merchant!.merchantId)
                        print(array)
                    } else {
                        print("No merchants found")
                    }
                }
            }
        })
    }
    
    func testGetMerchant(merchantId: String) {
        MerchantRequest().getMerchant(merchantId, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                if let merchant = response as Merchant? {
                    print(merchant)
                }
            }
            self.testPostMerchant()
        })
    }
    
    func testPostMerchant() {
        let address = Address(streetName: "Street", streetNumber: "1", city: "City", state: "VA", zipCode: "12345")
        let geocode = Geocode(lng: 1, lat: 0)
        let merchantToCreate = Merchant(merchantId: "", name: "Name", category: ["Cateogry"], address: address, geocode: geocode)
        MerchantRequest().postMerchant(merchantToCreate, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let merchantResponse = response as BaseResponse<Merchant>?
                let message = merchantResponse?.message
                let merchantCreated = merchantResponse?.object
                print("\(message): \(merchantCreated)")
                self.testPutMerchant(merchantCreated!)
            }
        })
    }
    
    func testPutMerchant(merchantToBeModified: Merchant) {
        merchantToBeModified.name = "Raul"
        MerchantRequest().putMerchant(merchantToBeModified, completion:{(response, error) in
            if (error != nil) {
                print(error)
            } else {
                let accountResponse = response as BaseResponse<Merchant>?
                let message = accountResponse?.message
                let accountCreated = accountResponse?.object
                print("\(message): \(accountCreated)")
            }
        })
    }
}
