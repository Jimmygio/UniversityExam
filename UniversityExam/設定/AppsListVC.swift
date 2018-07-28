//
//  AppsListVC.swift
//  UniversityExam
//
//  Created by Chang Chin-Ming on 01/10/2017.
//  Copyright © 2017 JimmyChang.UniversityExam. All rights reserved.
//

import UIKit
import StoreKit

class AppsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SKStoreProductViewControllerDelegate {
    var dataArray = [Any]() //需要建立，不然在numberOfItemsInSection閃退
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.alwaysBounceVertical = true; //永保可滑動
        myTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        refreshControl.tintColor = JGrayColor()
        refreshControl.addTarget(self, action: #selector(refreshControlChanged), for: .valueChanged)
        myTableView.addSubview(refreshControl)
        handleRotation()
    }
    
    @IBAction func press_backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshControlChanged() {
        updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    func updateData() {
        JAPI.api_appList { (success, dataArray, errorStr) in
            self.refreshControl.endRefreshing()
            if success {
                self.dataArray = dataArray!
                JTools.saveObj(self.dataArray, key: kApplist)
                self.myTableView.reloadData()
            } else {
                self.loadCache()
            }
        }
    }
    
    func loadCache() {
        guard let tempArray = JTools.loadObj(kApplist, d: nil) else {
            return
        }
        dataArray = [tempArray]
        self.myTableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for:indexPath as IndexPath)
        
        let dic = dataArray[row] as! [String:String]
        
        let imgView = cell.viewWithTag(50) as! UIImageView
        JTools.imgURL("\(kNormalLink)\(dic["picPath"]!)", target: imgView, fromWeb: false) { (status, img) in
            if status == 0 {
                imgView.nameTag = ""
                imgView.image = nil
            }
        }
        
        let nameLabel = cell.viewWithTag(51) as! UILabel
        nameLabel.text = dic["tcName"]
        
        let typeLabel = cell.viewWithTag(52) as! UILabel
        typeLabel.text = dic["tcType"]

        let getBtn = cell.viewWithTag(53) as! UIButton
        getBtn.setTitle(dic["tcBuy"], for: .normal)
        getBtn.blockAction(kUIButtonBlockTouchUpInside) {
            let SPVC = SKStoreProductViewController()
            SPVC.delegate = self
            SPVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:dic["itunesID"]!], completionBlock: { (result, error) in
                if (error != nil) {
                    print("Error = \(String(describing: error?.localizedDescription))")
                } else {
                    self.present(SPVC, animated: true, completion: {})
                }
            })
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        let row = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    // MARK: - SKStoreProductViewControllerDelegate
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true) {}
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        winSize = size
        handleRotation()
    }
    
    func handleRotation() {
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
