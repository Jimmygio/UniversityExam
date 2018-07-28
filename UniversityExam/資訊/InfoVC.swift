//
//  InfoVC.swift
//  UniversityExam
//
//  Created by Chang Chin-Ming on 25/09/2017.
//  Copyright © 2017 JimmyChang.UniversityExam. All rights reserved.
//

import UIKit

class InfoVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var dateArray:[Any]!
    var urlArray = [Any]() //需要建立，不然在numberOfItemsInSection閃退
    let cell_W:CGFloat = 140
    var dataOK:Bool = false
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        myCollectionView.alwaysBounceVertical = true; //永保可滑動
        refreshControl.tintColor = JGrayColor()
        refreshControl.addTarget(self, action: #selector(refreshControlChanged), for: .valueChanged)
        myCollectionView.addSubview(refreshControl)

        dateBtn.isHidden = true
        dateLabel.isHidden = true
        handleRotation()
    }
    
    @objc func refreshControlChanged() {
        updateData()
    }

    override func viewWillAppear(_ animated: Bool) {
        if dataOK == false {
            updateData()
        }
    }
    
    func updateData() {
        self.refreshControl.endRefreshing()
        JAPI.api_date { (success, dataDic, errorStr) in
            if success {
                JTools.saveObj(dataDic, key: kDateData)
                self.loadUI(dataDic as! [String : Any])
            } else {
                self.loadCache()
            }
        }
    }
    
    func loadCache() {
        guard let dataDic = JTools.loadObj(kDateData, d: nil) else {
            return
        }
        self.loadUI(dataDic as! [String : Any])
    }
    
    func loadUI(_ dataDic: [String:Any]) {
        dataOK = true
        
        dateArray = dataDic["date"] as! [Any]
        urlArray = dataDic["url"] as! [Any]
        
        let type = Int(JTools.loadIntDefault(kSelectedExam, d: nil))
        showDate(type)
        dateBtn.isHidden = false
        dateLabel.isHidden = false
        
        myCollectionView.reloadData()
    }
    
    func showDate(_ type:Int) {
        if type == 0 {
            self.dateBtn.setTitle("學測", for: .normal)
        } else {
            self.dateBtn.setTitle("指考", for: .normal)
        }
        var dateStr:String = ""
        for dic in dateArray {
            if ((dic as! NSDictionary)["type"] as! String) == "\(type)" {
                dateStr = (dic as! [String:Any])["date"] as! String
                break
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let examDate = dateFormatter.date(from: dateStr)
        let time = Int((examDate?.timeIntervalSinceNow)!/(60*60*24))
        dateLabel.text = "倒數\(time)天"
    }

    @IBAction func press_dateBtn(_ sender: UIButton) {
        let ac = UIAlertController(title: nil,
                                   message: nil,
                                   preferredStyle: UIAlertControllerStyle.actionSheet)
        let exam1 = UIAlertAction(title: "學測",
                                  style: UIAlertActionStyle.default,
                                  handler: { (UIAlertAction) in
                                    JTools.saveIntDefault(0, key: kSelectedExam)
                                    self.showDate(0)
        })
        ac.addAction(exam1)
        let exam2 = UIAlertAction(title: "指考",
                                  style: UIAlertActionStyle.default,
                                  handler: { (UIAlertAction) in
                                    JTools.saveIntDefault(1, key: kSelectedExam)
                                    self.showDate(1)
        })
        ac.addAction(exam2)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        ac.addAction(cancelAction)
        ac.popoverPresentationController?.sourceView = dateBtn
        ac.popoverPresentationController?.sourceRect = dateBtn.bounds;
        self.present(ac, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for:indexPath as IndexPath)
        
        let titleLabel = cell.viewWithTag(50) as! UILabel
        titleLabel.text = (urlArray[row] as! Dictionary)["name"]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        JTools.open(URL(string: ((urlArray[row] as! Dictionary<String, Any>)["url"]) as! String), vc: self)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:cell_W, height:44);
    }
    
    //CollectionView跟裡面的cell間的上下左右間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let count = winSize.width/cell_W
        let remainder = winSize.width.truncatingRemainder(dividingBy: cell_W)
        let offset = remainder/(count+1)
        return UIEdgeInsetsMake(offset, offset, offset, offset);
    }
    
    //cell跟cell間的上下最小間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let count = winSize.width/cell_W
        let remainder = winSize.width.truncatingRemainder(dividingBy: cell_W)
        let offset = remainder/(count+1)
        return offset
    }

    //cell跟cell間的左右最小間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let count = winSize.width/cell_W
        let remainder = winSize.width.truncatingRemainder(dividingBy: cell_W)
        let offset = remainder/(count+1)
        return offset
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
