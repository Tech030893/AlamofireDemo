import UIKit
import Alamofire
import Kingfisher

class ViewController2: UIViewController
{
    @IBOutlet weak var brandCollV: UICollectionView!
    
    var responseArr = [NSDictionary]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.BrandData()
    }
    
    func BrandData()
    {
        let param = ["request":"brand_listing","device_type":"ios","country":"india"]
        
        AF.request("https://www.kalyanmobile.com/apiv1_staging/brand_listing.php", method: .post, parameters: param).responseJSON { (resp) in
            print("Response Here")
            
            if let dict = resp.value as? NSDictionary
            {
                print("Response Here \(dict)")
                
                if let respCode = dict.value(forKey: "responseCode") as? String,let respMsg = dict.value(forKey: "responseMessage") as? String
                {
                    if respCode == "success"
                    {
                        self.responseArr = dict.value(forKey: "brand") as! [NSDictionary]
                        self.brandCollV.reloadData()
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

extension ViewController2: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return responseArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCVC", for: indexPath) as! BrandCVC
        let imgUrl = responseArr[indexPath.row].value(forKey: "brand_image_path")
        let url = URL(string: imgUrl as! String)
        
        cell.brandImgV.kf.setImage(with: url)
        cell.idLbl.text = responseArr[indexPath.row].value(forKey: "brand_id") as? String
        cell.nameLbl.text = responseArr[indexPath.row].value(forKey: "brand_name") as? String
        cell.discLbl.text = responseArr[indexPath.row].value(forKey: "brand_description") as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: floor((collectionView.frame.size.width-20)/2), height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

class BrandCVC: UICollectionViewCell
{
    @IBOutlet weak var brandImgV: UIImageView!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var discLbl: UILabel!
}
