//
//  SettingVC.swift
//  UniversityExam
//
//  Created by Chang Chin-Ming on 30/09/2017.
//  Copyright © 2017 JimmyChang.UniversityExam. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI

class SettingVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SKStoreProductViewControllerDelegate, MFMailComposeViewControllerDelegate {
    let array = ["移除廣告", "清除緩存", "版本", "評分", "分享", "客戶服務", "我的App"]
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        myTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        handleRotation()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cellName = ""
        if row != 2 {
            cellName = "myCell"
        } else {
            cellName = "versionCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for:indexPath as IndexPath)
        
        let nameLabel = cell.viewWithTag(50) as! UILabel
        nameLabel.text = array[row]
        
        switch row {
        case 0:
            break
        case 1:
            break
        case 2:
            let versionLabel = cell.viewWithTag(51) as! UILabel
            versionLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            break
        case 3:
            break
        case 4:
            break
        case 5:
            break
        case 6:
            break
            
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        
        switch row {
        case 0:
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = mainStoryboard.instantiateViewController(withIdentifier: "IAPVC") as! IAPVC
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(myVC, animated: true)
            hidesBottomBarWhenPushed = false
            break
        case 1: //清除緩存
            goClearCache()
            break
        case 2: //版本
            break
        case 3: //評分
            goScore()
            break
        case 4: //分享
            goShare()
            break
        case 5: //客戶服務
            goEmail()
            break
        case 6: //我的App
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = mainStoryboard.instantiateViewController(withIdentifier: "AppsListVC") as! AppsListVC
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(myVC, animated: true)
            hidesBottomBarWhenPushed = false
            break
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func goClearCache() {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                          FileManager.SearchPathDomainMask.userDomainMask, true).first!
        removeCache(path: docPath)
        
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                            FileManager.SearchPathDomainMask.userDomainMask, true).first!
        removeCache(path: cachePath)
        
        BannerManager.shared().loadBanner("清除成功", success: true)
    }
    
    func removeCache(path: String)  {
        do {
            let filesArray = try FileManager.default.contentsOfDirectory(atPath: path)
            for file in filesArray {
                do {
                    print("Remove path = \(String(describing: path))/\(file)")
                    try FileManager.default.removeItem(atPath: "\(String(describing: path))/\(file)")
                } catch {
                    print("removeItem error = \(error)")
                }
            }
        } catch {
            print("contentsOfDirectory error = \(error)")
        }
    }
    
    func goScore() {
        let SPVC = SKStoreProductViewController()
        SPVC.delegate = self
        SPVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:kAppId], completionBlock: { (result, error) in
            if (error != nil) {
                print("Error = \(String(describing: error?.localizedDescription))")
            } else {
                self.present(SPVC, animated: true, completion: {})
            }
        })
    }
    
    // MARK: - SKStoreProductViewControllerDelegate
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true) {}
    }
    
    func goShare() {
        let shareObj = ["您好，推薦\"學測指考考古題\"這個App給您：", URL(string: "https://itunes.apple.com/app/id\(kAppId)?mt=8") as Any] as [Any]
        let myVC = UIActivityViewController(activityItems: shareObj, applicationActivities: nil)
        myVC.setValue("推薦\"學測指考考古題\"", forKey: "subject")
        JTools.topViewController().present(myVC, animated: true) {}
    }
    
    func goEmail() {
        let myMail = MFMailComposeViewController() //光下這一行當無法寄email就會跳alert告知了
        if MFMailComposeViewController.canSendMail() {
            myMail.mailComposeDelegate = self
            myMail.setSubject("問題回報")
            myMail.setToRecipients([kMyEmail])
            myMail.setMessageBody("你好:\n      我有 \"學測指考考古題\"App的問題想要回報。\n", isHTML: false)
            myMail.modalTransitionStyle = .flipHorizontal
            present(myMail, animated: true, completion: {})
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true) {}
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
