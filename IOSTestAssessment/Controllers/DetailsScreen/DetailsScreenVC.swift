//
//  DetailsScreenVC.swift
//  IOSTestAssessment
//
//  Created by Keyur barvaliya on 27/04/24.
//

import UIKit

class DetailsScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableview: UITableView!{
        didSet {
            tableview.register(UINib.init(nibName: "DetailsTBVcell", bundle: nil), forCellReuseIdentifier: "DetailsTBVcell")
            tableview.register(UINib.init(nibName: "CommentDetailsTBVCell", bundle: nil), forCellReuseIdentifier: "CommentDetailsTBVCell")
        }
    }
    
    var selectedPostsInfo:HomeScreenInfoData? = nil
    var commentList:[CommentDetailsData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.tintColor = .white
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        if let getPOstsID = self.selectedPostsInfo?.id {
            self.commentAPICalling(postsID: "\(getPOstsID)")
        }
    }
    
    //MARK: - Tableview delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Total Comments: \(self.commentList.count)"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30.0
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return self.commentList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let infoCell = self.tableview.dequeueReusableCell(withIdentifier: "DetailsTBVcell", for: indexPath) as! DetailsTBVcell
            infoCell.lblID.text = "#\(self.selectedPostsInfo?.id ?? 0)"
            infoCell.lblTitle.text = self.selectedPostsInfo?.title ?? ""
            infoCell.lblDesc.text = self.selectedPostsInfo?.body ?? ""
            return infoCell
        }else {
            let commentDetailsCell = self.tableview.dequeueReusableCell(withIdentifier: "CommentDetailsTBVCell", for: indexPath) as! CommentDetailsTBVCell
            let commentDetails = self.commentList[indexPath.row]
            
            commentDetailsCell.lblEmail.text = commentDetails.email ?? ""
            commentDetailsCell.lblName.text = commentDetails.name ?? ""
            commentDetailsCell.lblComment.text = commentDetails.body ?? ""
            return commentDetailsCell
        }
        
    }
    
    //MARK: Comments API Calling
    func commentAPICalling(postsID:String) {
        iOSTestAssessmentAPI().apiGetPostCommentListRequest(postID: postsID) { result in
            switch result {
            case .success(let success):
                JSN.log("success ==>%@", success)
                self.commentList = success ?? []
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                if self.commentList.count == 0 {
                    self.showAlert(title: "No comments available!", actionText1: "OK") { okAction in
                        
                    }
                }
            case .failure(let failure):
                JSN.log("failur ==>%@", failure.localizedDescription)
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
