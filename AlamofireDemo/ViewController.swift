import UIKit
import Alamofire

class ViewController: UIViewController
{
    @IBOutlet weak var cityTabV: UITableView!
    
    var cityArr = [String]()
    var stateDict = NSDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.Postalamofire()
    }
    
    func Postalamofire()
    {
        let param = ["request":"city_listing","device_type":"ios","country":"india"]
        
        AF.request("https://www.kalyanmobile.com/apiv1_staging/city_listing.php", method: .post,parameters: param).responseJSON { (resp) in
            print("Response Here")
            
            if let dict = resp.value as? NSDictionary
            {
                print("Response here \(dict)")
                
                if let respCode = dict.value(forKey: "responseCode") as? String, let respMsg = dict.value(forKey: "responseMessage") as? String
                {
                    if respCode == "success"
                    {
                        self.stateDict = dict.value(forKey: "city_array") as! NSDictionary
                        self.cityArr = self.stateDict.allKeys as! [String]
                        self.cityTabV.reloadData()
                        print("SUCCESS")
                    }
                    else
                    {
                        print("ERROR \(respMsg)")
                    }
                }
            }
        }
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.cityArr.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return self.stateDict.allKeys[section] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let val1 = stateDict.allKeys as! [String]
        let val2 = val1[section]
        cityArr = stateDict.value(forKey: "\(val2)") as! [String]
        return self.cityArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let val1 = stateDict.allKeys as! [String]
        let val2 = val1[indexPath.section]
        cityArr = stateDict.value(forKey: "\(val2)") as! [String]
        cell.textLabel?.text = cityArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
}
