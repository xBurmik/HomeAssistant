//
//  RollerShutterViewController.swift
//  HomeAssistant
//
//  Created by Alexey Burmistrov on 07.10.2021.
//

import UIKit
import RealmSwift

class RollerShutterViewController: UIViewController {
    
    var safeArea: UILayoutGuide!
    
    var fetch = realm.objects(selectedDevice.self)
    
    let step: Float = 10
    let label = UILabel()
    
    override func viewDidAppear(_ animated: Bool) {
        let device = fetch.last!
        view.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.00)
        
        let imageView = UIImageView(image: UIImage(named: "RollerShutter")!)
        
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150) //change to hex
        imageView.center = CGPoint(x: view.bounds.midX,
                                   y: view.bounds.midY - 100)
        view.addSubview(imageView)
        
        let mySlider = UISlider()
        mySlider.bounds.size.height = 20
        mySlider.bounds.size.width = 200
        mySlider.center = CGPoint(x: view.bounds.midX,
                                  y: view.bounds.midY)
        
        let image = UIImage(named: "circle")
        mySlider.setThumbImage(image, for: .normal)
        mySlider.setThumbImage(image, for: .highlighted)
        mySlider.minimumValue = 0
        mySlider.maximumValue = 100
        
        mySlider.setValue(Float(device.position), animated: true) // set position
        mySlider.isContinuous = false
        mySlider.tintColor = UIColor(red: 0.66, green: 0.50, blue: 0.39, alpha: 1.00) //change to hex
        mySlider.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.00) // vhange to hex
        mySlider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        
        imageView.backgroundColor = UIColor(red: CGFloat(mySlider.value/100),
                                            green: CGFloat(mySlider.value/100),
                                            blue: CGFloat(mySlider.value/100),
                                            alpha: 1)
        view.addSubview(mySlider)
        
        
        
        label.text = ""
        label.frame = CGRect(x: 10, y: 10, width: 200, height: 20)
        label.adjustsFontSizeToFitWidth = true
        label.center = CGPoint(x: view.bounds.midX,
                               y: view.bounds.midY + 30)
        
        view.addSubview(label)
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        
        let device = fetch.last!
        
        try! realm.write{
            device.temperature = Int(sender.value)
        }
        
        StorageManager.updateCurrentDevice(device)
        
        self.view.subviews.first?.backgroundColor = UIColor(red: CGFloat(sender.value/100), green: CGFloat(sender.value/100), blue: CGFloat(sender.value/100), alpha: 1)
        label.text = "Roller is open on \(sender.value)%"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
