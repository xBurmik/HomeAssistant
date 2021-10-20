//
//  CustomSlider.swift
//  HomeAssistant
//
//  Created by Alexey Burmistrov on 19.10.2021.
//

import UIKit

class CustomSlider: UISlider {

    @IBInspectable var trackHeight: CGFloat = 3
    @IBInspectable var thumbRadius: CGFloat = 24
    
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = .white//thumbTintColor
        thumb.layer.borderWidth = 6
        thumb.layer.borderColor = CGColor(red: 0.34, green: 0.34, blue: 0.34, alpha: 1.00)
        return thumb
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        let thumb = thumbImage(radius: thumbRadius)
        setThumbImage(thumb, for: .normal)
    }

    private func thumbImage(radius: CGFloat) -> UIImage {
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2

        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }

}


