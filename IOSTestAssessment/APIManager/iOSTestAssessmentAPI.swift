//
//  iOSTestAssessmentAPI.swift
//  IOSTestAssessment
//
//  Created by Keyur barvaliya on 26/04/24.
//

import Foundation


class iOSTestAssessmentAPI:NSObject {
    func apiPostsListRequest(page:Int,_limit:Int = 20,isShowLoader:Bool = true,result: @escaping(Result<[HomeScreenInfoData]?,Error>) -> Void) {
        let createPosturl = "\(endPoint.posts.rawValue)?_page=\(page)&_limit=\(_limit)"
        ApiManager.shared.get(endpoint: createPosturl, completion: result)
    }
    
    func apiGetPostCommentListRequest(postID:String,isShowLoader:Bool = true,result: @escaping(Result<[CommentDetailsData]?,Error>) -> Void) {
        let createPosturl = "\(endPoint.posts.rawValue)/\(postID)/comments"
        ApiManager.shared.get(endpoint: createPosturl, completion: result)
    }
}
