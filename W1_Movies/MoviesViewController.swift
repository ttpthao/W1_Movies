//
//  MoviesViewController.swift
//  W1_Movies
//
//  Created by Phuong Thao Tran on 2/18/17.
//  Copyright © 2017 Phuong Thao Tran. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var moviesTableView: UITableView!
    var movies = [NSDictionary]()
    let baseUrl = "http://image.tmdb.org/t/p/w500"
    var selectedUrl = ""
    var selectedSummary = ""
    var selectedTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        // Do any additional setup after loading the view.
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "http://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                             completionHandler: { (dataOrNil, response, error) in
                                if let data = dataOrNil {
                                    if let responseDictionary = try! JSONSerialization.jsonObject(
                                        with: data, options:[]) as? NSDictionary {
                                        self.movies = responseDictionary["results"] as! [NSDictionary]
                                        print("response: \(self.movies)")
                                        self.moviesTableView.reloadData()
                                        MBProgressHUD.hide(for: self.view, animated: true)
                                    }
                                }
            })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        //cell.textLabel?.text = movies[indexPath.row]["title"] as! String
        
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieCell
        
        cell.titleLabel.text = movies[indexPath.row]["title"] as! String
        cell.summaryLabel.text = movies[indexPath.row]["overview"] as! String
        let imgUrl = baseUrl + (movies[indexPath.row]["poster_path"] as! String)
        cell.posterImg.setImageWith(NSURL(string: imgUrl) as! URL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUrl = baseUrl + (movies[indexPath.row]["poster_path"] as! String)
        selectedTitle = movies[indexPath.row]["title"] as! String
        selectedSummary = movies[indexPath.row]["overview"] as! String
        
        performSegue(withIdentifier: "detailsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! DetailsViewController
        nextVC.imgUrl = selectedUrl
        nextVC.movieTitle = selectedTitle
        nextVC.summary = selectedSummary
    }

}
