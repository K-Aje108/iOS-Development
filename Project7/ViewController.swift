//
//  ViewController.swift
//  Project7
//
//  Created by Kanyin Aje on 26/06/2020.
//  Copyright © 2020 Kanyin Aje. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
//            let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
//
//            if let url = URL(string: urlString) {
//                if let data = try? Data(contentsOf: url) {//This returns the content from a URL, but it might throw an error (i.e., if the internet connection was down) so we need to use try?.
//                   parse(json: data) // we're OK to parse!
//                }
//            }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(credits))
          navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filter))
        
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
           /// urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            /// urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
          DispatchQueue.global(qos: .userInitiated).async {
             if let url = URL(string: urlString) {//The URL(string:) initializer is a failable one because you might type an invalid URL by accident.
            if let data = try? Data(contentsOf: url) {///blocks execution of any further code
                self.parse(json: data)
                self.filteredPetitions = self.petitions
                return///now returning from aync() closure
            }
          }
            self.showError()
            //performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
          
    }
       
    @objc func filter() {
     
        DispatchQueue.global(qos: .userInitiated).async { /// All are FIFO, meaning that each block of code will be taken off the queue in the order they were put in
            DispatchQueue.main.async {
                
           let ac = UIAlertController(title: "Enter:", message: nil, preferredStyle: .alert)
           ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
                guard let answer = ac?.textFields?[0].text else { return }
                self?.submit(answer)
               }
               ac.addAction(submitAction)
               self.present(ac, animated: true)
            }
        }
    }
    
    func submit(_ answer: String) {
        
        filteredPetitions.removeAll(keepingCapacity: true)
        for x in petitions {
            if x.title.contains(answer){
                filteredPetitions.append(x)
                tableView.reloadData()
    
            }
          }
        
    }
    
    @objc func credits() {
        let ac = UIAlertController(title: "Info from..", message: "We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func showError() {
        DispatchQueue.main.async {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder() // The JSONDecoder type does the hard work of converting JSON to Swift values.

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {//refers to petitions type rather than an instance of it.
            petitions = jsonPetitions.results
            DispatchQueue.main.async {
            self.tableView.reloadData()
                }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let vc = DetailViewController()
         vc.detailItem = filteredPetitions[indexPath.row]
         navigationController?.pushViewController(vc, animated: true)
     }

}//Broadly speaking, if you’re accessing any remote resource, you should be doing it on a background thread i.e., any thread that is not the main thread. If you're executing any slow code, you should be doing it on a background thread. If you're executing any code that can be run in parallel – e.g. adding a filter to 100 photos – you should be doing it on multiple background threads.
///async() – it means "run the following code asynchronously," i.e. don't block (stop what I'm doing right now) while it's executing. “How important” some code is depends on something called “quality of service”, or QoS, which decides what level of service this code should be given. Obviously at the top of this is the main queue, which runs on your main thread, and should be used to schedule any work that must update the user interface immediately even when that means blocking your program from doing anything else. But there are four background queues that you can use, each of which has their own QoS level set:
//
//User Interactive: this is the highest priority background thread, and should be used when you want a background thread to do work that is important to keep your user interface working. This priority will ask the system to dedicate nearly all available CPU time to you to get the job done as quickly as possible.
//User Initiated: this should be used to execute tasks requested by the user that they are now waiting for in order to continue using your app. It's not as important as user interactive work – i.e., if the user taps on buttons to do other stuff, that should be executed first – but it is important because you're keeping the user waiting.
//The Utility queue: this should be used for long-running tasks that the user is aware of, but not necessarily desperate for now. If the user has requested something and can happily leave it running while they do something else with your app, you should use Utility.
//The Background queue: this is for long-running tasks that the user isn't actively aware of, or at least doesn't care about its progress or when it completes.
//Those QoS queues affect the way the system prioritizes your work: User Interactive and User Initiated tasks will be executed as quickly as possible regardless of their effect on battery life, Utility tasks will be executed with a view to keeping power efficiency as high as possible without sacrificing too much performance, whereas Background tasks will be executed with power efficiency as its priority.
//
//GCD automatically balances work so that higher priority queues are given more time than lower priority ones, even if that means temporarily delaying a background task because a user interactive task just came in.
//
//There’s also one more option, which is the default queue. This is prioritized between user-initiated and utility, and is a good general-purpose choice while you’re learning.
