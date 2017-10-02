//
//  ViewController.swift
//  Take 10 Photos & Store Them
//
//  Created by William Peregoy on 10/2/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    let imagePicker = UIImagePickerController()
    
    let secureImageDataKey = "securedTake10Selfies"
    let secureImagePath = "securedTake10SelfiesPath"

    
    var imageCount: Int = 0
    var timer = Timer()
    var imageDataArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func startCameraAction(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        imagePicker.showsCameraControls = false
        
        self.present(imagePicker, animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.imageCount = 0
            strongSelf.takePhoto()
            strongSelf.startTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.takePhoto), userInfo: nil, repeats: true)
    }
    
    @objc func takePhoto() {
        if imageCount >= 10 {
            timer.invalidate()
            imagePicker.dismiss(animated: true, completion: {})
            storeImageData()
        }
        imagePicker.takePicture()
        imageCount += 1
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        imageDataArray.append(image)
    }
    
    func storeImageData() {
        guard !imageDataArray.isEmpty else { return }
        
        let arrayData = NSKeyedArchiver.archivedData(withRootObject: imageDataArray)
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let arrayDataPath = documentPath.appendingPathComponent(secureImagePath)
        
        try? arrayData.write(to: arrayDataPath, options: NSData.WritingOptions.completeFileProtection)
    }
}

