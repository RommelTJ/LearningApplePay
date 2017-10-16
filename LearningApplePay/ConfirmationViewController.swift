//
//  ConfirmationViewController.swift
//  LearningApplePay
//
//  Created by Rommel Rico on 10/16/17.
//  Copyright © 2017 Rommel Rico. All rights reserved.
//

import UIKit
import PassKit

class ConfirmationViewController: UIViewController {

    var paymentToken: PKPaymentToken!
    
    @IBOutlet weak var idLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.idLabel.text = self.paymentToken.transactionIdentifier
    }

}
