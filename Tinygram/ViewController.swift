//
//  ViewController.swift
//  Test
//
//  Created by Alireza on 4/12/22.
//

import UIKit
import Alamofire
import Swiftagram

var instagramSecret: Secret!

class ViewController: UIViewController {

    let auth_header = [String : String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let controller = LoginViewController()
        controller.completion = { secret in
            controller.dismiss(animated: true)
            instagramSecret = secret
            
            DispatchQueue.main.async { [self] in
                guard let url = URL(string: "https://i.instagram.com/api/v1/friendships/375530557/followers/?count=3000&search_surface=follow_list_page") else {
                    return
                }
                AF.request(url,headers: HTTPHeaders(instagramSecret.header)).responseDecodable(of: Follower.self) { dataResponse in
                    switch dataResponse.result {
                        
                    case .success(let data):
                        print(data)
                        //                if let data = data as? Data {
                        //                }else{
                        //                    comple(.failure(.invalidDataType))
                        //                }
                    case .failure(let error):
                        print("getRequest error:", error)
                        //        error.responseCode   inja bayad handle she ba if bad ba comple pass bde b oonvar  oonvar fun marboote anjam she
                        
                    }
                }
            }
            
        }
        self.present(controller, animated: true)
    }
}


// MARK: - Follower
struct Follower: Codable {
    let users: [FollowUser]
    let status: String?
    let nextMaxID: String?
    let next_max_id: String?
    let next_maxID: String?
    
    func getMaxID()-> String? {
        if let id = nextMaxID {
            return id
        } else if let id = next_max_id {
            return id
        } else if let id = next_maxID {
            return id
        } else {
            return "Not found"
        }
    }
}

// MARK: - User
struct FollowUser: Codable {
    let pk: Int?
    let username, full_name: String?
    let is_private: Bool?
    let profile_pic_url: String?
    let profile_pic_id: String?
    let is_verified: Bool?
    let follow_friction_type: Int?
    
}
