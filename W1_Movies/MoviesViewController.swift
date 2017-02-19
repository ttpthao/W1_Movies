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

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var gridView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var switchViewMode: UISegmentedControl!
    
    let refreshControl = UIRefreshControl()
    
    var movies = [NSDictionary]()
    var filteredMovies = [NSDictionary]()
    let baseUrl = "http://image.tmdb.org/t/p/w500"
    var endpoint: String!
    var prevSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        gridView.delegate = self
        gridView.dataSource = self
        searchBar.delegate = self

        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        moviesTableView.addSubview(refreshControl)
        
        self.errorImage.image = UIImage(named: "error")
        
        moviesTableView.isHidden = false
        gridView.isHidden = true
        
        fetchData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchViewMode(_ sender: AnyObject) {
        moviesTableView.isHidden = sender.selectedSegmentIndex == 1
        gridView.isHidden = sender.selectedSegmentIndex == 0
        
        if (sender.selectedSegmentIndex == 0) {
            moviesTableView.insertSubview(refreshControl, at: 0)
            moviesTableView.reloadData()
        } else {
            gridView.insertSubview(refreshControl, at: 0)
            gridView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        //cell.textLabel?.text = movies[indexPath.row]["title"] as! String
        
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieCell
        
        cell.titleLabel.text = filteredMovies[indexPath.row]["title"] as? String
        cell.summaryLabel.text = filteredMovies[indexPath.row]["overview"] as? String
        let imgUrl = baseUrl + (filteredMovies[indexPath.row]["poster_path"] as! String)
        cell.posterImg.setImageWith(NSURL(string: imgUrl) as! URL)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridMoviesCell", for: indexPath) as? MoviesGridCell {
            
            let imgUrl = baseUrl + (filteredMovies[indexPath.row]["poster_path"] as! String)
            cell.posterImgView.setImageWith(NSURL(string: imgUrl) as! URL)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchData()
    }
    
    func fetchData(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "http://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")
        let request = URLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        errorView.isHidden = true
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                             completionHandler: { (dataOrNil, response, error) in
                                if let data = dataOrNil {
                                    if let responseDictionary = try! JSONSerialization.jsonObject(
                                        with: data, options:[]) as? NSDictionary {
                                        self.movies = responseDictionary["results"] as! [NSDictionary]
                                        self.filteredMovies = self.movies
                                        print("response: \(self.movies)")
                                        
                                        if (self.switchViewMode.selectedSegmentIndex == 0) {
                                            self.moviesTableView.reloadData()
                                        } else {
                                            self.gridView.reloadData()
                                        }
                                        self.refreshControl.endRefreshing()
                                    }
                                } else {
                                    self.refreshControl.endRefreshing()
                                    self.errorView.isHidden = false
                                }
                MBProgressHUD.hide(for: self.view, animated: true)
                                
            })
        task.resume()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        prevSearch = searchText
        if (searchText == "") {
            filteredMovies = movies
            searchBar.resignFirstResponder()
        } else {
            filteredMovies = searchText.isEmpty ? movies : movies.filter({ (movie: NSDictionary) in
                let title = movie["title"] as! String
                let summary = movie["overview"] as! String
                return title.localizedCaseInsensitiveContains(searchText) || summary.localizedCaseInsensitiveContains(searchText)
            })
        }
        
        if (switchViewMode.selectedSegmentIndex == 0) {
            moviesTableView.reloadData()
        } else {
            gridView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailsViewController
        let movieDetails: NSDictionary
        if (sender is UITableViewCell) {
            let cell = sender as! UITableViewCell
            let indexPath = moviesTableView.indexPath(for: cell)
            movieDetails = filteredMovies[indexPath!.row]
            
            //moviesTableView.deselectRow(at: indexPath!, animated: true)
        } else {
            let cell = sender as! UICollectionViewCell
            let indexPath = gridView.indexPath(for: cell)
            movieDetails = filteredMovies[indexPath!.row]
        }
        
        detailVC.movie = movieDetails
    }
}
