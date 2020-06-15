//
//  ViewController.swift
//  project
//
//  Created by gtrash12 on 2020/06/02.
//  Copyright © 2020 COMP420. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

class ViewController: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var classificationLabel: UILabel!
    var outputname:String = "";
    
    var dic:[String:String] = [
        "ox":"소"
        ,"camel":"낙타"
        ,"cheetah":"치타"
        ,"zebra":"얼룩말"
        ,"elephant":"코끼리"
        ,"hyena":"하이에나"
        ,"hartebeest":"영양"
    ]
    var dicsim:[String:String] = [
        "ox":"소"
        ,"camel":"기린"
        ,"cheetah":"기린"
        ,"zebra":"얼룩말"
        ,"elephant":"코끼리"
        ,"hartebeest":"기린"
    ]
    
    // MARK: - Image Classification
       
   /// - Tag: MLModelSetup
   lazy var classificationRequest: VNCoreMLRequest = {
       do {
           /*
            Use the Swift class `MobileNet` Core ML generates from the model.
            To use a different Core ML classifier model, add it to the project
            and replace `MobileNet` with that model's generated Swift class.
            */
           let model = try VNCoreMLModel(for: MobileNet().model)
           
           let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
               self?.processClassifications(for: request, error: error)
           })
           request.imageCropAndScaleOption = .centerCrop
           return request
       } catch {
           fatalError("Failed to load Vision ML model: \(error)")
       }
   }()
   
   /// - Tag: PerformRequests
   func updateClassifications(for image: UIImage) {
       classificationLabel.text = "Classifying..."
       
       let orientation = CGImagePropertyOrientation(image.imageOrientation)
       guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
       
       DispatchQueue.global(qos: .userInitiated).async {
           let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
           do {
               try handler.perform([self.classificationRequest])
           } catch {
               /*
                This handler catches general image processing errors. The `classificationRequest`'s
                completion handler `processClassifications(_:error:)` catches errors specific
                to processing that request.
                */
               print("Failed to perform classification.\n\(error.localizedDescription)")
           }
       }
   }
    
    func showvideo(_ v: String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnimalViewController") as! AnimalViewController
        vc.animalname = v;
        present(vc,animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "AnimalViewController"{
            let vc = segue.destination as! AnimalViewController
            print("```````````output name : \(outputname)")
            let s = (sender as! ViewController).outputname
            vc.animalname = s;
            print("```````````vc name : \(s)")
        }
    }
   
   /// Updates the UI with the results of the classification.
   /// - Tag: ProcessClassifications
   func processClassifications(for request: VNRequest, error: Error?) {
       DispatchQueue.main.async {
           guard let results = request.results else {
               self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
               return
           }
           // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
           let classifications = results as! [VNClassificationObservation]
       
           if classifications.isEmpty {
               self.classificationLabel.text = "Nothing recognized."
           } else {
                   // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.first
                let ss:[Substring] = topClassifications?.identifier.split(whereSeparator: { (c) -> Bool in
                    if c == " " || c == "," {
                        return true
                    }
                    return false
                }) ?? [""]
            if topClassifications?.confidence ?? 0 <= 0.71 {
                for i in ss{
                    if let sim = self.dicsim[String(i)] {
                        self.classificationLabel.text = String(format: "  (%.2f) %@", topClassifications?.confidence ?? 0, sim)
                        self.outputname = sim;
                        self.performSegue(withIdentifier: "AnimalViewController", sender: self as ViewController)
                        return
                    }
                }
            }else{
                for i in ss{
                    if let sim = self.dic[String(i)] {
                        self.classificationLabel.text = String(format: "  (%.2f) %@", topClassifications?.confidence ?? 0.5, sim)
                        self.outputname = sim;
                        self.performSegue(withIdentifier: "AnimalViewController", sender: self as ViewController)
                        return
                    }
                }
            }
            self.classificationLabel.text = topClassifications?.identifier;
            
           }
       }
   }

    let pickerController = UIImagePickerController()

    @IBAction func takePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){

            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.camera
            //picker.cameraDevice = UIImagePickerController.CameraDevice.front
            self.present(picker, animated: true, completion: nil)
        }
    }
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary

        present(pickerController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
       super.viewDidLoad()
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController.init(title: nil,
                message: "No camera available.",
                preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK",
                style: .default,
                handler: {(alert: UIAlertAction!) in })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        pickerController.delegate = self
    }

    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            updateClassifications(for: pickedImage)
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
