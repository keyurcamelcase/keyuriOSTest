//
//  HomeScreenVC.swift
//  IOSTestAssessment
//
//  Created by Keyur barvaliya on 26/04/24.
//

import UIKit
import KRPullLoader

class HomeScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource, KRPullLoadViewDelegate {
    
    
    
    @IBOutlet weak var tableview: UITableView!{
        didSet {
            tableview.register(UINib.init(nibName: "HomeScreenDetailsTBVCell", bundle: nil), forCellReuseIdentifier: "HomeScreenDetailsTBVCell")
        }
    }
    var currentPageNumber:Int = 1
    var postList:[HomeScreenInfoData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = " Dashboard"
//        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor.maincolor
        
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        let refreshView = KRPullLoadView()
        refreshView.delegate = self
        self.tableview.addPullLoadableView(refreshView, type: .refresh)
        let loadMoreView = KRPullLoadView()
        loadMoreView.delegate = self
        self.tableview.addPullLoadableView(loadMoreView, type: .loadMore)
        self.apiGetList(page: 1)
        
    }
    
    //MARK:- Tableview Delegate And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "HomeScreenDetailsTBVCell", for: indexPath) as! HomeScreenDetailsTBVCell
        let infoDetails = self.postList[indexPath.row]
        cell.lblTitle.text = infoDetails.title ?? ""
        cell.lblID.text = "#\(infoDetails.id ?? 0)"
        cell.lblDesc.text = infoDetails.body ?? ""
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDetails = self.postList[indexPath.row]
        let detailsScreenObj = DetailsScreenVC()
        detailsScreenObj.selectedPostsInfo = postDetails
        self.navigationController?.pushViewController(detailsScreenObj, animated: true)
    }
    
    //MARK: - Pull loader delegate methods
    func pullLoadView(_ pullLoadView: KRPullLoader.KRPullLoadView, didChangeState state: KRPullLoader.KRPullLoaderState, viewType type: KRPullLoader.KRPullLoaderType) {
//        pullLoadView.activityIndicator.shouldHideToolbarPlaceholder = true
        pullLoadView.activityIndicator.hidesWhenStopped = true
        pullLoadView.activityIndicator.color = UIColor.maincolor
        
        switch state {
        case .none:
//            break
            pullLoadView.messageLabel.text = ""
//            pullLoadView.activityIndicator.color = .clear
//            pullLoadView.subviews.forEach { getveiw in
//                if getveiw.tag == 3999 {
//                    getveiw.removeFromSuperview()
//                }
//            }
            
        case let .pulling(offset, threshould):
            // JSN.log("pulling(offset, threshould) ==>%@,==>%@",offset,threshould)
            // JSN.log("offset value ===>%@", offset.x, offset.y)
            if offset.y > threshould {
//                pullLoadView.messageLabel.text = "Pull more. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            } else {
//                pullLoadView.messageLabel.text = "Release to refresh. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
//                self.homeWallpaperList = []
            }

        case let .loading(completionHandler):
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                pullLoadView.activityIndicator.stopAnimating()
                pullLoadView.activityIndicator.color = .clear
                completionHandler()
                if type == .refresh {
                    self.currentPageNumber = 1
                    self.apiGetList(page: 1)
                }else {
                    self.currentPageNumber = self.currentPageNumber + 1
                    self.apiGetList(page: self.currentPageNumber)
                }
            }
        }
    }
    
    
    //MARK: - API
    func apiGetList(page:Int) {
        
        iOSTestAssessmentAPI().apiPostsListRequest(page: page) { result in
            switch result {
            case .success(let success):
                JSN.log("success status ==>%@", success?.count)
                if (success ?? []).count == 0 {
                    self.currentPageNumber = self.currentPageNumber - 1
                    self.tableview.endEditing(true)
                }
                if page == 1 {
                    self.postList = success ?? []
                }else {
                    self.postList.append(contentsOf: success ?? [])
                }
                self.tableview.reloadData()
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            case .failure(let failure):
                JSN.error("failure ==>%@", failure.localizedDescription)
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
