//
//  ElephantViewController.swift
//  BountyList
//
//  Created by joonwon lee on 2020/03/04.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit

class AnimalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //let nameList = ["elephant1", "elephant2", "elephant3"]
    //let bountyList = ["코끼리송! 다 같이 불러봐요!", "코끼리는 얼마나 클까요?", "코끼리에게도 배꼽이 있을까요?"]
    var animalname:String = "";
    let infodic:[String:[String]] =
        ["코끼리": ["elephant1","코끼리송! 다 같이 불러봐요!","elephant2","코끼리는 얼마나 클까요?","elephant3","코끼리에게도 배꼽이 있을까요?"],
         "얼룩말": ["zebra1","마티와 함께 춤을 춰봐요!","zebra2","얼룩말송! 다 같이 불러봐요","zebra3","함께 조나단을 예쁘게 꾸며봐요!"]
    
    ]
//   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//       // DetailViewController 데이터 줄꺼에요
//       if segue.identifier == "showDetail" {
//           let vc = segue.destination as? DetailViewController
//           if let index = sender as? Int {
//               vc?.name = nameList[index]
//               vc?.name = bountyList[index]
//
//           }
//       }
//   }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DFGSDFGGGG : \(animalname)")
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infodic[animalname]!.count/2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        let img = UIImage(named: "\(infodic[animalname]![indexPath.row*2]).jpg")
        cell.imgView.image = img
        cell.nameLabel.text = infodic[animalname]![indexPath.row*2]
        cell.bountyLabel.text = "\(infodic[animalname]![indexPath.row*2 + 1])"
        return cell
        
    }
    
    // UITableViewDelegate
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("--> \(indexPath.row)")
//        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

               tableView.deselectRow(at: indexPath, animated: true)
               switch indexPath.row {
               case 0: UIApplication.shared.open(URL(string : "https://www.youtube.com/watch?v=cEZasQNLlOk")! as URL, options: [:], completionHandler: nil)

               case 1: UIApplication.shared.open(URL(string : "https://www.youtube.com/watch?v=oTEfxlwOJbI")! as URL, options: [:], completionHandler: nil)

               case 2: UIApplication.shared.open(URL(string : "https://www.youtube.com/watch?v=8VRr4xhno0U")! as URL, options: [:], completionHandler: nil)
               default:

                   return

               }

           }

}
  



class ListCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
    }


