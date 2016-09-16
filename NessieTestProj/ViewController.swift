//
//  ViewController.swift
//  NessieTestProj
//
//  Created by Lopez Vargas, Victor R. on 10/5/15.
//  Copyright (c) 2015 Nessie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func testAccountsCalls(sender: AnyObject) {
        let _ = AccountTests()
    }
    
    @IBAction func testAtmCalls(sender: AnyObject) {
        let _ = ATMTests()
    }
    
    @IBAction func testBill(sender: AnyObject) {
        let _ = BillTests()
    }
    
    @IBAction func testBranches(sender: AnyObject) {
        let _ = BranchTests()
    }
    
    @IBAction func testCustomers(sender: AnyObject) {
        let _ = CustomerTests()
    }

    @IBAction func testDeposits(sender: AnyObject) {
        let _ = DepositsTests()
    }
    
    @IBAction func testPurchases(sender: AnyObject) {
        let _ = PurchasesTests()
    }
    
    @IBAction func testMerchants(sender: AnyObject) {
        let _ = MerchantTests()
    }
    
    @IBAction func testTransfers(sender: AnyObject) {
        let _ = TransfersTests()
    }
    
    @IBAction func testWithdrawals(sender: AnyObject) {
        let _ = WithdrawalsTests()
    }
    
    @IBAction func testEnterpriseAccounts(sender: AnyObject) {
        let _ = EnterpriseAccountTests()
    }
}
