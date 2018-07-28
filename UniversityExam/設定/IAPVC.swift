//
//  IAPVC.swift
//  UniversityExam
//
//  Created by Chang Chin-Ming on 05/10/2017.
//  Copyright © 2017 JimmyChang.UniversityExam. All rights reserved.
//

import UIKit

class IAPVC: UIViewController, UITableViewDataSource, UITableViewDelegate, InAppPurchaseManagerDelegate {

    var iapManager = InAppPurchaseManager()
    var dataArray = ["30元移除廣告"]
    var productsArray = [Any]()

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var restoreBtn: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.alwaysBounceVertical = true; //永保可滑動
        myTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        iapManager.delegate = self
        let iapSet = NSSet(array: [kRemoveAdId])
        iapManager.loadStore(iapSet as! Set<AnyHashable>) { (array) in
            if array == nil {
                BannerManager.shared().loadBanner("讀取商品失敗", success: false)
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            self.productsArray = array!
            for obj in self.productsArray {
                let myProduct = obj as! SKProduct
                print("======myProduct======")
                print("title: \(myProduct.localizedTitle)")
                print("description: \(myProduct.localizedDescription)")
                print("price: \(myProduct.price)")
                print("id: \(myProduct.productIdentifier)")
            }
            
        }
        handleRotation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        SKPaymentQueue.default().remove(iapManager)
    }
    
    @IBAction func press_backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func press_restoreBtn(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: kRemoveAdOK) == false {
            if iapManager.canMakePurchases() == true {
                SKPaymentQueue.default().add(iapManager)
                SKPaymentQueue.default().restoreCompletedTransactions()
            } else {
                iap_Failed()
            }
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for:indexPath as IndexPath)
        
        let nameLabel = cell.viewWithTag(50) as! UILabel
        nameLabel.text = dataArray[row]
        
        if UserDefaults.standard.bool(forKey: kRemoveAdOK) == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        
        switch row {
        case 0:
            if UserDefaults.standard.bool(forKey: kRemoveAdOK) == false && productsArray.count > 0 {
                if iapManager.canMakePurchases() == true {
//                    SKPaymentQueue.default().remove(iapManager)
                    SKPaymentQueue.default().add(iapManager)
                    iapManager.purchase(productsArray[row] as! SKProduct)
                } else {
                    iap_Failed()
                }
            }

            break
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // MARK: - InAppPurchaseManagerDelegate
    func iap_Succeed(_ transaction: SKPaymentTransaction!) {
        BannerManager.shared().loadBanner("購買成功", success: true)
        updateNoAdUI()
        myTableView.reloadData()
    }

    func iap_RestoreSucceed() {
        BannerManager.shared().loadBanner("回復購買成功", success: true)
        updateNoAdUI()
        myTableView.reloadData()
    }
    
    func iap_Failed() {
        BannerManager.shared().loadBanner("購買失敗", success: false)
    }
    
    func updateNoAdUI() {
        let vc1 = (tabBarController?.viewControllers?[0] as! UINavigationController).viewControllers.first as! MainVC
        vc1.removeAD()
        
        let vc2 = (tabBarController?.viewControllers?[1] as! UINavigationController).viewControllers.first as! Main2VC
        vc2.removeAD()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        winSize = size
        handleRotation()
    }
    
    func handleRotation() {
    }

    override var prefersStatusBarHidden: Bool {
        return NSNumber(value: JTools.loadIntDefault(kStatusBarHidden, d: "")).boolValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
