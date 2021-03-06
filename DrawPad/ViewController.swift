//
//  ViewController.swift
//  DrawPad
//
//  Created by Jean-Pierre Distler on 13.11.14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController
//UINavigationControllerDelegate, UIImagePickerControllerDelegate
{

  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var tempImageView: UIImageView!

  var lastPoint = CGPoint.zero
  var red: CGFloat = 0.0
  var green: CGFloat = 0.0
  var blue: CGFloat = 0.0
  var brushWidth: CGFloat = 10.0
  var opacity: CGFloat = 1.0
  var swiped = false
  
  let colors: [(CGFloat, CGFloat, CGFloat)] = [
    (0, 0, 0),
    (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
    (1.0, 0, 0),
    (0, 0, 1.0),
    (51.0 / 255.0, 204.0 / 255.0, 1.0),
    (102.0 / 255.0, 204.0 / 255.0, 0),
    (102.0 / 255.0, 1.0, 0),
    (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
    (1.0, 102.0 / 255.0, 0),
    (1.0, 1.0, 0),
    (1.0, 1.0, 1.0),
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Actions

  @IBAction func reset(_ sender: AnyObject) {
    mainImageView.image = nil
  }

  @IBAction func share(_ sender: AnyObject) {
    UIGraphicsBeginImageContext(mainImageView.bounds.size)
    mainImageView.image?.draw(in: CGRect(x: 0, y: 0, 
      width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
     
    let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    present(activity, animated: true, completion: nil)
  }
  
  @IBAction func pencilPressed(_ sender: AnyObject) {
    var index = sender.tag ?? 0
    if index < 0 || index >= colors.count {
      index = 0
    }
    
    (red, green, blue) = colors[index]
    
    if index == colors.count - 1 {
      opacity = 1.0
    }
  }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    swiped = false
    if let touch = touches.first {
      lastPoint = touch.location(in: self.view)
    }
  }
  
  func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
    
    // 1
    UIGraphicsBeginImageContext(view.frame.size)
    let context = UIGraphicsGetCurrentContext()
    tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    
    // 2
    context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
    context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
    
    // 3
    context?.setLineCap(  CGLineCap.round   ) //TODO ? !
    context?.setLineWidth(brushWidth)
    context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
    context?.setBlendMode(CGBlendMode.normal)
    
    // 4
    context?.strokePath()
    
    // 5
    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    tempImageView.alpha = opacity
    UIGraphicsEndImageContext()
    
  }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)  {
    // 6
    swiped = true
    if let touch = touches.first  {//
      let currentPoint = touch.location(in: view)
      drawLineFrom(lastPoint, toPoint: currentPoint)
      
      // 7
      lastPoint = currentPoint
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {

    if !swiped {
      // draw a single point
      drawLineFrom(lastPoint, toPoint: lastPoint)
    }
    
    // Merge tempImageView into mainImageView
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
    tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    tempImageView.image = nil
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let settingsViewController = segue.destination as! SettingsViewController
    settingsViewController.delegate = self
    settingsViewController.brush = brushWidth
    settingsViewController.opacity = opacity
    settingsViewController.red = red
    settingsViewController.green = green
    settingsViewController.blue = blue
  }
    func sfdfd(){
    }
    @IBAction func importFrom(_ sender: Any) {
        self.importFromGaleryAction(sender)
    }
    
}

extension Array//:AiditonalFunctioal
{
    func soritngByHaor(){
        var array:Array<Int>;
        
    }
    
}

extension ViewController: SettingsViewControllerDelegate {
    func sfdfd2(){
        var array = Array<Int>()
        array.soritngByHaor()
        
    }

  func settingsViewControllerFinished(_ settingsViewController: SettingsViewController) {
    self.brushWidth = settingsViewController.brush
    self.opacity = settingsViewController.opacity
    self.red = settingsViewController.red
    self.green = settingsViewController.green
    self.blue = settingsViewController.blue
  }
}

extension ViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    @IBAction func importFromGaleryAction(_ sender: Any) {
        var imagePicker: UIImagePickerController?
        imagePicker = UIImagePickerController()
        if let theController = imagePicker{
            theController.allowsEditing = false
            theController.sourceType = .photoLibrary
            theController.delegate = self
            
            present(theController, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: Any]){
        
        print("Picker returned successfully")
        
        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType] as AnyObject?
        
        if let type:AnyObject = mediaType{
            
            if type is String{
                let stringType = type as! String
                
                if stringType == kUTTypeMovie as String{
                    let urlOfVideo = info[UIImagePickerControllerMediaURL] as? URL
                    if let url = urlOfVideo{
                        print("Video URL = \(url)")
                    }
                }
                    
                else if stringType == kUTTypeImage as String{
                    /* Let's get the metadata. This is only for images. Not videos */
                    //~                    let metadata = info[UIImagePickerControllerMediaMetadata]
                    //                        as? NSDictionary
                    //                    if let theMetaData = metadata{
                    let image = info[UIImagePickerControllerOriginalImage]
                        as? UIImage
                    if let theImage = image{
                        
                        mainImageView.image = theImage
                        trySaveAtachmentsToPath(theImage, curentFileAtachmentName:"newOneFile")
                        
                        print("Image = \(theImage)")
                    }
                }
                //                }
                
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Picker was cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func cameraSupportsMedia(_ mediaType: String,
                             sourceType: UIImagePickerControllerSourceType) -> Bool{
        
        let availableMediaTypes =
            UIImagePickerController.availableMediaTypes(for: sourceType) as
                [String]?
        
        if let types = availableMediaTypes{
            for type in types{
                if type == mediaType{
                    return true
                }
            }
        }
        
        return false
    }
    
    func doesCameraSupportTakingPhotos() -> Bool{
        return cameraSupportsMedia(kUTTypeImage as String, sourceType: .camera)
    }
    
    func trySaveAtachmentsToPath(_ theImage:UIImage, curentFileAtachmentName:String){
        //save image data
        if let data = UIImageJPEGRepresentation(theImage, 1.0) {//UIImagePNGRepresentation
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                print("directoryes - ",dir)
                let path = dir.appendingPathComponent(curentFileAtachmentName + ".jpeg")
                let path03 = dir.appendingPathComponent(curentFileAtachmentName + "_30persents.jpeg")
                let path03_png = dir.appendingPathComponent(curentFileAtachmentName + "_30persents.png")
            
            
                try? data.write(to: path, options: [.atomic]) //URL(fileURLWithPath: path)
                
                try? UIImageJPEGRepresentation(theImage, 0.30)?.write(to: path03, options: [.atomic])
                try? UIImagePNGRepresentation(theImage)?.write(to: path03_png, options: [.atomic])
            }
        }
    }
    
}

