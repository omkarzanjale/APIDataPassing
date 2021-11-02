//
//  ViewController.swift
//  APIDataPassing
//
//  Created by Mac on 28/09/21.
//
/*
 Program - Take take from API "https://jsonplaceholder.typicode.com/posts" and display its id and title on cell on selecting perticular cell navigate that data to to second page and display it.
 */

import UIKit

class ViewController: UIViewController {
    //
    //MARK: Outlets
    //
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pleaseWaitLabel: UILabel!
    
    var postsArray = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "API Data"
        apiData(){ posts in
            self.postsArray = posts
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    //
    //MARK: API Method
    //
    typealias complisherHandler = (_ posts: [Post])->()
    
    private func apiData(postsClosure: @escaping complisherHandler){
        var posts = [Post]()
        let apiString = "https://jsonplaceholder.typicode.com/posts"
        //Url
        if let apiURL = URL(string: apiString){
            //configuraring Session
            let session = URLSession(configuration: .default)
            //data task
            let dataTask = session.dataTask(with: apiURL) { [weak self] dataFromServer, response, error in
                guard let data = dataFromServer else{
                    DispatchQueue.main.async {
                        self?.pleaseWaitLabel.text = "No Internet"
                    }
                    return
                }
                guard let json = try? JSONSerialization.jsonObject(with: data, options: [])as? [[String:Any]] else{
                    print("JSon not working")
                    return
                }
                //accessing data one by one through for loop
                for data in json {
                    let post = Post(userId: (data["userId"]as? Int) ?? 0, id: (data["id"]as? Int) ?? 0, title: (data["title"]as? String) ?? "", body: (data["body"]as? String) ?? "")
                    posts.append(post)
                    
                }//for loop end
                postsClosure(posts)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.pleaseWaitLabel.text = "Data From API"
                }
            }//closure end
            dataTask.resume()
        }else{
            print("Invalid URL")
        }
    }//apiData method end
}
//
//MARK: UITableViewDataSource
//
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)as? CustomCell {
            let post = postsArray[indexPath.row]
            cell.idLabel.text = String(post.id)
            cell.titleLabel.text = String(post.title)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
//
//MARK: UITableViewDelegate
//
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = postsArray[indexPath.row]
        if let secondViewControllerObj = storyboard?.instantiateViewController(withIdentifier: "SecondViewController")as? SecondViewController{
            secondViewControllerObj.titleData = post.title
            secondViewControllerObj.bodyData =  post.body
            navigationController?.pushViewController(secondViewControllerObj, animated: true)
        }else{
            print("Missing SecondViewCOntroller")
        }
    }
}
