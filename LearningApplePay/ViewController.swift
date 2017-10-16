//
//  ViewController.swift
//  LearningApplePay
//
//  Created by Rommel Rico on 10/15/17.
//  Copyright © 2017 Rommel Rico. All rights reserved.
//

import UIKit
import PassKit

class ViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    @IBOutlet weak var bottomToolbar: UIView!
    var paymentToken: PKPaymentToken!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the payment button programmatically.
        let paymentButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        paymentButton.addTarget(self, action: #selector(ViewController.buyNowButtonTapped(sender:)), for: .touchUpInside)
        bottomToolbar.addSubview(paymentButton)
        
        bottomToolbar.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .centerX, relatedBy: .equal, toItem: bottomToolbar, attribute: .centerX, multiplier: 1, constant: 0))
        bottomToolbar.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .centerY, relatedBy: .equal, toItem: bottomToolbar, attribute: .centerY, multiplier: 1, constant: 0))
    }

    @objc func buyNowButtonTapped(sender: UIButton) {
        // Networks that we want to accept.
        let paymentNetworks: [PKPaymentNetwork] = [.amex, .masterCard, .visa, .discover]
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            
            // This merchantIdentifier should have been created for you in Xcode.
            request.merchantIdentifier = "merchant.com.rommelrico.PlaygroundsAndViewModels"
            request.countryCode = "US" // Standard ISO country code. The country in which you make the charge.
            request.currencyCode = "USD" // Standard ISO currency code.
            request.supportedNetworks = paymentNetworks
            request.merchantCapabilities = .capability3DS
            
            // Set the items that you are charging for. The last item is the total amount you want to charge.
            let shinobiToySummaryItem = PKPaymentSummaryItem(label: "Shinobi Cuddly Toy", amount: 22.99, type: .final)
            let shinobiPostageSummaryItem = PKPaymentSummaryItem(label: "Postage", amount: 3.00, type: .final)
            let shinobiTaxSummaryItem = PKPaymentSummaryItem(label: "Tax", amount: 2.29, type: .final)
            let total = PKPaymentSummaryItem(label: "Total", amount: 29.27, type: .final)
            request.paymentSummaryItems = [shinobiToySummaryItem, shinobiPostageSummaryItem, shinobiTaxSummaryItem, total]
            
            // Create a PKPaymentAuthorizationViewController from the request.
            let authorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            
            // Set its delegate so we know the result of the payment authorization.
            authorizationViewController?.delegate = self
            
            // Show the authorizationViewController to the user.
            present(authorizationViewController!, animated: true, completion: nil)
        } else {
            // Apple Pay is unavailable for this payment network.
            print("Apple Pay is not available")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let confirmation = segue.destination as! ConfirmationViewController
        confirmation.paymentToken = paymentToken
    }


    // MARK: - PKPaymentAuthorizationViewControllerDelegate
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        paymentToken = payment.token
        
        // You would typically use a payment provider such as Stripe here.
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        
        // Once the payment is successful, show the user that the purchase is complete.
        self.performSegue(withIdentifier: "purchaseConfirmed", sender: self)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

