//
//  Main2VC.swift
//  UniversityExam
//
//  Created by Chang Chin-Ming on 05/09/2017.
//  Copyright © 2017 JimmyChang.UniversityExam. All rights reserved.
//

import UIKit

class Main2VC: MainVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        handleRotation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if dataStatus == Int(examData.isStart.rawValue) ||  dataStatus == Int(examData.isFail.rawValue) {
            super.loadData()
        }
    }

    override func loadData() {
        if dataStatus == Int(examData.isFromAPI.rawValue) || dataStatus == Int(examData.isFromCache.rawValue) {
            guard let dataDic = JTools.loadObj(kExamData, d: nil) else {
                dataStatus = Int(examData.isFail.rawValue)
                BannerManager.shared().loadBanner("讀取失敗", success: false)
                return
            }
            self.loadUI(dataDic as! [String : Any])
        }
    }
    
    // MARK: - UICollectionViewDataSource    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
            imgName = "PicA_2"
            titleLabel.text = "國文"
//            titleLabel.textColor = JRedColor()
//            titleBGView.backgroundColor = JRedColor()
            break
        case "ENG":
            imgName = "PicB_2"
            titleLabel.text = "英文"
//            titleLabel.textColor = JOrangeColor()
//            titleBGView.backgroundColor = JOrangeColor()
            break
        case "MTHA":
            imgName = "PicF"
            titleLabel.text = "數學甲"
//            titleLabel.textColor = JYellowColor()
//            titleBGView.backgroundColor = JYellowColor()
            break
        case "MTHB":
            imgName = "PicG"
            titleLabel.text = "數學乙"
//            titleLabel.textColor = JGreenColor()
//            titleBGView.backgroundColor = JGreenColor()
            break
        case "HIS":
            imgName = "PicH"
            titleLabel.text = "歷史"
//            titleLabel.textColor = JIndigoColor()
//            titleBGView.backgroundColor = JIndigoColor()
            break
        case "GEO":
            imgName = "PicI"
            titleLabel.text = "地理"
//            titleLabel.textColor = JBlueColor()
//            titleBGView.backgroundColor = JBlueColor()
            break
        case "CIT":
            imgName = "PicJ"
            titleLabel.text = "公民與社會"
//            titleLabel.textColor = JVioletColor()
//            titleBGView.backgroundColor = JVioletColor()
            break
        case "PHY":
            imgName = "PicK"
            titleLabel.text = "物理"
//            titleLabel.textColor = JPinkColor()
//            titleBGView.backgroundColor = JPinkColor()
            break
        case "CME":
            imgName = "PicL"
            titleLabel.text = "化學"
//            titleLabel.textColor = JLightBlueColor()
//            titleBGView.backgroundColor = JLightBlueColor()
            break
        case "BIO":
            imgName = "PicM"
            titleLabel.text = "生物"
//            titleLabel.textColor = JBrownColor()
//            titleBGView.backgroundColor = JBrownColor()
            break
        default: break
        }
        imgView.image = JImage(imgName)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        case "MTHA":
            name = "數學甲"
            mainColor = JYellowColor()
            break
        case "MTHB":
            name = "數學乙"
            mainColor = JGreenColor()
            break
        case "HIS":
            name = "歷史"
            mainColor = JIndigoColor()
            break
        case "GEO":
            name = "地理"
            mainColor = JBlueColor()
            break
        case "CIT":
            name = "公民與社會"
            mainColor = JVioletColor()
            break
        case "PHY":
            name = "物理"
            mainColor = JPinkColor()
            break
        case "CME":
            name = "化學"
            mainColor = JLightBlueColor()
            break
        case "BIO":
            name = "生物"
            mainColor = JBrownColor()
            break
        default:
            mainColor = JMainColor()
            break
        }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = mainStoryboard.instantiateViewController(withIdentifier: "ContainVC") as! ContainVC
        myVC.titleStr = (yearBtn.titleLabel?.text)! + "指考" + name
        myVC.mainColor = mainColor
        let fileName = JTools.createName(str, year: yearBtn.titleLabel?.text, type: dic["type"] as! String)
        myVC.fileName = fileName!
        myVC.numberOfFiles = Int(dic["number"] as! String)!
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(myVC, animated: true)
        hidesBottomBarWhenPushed = false
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
