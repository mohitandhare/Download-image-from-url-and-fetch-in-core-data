//
//  ViewController.swift
//  Download image from url and fetch in core data
//
//  Created by Developer Skromanglobal on 14/07/22.
//

import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var homeData = [HomeData]()
    
    var array = ["1","1","1","1","1",]
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        
        
        GetData()
        
        
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        
    }
    
    
    
    
    //MARK: ===== HOME FETCH FROM CORE DATA =====
    
    func HomeFetch() {
        
        let request = HomeData.fetchRequest()
        
        do {
            
            let sort = NSSortDescriptor(key: "homeName", ascending: true)
            
            request.sortDescriptors = [ sort]
            
            homeData = try managedObjextContext.fetch(request)
            
            DispatchQueue.main.async {
                
            }
        }
        
        catch {
            print(error.localizedDescription)
            
        }
    }
    
    //MARK: ===== SAVE TO CORE DATA =====
    
    func SaveData() {
        do {
            
            try managedObjextContext.save()
        }
        catch {
            print("Error To Save Data")
        }
    }
    
    //MARK: ===== DELETE HOME DATA FROM CORE DATA =====
    
    func DeleteHomeDataFunc() {
        
        let homeFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HomeData")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: homeFetchRequest)
        
        do {
            try managedObjextContext.execute(deleteRequest)
            
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    
}




extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


extension ViewController {
    
    func GetData() {
        
        
        //        let userId = KeychainWrapper.standard.string(forKey: "userId")
        
        let syncDataParameters : Parameters = [
            
//            "userId" : "User_id-Igxyow8sk"
            "userId" : "User_id-4jkD948AQ"
        ]
        
        
        AF.request("http://3.7.18.55:3000/skroman/Sync/sync_everything", method: .post, parameters: syncDataParameters, encoding: JSONEncoding.default, headers: nil).response { response in
            
            switch response.result
            {
            case .success(let data) :
                
                do {
                    
                    let jsonOne = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if let parseJson = jsonOne!["syncData"] as? [[String: AnyObject]]  {
                        
                        for HomeList in parseJson {
                            
                            let saveHomeList = HomeData(context: self.managedObjextContext)
                            
                            let homeName = HomeList["homeName"] as? String
                            let homeImage = HomeList["homeImage"] as? String
                            
                            
                            saveHomeList.homeName = homeName
                            saveHomeList.homeImage = homeImage
                            
                            let Test_Url_String = homeImage
                            
                            let url = NSURL(string: Test_Url_String!)
                            
                            saveHomeList.imageUrl = url as URL?
                            
                        }
                        
                        print("HERE  IS JSON RESPONSE : ==== ",parseJson)
                        
                            
                            self.DeleteHomeDataFunc()
                            self.SaveData()
                            self.HomeFetch()
                            self.tableView.reloadData()

                            
                        
                        
                        
                        
                    }
                    
                }
                catch {
                    
                }
                
            case .failure(let err):
                print(err.localizedDescription)
            }
            
        }.resume()
        
    }
}


extension ViewController {
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.label.text = homeData[indexPath.row].homeName
        cell.Home_Image.downloaded(from: homeData[indexPath.row].imageUrl!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let saveHomeList = HomeData(context: self.managedObjextContext)
        
        let urlstring = "http://3.7.18.55:3000/skroman/homeapi/homeImage/1657793242844--home_icon.png"
        let url = NSURL(string: urlstring)
        print("the url = \(url!)")
        
        
        saveHomeList.imageUrl = url as URL?
        
        
        SaveData()
        
        
    }
    
}
