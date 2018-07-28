//
//  MainVC.swift
//  UniversityExam
//
//  Created by Chang Chin-Ming on 02/09/2017.
//  Copyright © 2017 JimmyChang.UniversityExam. All rights reserved.
//

import UIKit
import GoogleMobileAds

enum examData : Int32 {
    case isStart = 0
    case isFromAPI = 1
    case isFromCache = 2
    case isFail = 3
}

class MainVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var yearArray:[Any]!
    var allDataArray:[Any]!
    var dataArray = [Any]() //需要建立，不然在numberOfItemsInSection閃退
    let cell_H:CGFloat = 100
    
    var selectedYear = String()
    
    @IBOutlet weak var yearBtn: UIButton!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myCollectionView_bottom: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerView_H: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        myCollectionView.alwaysBounceVertical = true; //永保可滑動
        
        print("self = \(self)")
        print("tabBarController?.viewControllers?[0] = \(String(describing: tabBarController?.viewControllers?[0]))")
        loadData()
        
        if UserDefaults.standard.bool(forKey: kRemoveAdOK) == false {
            print("kAdMobID = \(kAdMobID)")
            bannerView.adUnitID = kAdMobID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            view.addSubview(bannerView)
        } else {
            bannerView_H.constant = 0;
            myCollectionView_bottom.constant = 0
        }
        
        print("\(winSize.height)")
        handleRotation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if dataStatus == Int(examData.isFail.rawValue) {
            loadData()
        }
    }
    
    func removeAD() {
        print("bannerView = \(bannerView)")
        //這邊需檢查nil，因為怕Main2VC還沒建立會全部為nil
        if bannerView != nil {
            bannerView.removeFromSuperview()
        }
        if bannerView_H != nil {
            bannerView_H.constant = 0
        }
        if myCollectionView_bottom != nil {
            myCollectionView_bottom.constant = 0
        }
    }
    
    func loadData() {
        JAPI.api_exam { (success, dataDic, errorStr) in
            if success {
                dataStatus = Int(examData.isFromAPI.rawValue)
                JTools.saveObj(dataDic, key: kExamData)
                self.loadUI(dataDic as! [String : Any])
            } else {
                self.loadCache()
            }
        }
    }
    
    func loadCache() {
        guard let dataDic = JTools.loadObj(kExamData, d: nil) else {
            dataStatus = Int(examData.isFail.rawValue)
            BannerManager.shared().loadBanner("讀取失敗", success: false)
            return
        }
        dataStatus = Int(examData.isFromCache.rawValue)
        self.loadUI(dataDic as! [String : Any])
    }
    
    func loadUI(_ myDataDic: [String:Any]) {
        if self is Main2VC {
            yearArray = myDataDic["year1"] as! Array
            allDataArray = myDataDic["data1"] as! Array
            selectedYear = kSelectedYear1
        } else {
            yearArray = myDataDic["year0"] as! Array
            allDataArray = myDataDic["data0"] as! Array
            selectedYear = kSelectedYear0
        }
        
        let index = Int(JTools.loadIntDefault(selectedYear, d: nil))
        let yearStr = yearArray[index] as! String
        if yearStr.contains("_") {
            yearBtn.setTitle(yearStr.components(separatedBy: "_").first! + "學年(補考)", for: .normal)
        } else {
            yearBtn.setTitle(yearStr + "學年", for: .normal)
        }
        loadUI2(yearStr)
    }
    
    func loadUI2(_ yearStr:String) {
        //只留下該學年的
        dataArray = allDataArray.filter { (dic) -> Bool in
            let year = (dic as! [String:Any])["year"] as! String
            let number = (dic as! [String:Any])["number"] as! String
            return year == yearStr && number != "0"
        }
        print("yearStr = \(yearStr), dataArray = \(dataArray)")
        myCollectionView.reloadData()
    }
    
    @IBAction func press_yearBtn(_ sender: UIButton) {
        if yearArray == nil {
            return
        }
        let ac = UIAlertController(title: "選擇年份",
                                   message: nil,
                                   preferredStyle: UIAlertControllerStyle.actionSheet)
        for i in 0 ..< yearArray.count {
            var yearStr = yearArray[i] as! String
            if yearStr.contains("_") {
                yearStr = yearStr.components(separatedBy: "_").first! + "(補考)"
            }
            let action = UIAlertAction(title: yearStr,
                                       style: UIAlertActionStyle.default,
                                       handler: { (UIAlertAction) in
                                        JTools.saveIntDefault(Int32(i), key: self.selectedYear)
                                        if yearStr.contains("(補考)") {
                                            self.yearBtn.setTitle(yearStr.replacingOccurrences(of: "(補考)", with: "學年(補考)"), for: .normal)
                                        } else {
                                            self.yearBtn.setTitle(yearStr + "學年", for: .normal)
                                        }
                                        
                                        if self is Main2VC { //早期指考沒有"公民與社會"
                                            self.loadCache()
                                        } else {
                                            self.loadUI2(yearStr)
                                        }
            })
            ac.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        ac.addAction(cancelAction)
        ac.popoverPresentationController?.sourceView = yearBtn
        ac.popoverPresentationController?.sourceRect = yearBtn.bounds;
        self.present(ac, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for:indexPath as IndexPath)
        
        let imgView = cell.viewWithTag(50) as! UIImageView
        var imgName = ""
        
//        let titleBGView = cell.viewWithTag(51)!

        let titleLabel = cell.viewWithTag(52) as! UILabel
        
        let dic = dataArray[row] as! [String:Any]
        let str = dic["subject"] as! String
        switch str {
        case "CHI":
            imgName = "PicA"
            titleLabel.text = "國文"
//            titleLabel.textColor = JRedColor()
//            titleBGView.backgroundColor = JRedColor()
            break
        case "ENG":
            imgName = "PicB"
            titleLabel.text = "英文"
//            titleLabel.textColor = JOrangeColor()
//            titleBGView.backgroundColor = JOrangeColor()
            break
        case "MTH":
            imgName = "PicC"
            titleLabel.text = "數學"
//            titleLabel.textColor = JYellowColor()
//            titleBGView.backgroundColor = JYellowColor()
            break
        case "SOC":
            imgName = "PicD"
            titleLabel.text = "社會"
//            titleLabel.textColor = JGreenColor()
//            titleBGView.backgroundColor = JGreenColor()
            break
        case "NAT":
            imgName = "PicE"
            titleLabel.text = "自然"
//            titleLabel.textColor = JBlueColor()
//            titleBGView.backgroundColor = JBlueColor()
            break
        default: break
        }

        
        imgView.image = JImage(imgName)
        
        return cell
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        var name = ""
        var mainColor:UIColor
        
        let dic = dataArray[row] as! [String:Any]
        let str = dic["subject"] as! String
        switch str {
        case "CHI":
            name = "國文"
            mainColor = JRedColor()
            break
        case "ENG":
            name = "英文"
            mainColor = JOrangeColor()
            break
        case "MTH":
            name = "數學"
            mainColor = JYellowColor()
            break
        case "SOC":
            name = "社會"
            mainColor = JGreenColor()
            break
        case "NAT":
            name = "自然"
            mainColor = JIndigoColor()
            break
        default:
            mainColor = JMainColor()
            break
        }
        
        print("dic = \(dic)")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = mainStoryboard.instantiateViewController(withIdentifier: "ContainVC") as! ContainVC
        myVC.titleStr = (yearBtn.titleLabel?.text)! + "學測" + name
        myVC.mainColor = mainColor
        let fileName = JTools.createName(str, year: yearBtn.titleLabel?.text, type: dic["type"] as! String)
        myVC.fileName = fileName!
        myVC.numberOfFiles = Int(dic["number"] as! String)!
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(myVC, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:cell_H, height:cell_H);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var count = winSize.width/cell_H
        let remainder = winSize.width.truncatingRemainder(dividingBy: cell_H)
        var offset = remainder/(count+1)
        if count > 5 {
            count = 5
            offset = (winSize.width-cell_H*count)/(count+1)
        }
        return UIEdgeInsetsMake(offset, offset, offset, offset);
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        var count = winSize.width/cell_H
        let remainder = winSize.width.truncatingRemainder(dividingBy: cell_H)
        var offset = remainder/(count+1)
        if count > 5 {
            count = 5
            offset = (winSize.width-cell_H*count)/(count+1)
        }
        return offset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        var count = winSize.width/cell_H
        let remainder = winSize.width.truncatingRemainder(dividingBy: cell_H)
        var offset = remainder/(count+1)
        if count > 5 {
            count = 5
            offset = (winSize.width-cell_H*count)/(count+1)
        }
        return offset
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        winSize = size
//        print("winSize = \(winSize.width), \(winSize.height)");
        //若Tabbar沒點過指考，但旋轉時Main2VC一樣會觸發此，但Storyboard上的物件是nil，會閃退
        if myCollectionView != nil {
            myCollectionView.collectionViewLayout.invalidateLayout()
        }
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
}
