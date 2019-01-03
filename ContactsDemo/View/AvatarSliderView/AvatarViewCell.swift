//
//  AvatarViewCell.swift
//  ContactsDemo
//
//  Created by Wang Kai on 2018/11/12.
//  Copyright © 2018 github. All rights reserved.
//

import UIKit

public class AvatarViewCell: UICollectionViewCell {
    private var avatarView: UIImageView = UIImageView()
    private var shapeLayer = CAShapeLayer()
    public var imageName: String = "" {
        didSet {
            avatarView.image = UIImage(named: imageName)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(self.avatarView)

        self.shapeLayer.fillColor = UIColor.clear.cgColor
        let strokeColor = UIColor(red: 198 / 255.0, green: 224 / 255.0, blue: 244 / 255.0, alpha: 1.0)
        self.shapeLayer.strokeColor = strokeColor.cgColor
        self.shapeLayer.lineWidth = 4.0
    }

    public override func prepareForReuse() {
        self.shapeLayer.removeFromSuperlayer()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        let bounds = self.contentView.bounds
        let frame = CGRect(x: 4, y: 4, width: bounds.width - 8, height: bounds.height - 8)
        self.avatarView.frame = frame

        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
                                      radius: CGFloat(frame.width / 2),
                                      startAngle: CGFloat(0), endAngle: CGFloat.pi * 2,
                                      clockwise: true)
        self.shapeLayer.path = circlePath.cgPath
    }

    func setSelection(_ select: Bool) {
        if select {
            self.contentView.layer.addSublayer(self.shapeLayer)
        } else {
            self.shapeLayer.removeFromSuperlayer()
        }
    }
}
