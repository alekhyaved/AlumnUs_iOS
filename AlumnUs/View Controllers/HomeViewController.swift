//
//  HomeViewController.swift
//  AlumnUs
//
//  Created by Juhi Nayak on 3/4/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    var tableView: UITableView!
    
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
    
    
    var posts = [
        Post(id: "1", author: "Juhi Nayak", text: "Oh hello!"),
        Post(id: "2", author: "Luke Skywalker", text: "I did not like the Last Jedi! Because I did not get to use my awesome Jedi powers!"),
        Post(id: "3", author: "Mickey Mouse", text: "Hi There! Meet me someday at the disneyland")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor(white: 0.90,alpha:1.0)
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        view.addSubview(tableView)
        
        var layoutGuide: UILayoutGuide
        layoutGuide = view.safeAreaLayoutGuide
        
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive =  true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
     
       
    @IBAction func logOutTapped(_ sender: Any) {
        try! Auth.auth().signOut()
               // self.performSegue(withIdentifier: "logOutSegue", sender: self)
               let mainViewC =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewController)
               as? ViewController
               
               view.window?.rootViewController = mainViewC
               view.window?.makeKeyAndVisible()
    }
    
    }


