//
//  MoviesViewController.swift
//  stc-Movies
//
//  Created by Reham on 06/03/2018.
//  Copyright © 2018 reham. All rights reserved.
//

import UIKit
import AFNetworking
//import "MBProgressHUD.h"
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var movies: [NSDictionary]?
    var apiKey = "c809800854a757de0334ab14d4f6cfde"
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
   
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  moviesTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! movieTableViewCell
    
        let movie = movies![indexPath.row]
        let name = movie["title"] as! String
        let overview = movie["overview"] as! String
        let poster = movie["poster_path"] as! String
        // there is no genre in the db !
      //  let genre = movie["genre_ids"] as! String
        
        let baseurl = "http://image.tmdb.org/t/p/w500"
        let imageURL = NSURL (string: baseurl + poster)
        
        cell.titleLable.text = name
        cell.overViewLable.text = overview
        cell.posterImage.setImageWith(imageURL! as URL)
        //cell.genre.text = genre
        print ("row\(indexPath.row)")
        print (cell)
        return cell
    }
    

    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var searchText: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
      
        apiMovie()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func apiMovie()
    {
        
        let apiKey = "c809800854a757de0334ab14d4f6cfde"
        let url = NSURL (string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        
        let request = NSURLRequest(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
        
        let session = URLSession (configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask (with: request as URLRequest, completionHandler: {(dataOrNil, response, error) in
            if let data = dataOrNil {
                if let resposeDectionry = try! JSONSerialization.jsonObject ( with: data, options:[]) as? NSDictionary { print("resonse\(resposeDectionry)")
                    self.movies = resposeDectionry["results"] as? [NSDictionary]
                    self.moviesTableView.reloadData()
                }
            }
        })
        task.resume()

    }
    

  // serch
    /*
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let cell =  moviesTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: IndexPath) as! movieTableViewCell

        var movie: [movieTableViewCell] = []
        if !searchText.isEmpty {
            let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
            
            let request = NSURLRequest(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
            
            let session = URLSession (configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
            
            
            MBProgressHUD.hide(for: self.view, animated: true)
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let task : URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        NSLog("response: \(responseDictionary)")
                        let movies = responseDictionary.value(forKeyPath: "results") as! NSArray
                        self.movies = movies.map({
                            (movie) -> movieTableViewCell in
                            return movieTableViewCell(
                                url: ( cell.titleLable.text, cell.overViewLable.text),
                                title: movie["title"] as! String,
                                overview: movie["overview"] as! String,
                                releaseDate: movie["release_date"] as! String
                            )
                        })
                        self.moviesTableView.reloadData()
                        if self.refreshControl != nil {
                            self.refreshControl!.endRefreshing()
                        }
                    }
                }
            });
            
            task.resume()
        } else {
            refresh()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        refresh()
    }
    
    func setApi(newApi: String) {
        self.apiKey = newApi
        refresh()
    }
    
    func refresh() {
        if refreshControl != nil {
            refresh(refreshControl: refreshControl!)
        }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        let cell =  moviesTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: IndexPath) as! movieTableViewCell

        var moviess: [movieTableViewCell] = []

        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(api)?api_key=\(apiKey)&page=\(page)")
        let request = NSURLRequest(url: url! as URL)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.hide(for: self.view, animated: true)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    NSLog("response: \(responseDictionary)")
                    let movies = responseDictionary.value(forKeyPath: "results") as! NSArray
                    self.movies = movies.map({
                        (movie) -> movieTableViewCell in
                        return movieTableViewCell(
                            url: (movie["poster_path"] as? String) ?? (movie["backdrop_path"] as? String),
                            title: movie["title"] as! String,
                            overview: movie["overview"] as! String,
                            releaseDate: movie["release_date"] as! String
                        )
                    })
                    self.moviesTableView.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        });
        
        task.resume()
    }*/

}
