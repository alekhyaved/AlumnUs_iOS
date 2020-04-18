//
//  HomeViewController.swift
//  AlumnUs
//
//  Created by Juhi Nayak on 3/4/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//@IBOutlet weak var messageButton: UIBarButtonItem!
    
   
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var Message: UIBarButtonItem!
    //    @IBOutlet weak var MessageButton: UITabBarItem!
    
//    
  
//    @IBAction func MessageTapped(_ sender: Any) {
//    
//        print("you tapped message button, insert functionality here")
////        let uid = Auth.auth().currentUser?.uid
////        print ("uid", uid!)
////        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
////
////            print (snapshot)
////            if let dictionary = snapshot.value as? [String:AnyObject]{
////                self.navigationItem.title = dictionary["username"] as? String
////            }
////        }, withCancel: nil)
//    
//    }
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        // self.performSegue(withIdentifier: "logOutSegue", sender: self)
        let mainViewC =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewController)
        as? ViewController
        
        view.window?.rootViewController = mainViewC
        view.window?.makeKeyAndVisible()
        
    }
    
    
    var tableView:UITableView!
       
       var posts = [Post]()
        var moreFetching = false
        var reachedEnd = false
    let leadingScreenForBatchhing:CGFloat = 3.0
       
       override func viewDidLoad() {
           super.viewDidLoad()
        
        print("view did load!!")
           tableView = UITableView(frame: view.bounds, style: .plain)
           
           let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
           tableView.register(cellNib, forCellReuseIdentifier: "postCell")
           tableView.backgroundColor = UIColor(white: 0.90,alpha:1.0)
           view.addSubview(tableView)
           
           var layoutGuide:UILayoutGuide!
           
           if #available(iOS 11.0, *) {
               layoutGuide = view.safeAreaLayoutGuide
           } else {
               // Fallback on earlier versions
               layoutGuide = view.layoutMarginsGuide
           }
           
           tableView.translatesAutoresizingMaskIntoConstraints = false
           tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
           tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
           tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
           tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
           
           tableView.delegate = self
           tableView.dataSource = self
           tableView.reloadData()
           
           //observePosts()
            beginBatchFetch()
           
       }
       
    func fetchPosts(completion: @escaping(_ posts: [Post])->()) {
           let postsRef = Database.database().reference().child("posts")
        
        let lastPost = self.posts.last
        var queryRef: DatabaseQuery
        if lastPost == nil{
                queryRef = postsRef.queryOrdered(byChild: "timestamp").queryLimited(toLast: 20)
        }
        else{
            let lastTimeStamp = lastPost!.createdAt.timeIntervalSince1970 * 1000
            queryRef = postsRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastTimeStamp).queryLimited(toLast: 20)
        }
           
        queryRef.observeSingleEvent(of: .value, with: { snapshot in
            
            var tempPosts = [Post]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let author = dict["author"] as? [String:Any],
                    let uid = author["uid"] as? String,
                    let username = author["username"] as? String,
                    let photoURL = author["photoURL"] as? String,
                    let url = URL(string:photoURL),
                    let text = dict["text"] as? String,
                    let timestamp = dict["timestamp"] as? Double,
                    let addedPhoto = dict["addPhotoURL"] as? String,
                    let addURL = URL(string: addedPhoto){
                    
                    if childSnapshot.key != lastPost?.id {
                        let userProfile = UserProfile(uid: uid, username: username, photoURL: url)
                        let post = Post(id: childSnapshot.key, author: userProfile, text: text, timestamp:timestamp, addedPhotoURL: addURL)
                                        tempPosts.insert(post, at: 0)
                    }
                    
                   
                }
            }
            
            return completion(tempPosts)
            //self.posts = tempPosts
            //self.tableView.reloadData()
            
        })

       }
       
       func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return posts.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
           cell.set(post: posts[indexPath.row])
           return cell
       }
    
    func viewDidScroll(_ scrollView: UIScrollView){
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offSetY > contentHeight - scrollView.frame.size.height * leadingScreenForBatchhing {
            if !moreFetching && !reachedEnd {
                beginBatchFetch()
                }
            }
        }
    
    func beginBatchFetch(){
        moreFetching = true
        fetchPosts{ newPosts in
            self.posts.append(contentsOf: newPosts)
            self.reachedEnd = newPosts.count == 0
            self.moreFetching = false
            self.tableView.reloadData()
        }
        
    }
}
