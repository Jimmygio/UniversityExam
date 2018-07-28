//
//  ContainVC.swift
//  UniversityExam
//
//  Created by Chang Chin-Ming on 05/09/2017.
//  Copyright © 2017 JimmyChang.UniversityExam. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

enum dlStatus : Int32 {
    case isStart = 0
    case isLoadOK = 1
    case isFail = 2
    case isDone = 3
}

class ContainVC: UIViewController, WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate, UIScrollViewDelegate {
    
    var titleStr = ""

    var examPDF = AsyncPDF()
    var ansPDF = AsyncPDF()
    var ans2PDF = AsyncPDF()
    
    var fileName = ""
    var numberOfFiles = 0
    var mainColor:UIColor!
    var currentBtnFlag = -1
    var isFullScreen = 0
    var examPDFOffset:CGFloat = 0
    
    let myWKWeb = WKWebView()
    var tapGes:UITapGestureRecognizer! //在這邊初始self會沒填進去
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navView_Y: NSLayoutConstraint!
    @IBOutlet weak var navView_H: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!

    @IBOutlet weak var examBtn: UIButton!
    @IBOutlet weak var ansBtn: UIButton!
    @IBOutlet weak var ans2Btn: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lineView_X: NSLayoutConstraint!
    @IBOutlet weak var myWebView: UIWebView!

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerView_H: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(handleData), name: NSNotification.Name(rawValue: kDatatReady), object: nil)
        
        titleLabel.text = titleStr
        examBtn.setTitleColor(mainColor, for: .normal)
        lineView.backgroundColor = mainColor

        if numberOfFiles < 3 {
            ans2Btn.isHidden = true
        }

        print("tapGes = \(tapGes)")
        tapGes = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGes(_:)))
        if #available(iOS 9.0, *) {
            myWebView = nil
            
            myWKWeb.uiDelegate = self;
            myWKWeb.navigationDelegate = self;
            myWKWeb.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
            myWKWeb.addObserver(self, forKeyPath: "title", options: .new, context: nil)
            view.addSubview(myWKWeb)
            
            myWKWeb.scrollView.delegate = self
            myWKWeb.addGestureRecognizer(tapGes)
            myWKWeb.translatesAutoresizingMaskIntoConstraints = false //重要，會影響Auto Layout
            
            //上
            let top:NSLayoutConstraint = NSLayoutConstraint(item: myWKWeb,
                                                            attribute: .top,
                                                            relatedBy:.equal,
                                                            toItem:navView,
                                                            attribute:.bottom,
                                                            multiplier:1.0,
                                                            constant: 0)
            myWKWeb.superview!.addConstraint(top)
            
            var bg:Any
            if #available(iOS 11.0, *){
                bg = view.safeAreaLayoutGuide
            }else {
                bg = view
            }
            
            if UserDefaults.standard.bool(forKey: kRemoveAdOK) {
                //下
                let bottom:NSLayoutConstraint = NSLayoutConstraint(item: myWKWeb,
                                                                   attribute: .bottom,
                                                                   relatedBy:.equal,
                                                                   toItem:bg,
                                                                    attribute:.bottom,
                                                                   multiplier:1.0,
                                                                   constant: 0)
                myWKWeb.superview!.addConstraint(bottom)
            } else {
                //下
                let bottom:NSLayoutConstraint = NSLayoutConstraint(item: myWKWeb,
                                                                   attribute: .bottom,
                                                                   relatedBy:.equal,
                                                                   toItem:bannerView,
                                                                   attribute:.top,
                                                                   multiplier:1.0,
                                                                   constant: 0)
                myWKWeb.superview!.addConstraint(bottom)
            }
            
            //右
            let right:NSLayoutConstraint = NSLayoutConstraint(item: myWKWeb,
                                                              attribute: .right,
                                                              relatedBy:.equal,
                                                              toItem:bg,
                                                              attribute:.right,
                                                              multiplier:1.0,
                                                              constant: 0)
            myWKWeb.superview!.addConstraint(right)
            
            //左
            let left:NSLayoutConstraint = NSLayoutConstraint(item: myWKWeb,
                                                              attribute: .left,
                                                              relatedBy:.equal,
                                                              toItem:bg,
                                                              attribute:.left,
                                                              multiplier:1.0,
                                                              constant: 0)
            myWKWeb.superview!.addConstraint(left)
            
        } else {
            myWebView.scrollView.delegate = self
            myWebView.addGestureRecognizer(tapGes)
        }
        self.press_examBtn(self.examBtn)
        print("tapGes = \(tapGes)")
        
        if UserDefaults.standard.bool(forKey: kRemoveAdOK) == false {
            print("kAdMobID = \(kAdMobID)")
            bannerView.adUnitID = kAdMobID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            view.addSubview(bannerView)
        } else {
            bannerView_H.constant = 0;
        }

        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        handleRotation()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handleTapGes(_ sender:UITapGestureRecognizer) {
        if isFullScreen == 0 { //小->大
            isFullScreen = 1
            if winSize.height == 812.0 { //iphone X直向
                examBtn.isHidden = true
                ansBtn.isHidden = true
                ans2Btn.isHidden = true
                lineView.isHidden = true
            }
            navView_Y.constant = -navView_H.constant
//            UIApplication.shared.isStatusBarHidden = true
            JTools.saveIntDefault(1, key: kStatusBarHidden)
            setNeedsStatusBarAppearanceUpdate()
        } else { //大->小
            isFullScreen = 0
            examBtn.isHidden = false
            ansBtn.isHidden = false
            ans2Btn.isHidden = false
            lineView.isHidden = false
            navView_Y.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (Bool) in
            if self.navView_Y.constant == 0 {
//                UIApplication.shared.isStatusBarHidden = false
                JTools.saveIntDefault(0, key: kStatusBarHidden)
                self.setNeedsStatusBarAppearanceUpdate()
            }
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as! WKWebView === myWKWeb {
            if keyPath == "loading" {
//                print("loading")
            } else if keyPath == "title" {
//                print("loatitleding")
            } else if keyPath == "URL" {
//                print("URL")
            } else if keyPath == "estimatedProgress" {
//                print("estimatedProgress")
//                let progress = change?[NSKeyValueChangeKey.newKey] as! Float
//                print("Float = \(progress)")
            }
        }
    }

    @IBAction func press_backBtn(_ sender: UIButton) {
        UIApplication.shared.isStatusBarHidden = false
        myWKWeb.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
        myWKWeb.removeObserver(self, forKeyPath: "title", context: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func press_shareBtn(_ sender: UIButton) {
        var myfileName = ""
        var myStatus:Int32 = 0
        switch currentBtnFlag {
        case 0:
            myfileName = "\(titleStr)考卷"
            myStatus = examPDF.dlStatus
            break
        case 1:
            myfileName = "\(titleStr)答案"
            myStatus = ansPDF.dlStatus
            break
        case 2:
            myfileName = "\(titleStr)非選擇"
            myStatus = ans2PDF.dlStatus
            break
        default: break
        }
        
        let path = JTools.getDocPath("\(myfileName).pdf")
        
        if myStatus == dlStatus.isLoadOK.rawValue || myStatus == dlStatus.isDone.rawValue {
            let objectsToShare = [URL(fileURLWithPath: path!)]
            let myVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            myVC.setValue(myfileName, forKey: "subject")
            present(myVC, animated: true) {}
            
            myVC.completionWithItemsHandler = {(type, flag, array, error) -> Swift.Void in}
        } else {
            JTools.alert("未下載完成，無法分享", message: nil, vc: self, block: { (array, success) in})
        }
    }
    
    @IBAction func press_examBtn(_ sender: UIButton) {
        if currentBtnFlag == 0 {return}
        loadHUD()
        currentBtnFlag = 0
        examBtn.setTitleColor(mainColor, for: .normal)
        ansBtn.setTitleColor(JGrayColor(), for: .normal)
        ans2Btn.setTitleColor(JGrayColor(), for: .normal)
        changeLineView_X(myX: 0)
        
        dlStatusToStart()
        examPDF.load(from: URL(string: "\(kPDFLink)CllExamApi/Exam/\(fileName)_E.pdf"), title: titleStr)
    }
    
    @IBAction func press_ansBtn(_ sender: UIButton) {
        if currentBtnFlag == 1 {return}
        loadHUD()
        currentBtnFlag = 1
        examBtn.setTitleColor(JGrayColor(), for: .normal)
        ansBtn.setTitleColor(mainColor, for: .normal)
        ans2Btn.setTitleColor(JGrayColor(), for: .normal)
        changeLineView_X(myX: 80)
        
        dlStatusToStart()
        ansPDF.load(from: URL(string: "\(kPDFLink)CllExamApi/Answer/\(fileName)_A1.pdf"), title: titleStr)
    }
    
    @IBAction func press_ans2Btn(_ sender: UIButton) {
        if currentBtnFlag == 2 {return}
        loadHUD()
        currentBtnFlag = 2
        examBtn.setTitleColor(JGrayColor(), for: .normal)
        ansBtn.setTitleColor(JGrayColor(), for: .normal)
        ans2Btn.setTitleColor(mainColor, for: .normal)
        changeLineView_X(myX: 160)
        
        dlStatusToStart()
        ans2PDF.load(from: URL(string: "\(kPDFLink)CllExamApi/Answer/\(fileName)_A2.pdf"), title: titleStr)
    }
    
    func loadHUD() {
        if #available(iOS 9.0, *) {
            JHUD.shared().load("讀取中", delay: 0, inView: myWKWeb)
        } else {
            JHUD.shared().load("讀取中", delay: 0, inView: myWebView)
        }
    }
    
    func dlStatusToStart() {
        examPDF.dlStatus = dlStatus.isStart.rawValue
        ansPDF.dlStatus = dlStatus.isStart.rawValue
        ans2PDF.dlStatus = dlStatus.isStart.rawValue
    }
    
    func changeLineView_X(myX:Float) -> Void {
        if lineView_X.constant != CGFloat(myX) {
            lineView_X.constant = CGFloat(myX)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }) { (Bool) in
            }
        }
    }
    
    @objc func handleData()  {
        let isStart = dlStatus.isStart.rawValue
        let isLoadOK = dlStatus.isLoadOK.rawValue
        let isFail = dlStatus.isFail.rawValue
        let isDone = dlStatus.isDone.rawValue
        
        if examPDF.dlStatus == isFail || ansPDF.dlStatus == isFail || ans2PDF.dlStatus == isFail {
            dlStatusToStart()
            BannerManager.shared().loadBanner("連線失敗，請稍候再試", success: false)
        }
        
        if examPDF.dlStatus == isLoadOK && currentBtnFlag == 0 {
            webViewLoadData(examPDF)
            examPDF.dlStatus = isDone
        } else if ansPDF.dlStatus == isLoadOK && currentBtnFlag == 1 {
            webViewLoadData(ansPDF)
            ansPDF.dlStatus = isDone
        } else if ans2PDF.dlStatus == isLoadOK && currentBtnFlag == 2 {
            webViewLoadData(ans2PDF)
            ans2PDF.dlStatus = isDone
        }
        if examPDF.dlStatus == isDone || examPDF.dlStatus == isStart &&
           ansPDF.dlStatus == isDone || ansPDF.dlStatus == isStart &&
           ans2PDF.dlStatus == isDone || ans2PDF.dlStatus == isStart {
            JHUD.shared().stop()
        }
        
        if currentBtnFlag == 0 {
            JDelay(0.1, {
                if #available(iOS 9.0, *) {
                    self.myWKWeb.scrollView.setContentOffset(CGPoint(x: 0, y: self.examPDFOffset), animated: false)
                } else {
                    self.myWebView.scrollView.setContentOffset(CGPoint(x: 0, y: self.examPDFOffset), animated: false)
                }
            })
        }
    }
    
    func webViewLoadData(_ myPDF:AsyncPDF) {
        print("myPDF.myData = \(myPDF.myData)")
        if #available(iOS 9.0, *) {
            myWKWeb.load(myPDF.myData!, mimeType: "application/pdf", characterEncodingName: "UTF-8", baseURL:  URL(string: "http://localhost")!)
        } else {
            myWebView.load(myPDF.myData!, mimeType: "application/pdf", textEncodingName: "UTF-8", baseURL:  URL(string: "http://localhost")!)
        }
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {}
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            webView.alpha = 1
        }) { (Bool) in
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {}
    
    // MARK: - WKUIDelegate
    //WKWebView的坑
    //http://www.jianshu.com/p/4745b009a4ec?nomobile=yes
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if (!((navigationAction.targetFrame?.isMainFrame)!)) {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    // MARK: - UIWebViewDelegate
    func webViewDidStartLoad(_ webView: UIWebView) {}
        
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            webView.alpha = 1
        }) { (Bool) in
        }
    }
        
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {}

    // MARK: - UIScrollViewDelegate
    //記錄考卷翻到第幾頁(彈性停止後)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if currentBtnFlag == 0 {
            examPDFOffset = scrollView.contentOffset.y
            print("examPDFOffset = \(examPDFOffset)")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        winSize = size
        handleRotation()
    }

    func handleRotation() {
        if isFullScreen == 0 { //小
            navView_Y.constant = 0
        } else { //大
            if winSize.height == 812.0 { //iphone X直向
                navView_Y.constant = -navView_H.constant-44
            } else {
                navView_Y.constant = -navView_H.constant
            }
        }
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
