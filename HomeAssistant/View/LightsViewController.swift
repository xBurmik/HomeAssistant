//
//  LightsView.swift
//  HomeAssistant
//
//  Created by Alexey Burmistrov on 07.10.2021.
//

import UIKit
import RealmSwift

class LightsViewController: UIViewController {
    
    var safeArea: UILayoutGuide!
    
    var fetch = realm.objects(selectedDevice.self)
    
    let imageView = UIImageView(image: UIImage(named: "Light")!)
    
    let mySlider = UISlider()
    let step: Float = 10
    let label = UILabel()
    
    let button = UIButton()
    
    override func viewDidAppear(_ animated: Bool) {
        let device = fetch.last!
        
        view.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.00)
        
        
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150) //change to hex
        imageView.center = CGPoint(x: view.bounds.midX,
                                   y: view.bounds.midY - 100)
        view.addSubview(imageView)
        
        
        mySlider.bounds.size.height = 20
        mySlider.bounds.size.width = 200
        mySlider.center = CGPoint(x: view.bounds.midX,
                                  y: view.bounds.midY)
        
        let image = UIImage(named: "circle")
        mySlider.setThumbImage(image, for: .normal)
        mySlider.setThumbImage(image, for: .highlighted)
        mySlider.minimumValue = 0
        mySlider.maximumValue = 100
        
        mySlider.setValue(Float(device.intensity), animated: true) // set light
        mySlider.isContinuous = false
        mySlider.tintColor = UIColor(red: 0.66, green: 0.50, blue: 0.39, alpha: 1.00) //change to hex
        mySlider.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.00) // vhange to hex
        mySlider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        
        view.addSubview(mySlider)
    
        label.text = ""
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
        label.adjustsFontSizeToFitWidth = true
        label.center = CGPoint(x: view.bounds.midX,
                               y: view.bounds.midY + 90)
        
        view.addSubview(label)
        
        button.backgroundColor = .white
        button.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderWidth = 2
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        button.addTarget(self, action: #selector(pressAction), for: .touchUpInside)
        button.center = CGPoint(x: view.bounds.midX,
                                y: view.bounds.midY + 45)
        
        view.addSubview(button)
        
        if device.mode == "OFF" {
            mySlider.isEnabled = false
            imageView.backgroundColor = UIColor(red: 0.1,
                                                green: 0.1,
                                                blue: 0.1,
                                                alpha: 1)
            label.text = "Device is off"
            button.setTitle("Turn ON", for: .normal)
        } else{
            mySlider.isEnabled = true
            imageView.backgroundColor = UIColor(red: CGFloat(mySlider.value/100),
                                                green: CGFloat(mySlider.value/100),
                                                blue: CGFloat(mySlider.value/100),
                                                alpha: 1)
            
            button.setTitle("Turn OFF", for: .normal)
        }
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        
        let device = fetch.last!
        
        StorageManager.updateCurrentDevice(device)
        
        if device.mode == "ON"{
            try! realm.write{
                device.intensity = Int(sender.value)
            }
            StorageManager.updateCurrentDevice(device)
            self.view.subviews.first?.backgroundColor = UIColor(red: CGFloat(mySlider.value/100),
                                                                green: CGFloat(mySlider.value/100),
                                                                blue: CGFloat(mySlider.value/100),
                                                                alpha: 1)
            label.text = "Intensity now \(sender.value)"}
        else {
        }
    }
    
    @objc private func pressAction () {
        let device = fetch.last!
        
        if device.mode == "OFF" {
            try! realm.write{device.mode = "ON"}
            StorageManager.updateCurrentDevice(device)
            mySlider.isEnabled = true
            imageView.backgroundColor = UIColor(red: CGFloat(mySlider.value/100),
                                                green: CGFloat(mySlider.value/100),
                                                blue: CGFloat(mySlider.value/100),
                                                alpha: 1)
            label.text = "Device is on"
            button.setTitle("Turn OFF", for: .normal)
        } else{
            try! realm.write{device.mode = "OFF"}
            StorageManager.updateCurrentDevice(device)
            mySlider.isEnabled = false
            imageView.backgroundColor = UIColor(red: 0.1,
                                                green: 0.1,
                                                blue: 0.1,
                                                alpha: 1)
            label.text = "Device is off"
            button.setTitle("Turn ON", for: .normal)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
