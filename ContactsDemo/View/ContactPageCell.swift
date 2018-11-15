//
//  ContactPageCell.swift
//  ContactsDemo
//
//  Created by Wang Kai on 2018/11/15.
//  Copyright © 2018 github. All rights reserved.
//

import UIKit

class ContactPageCell: UICollectionViewCell {

    private var nameLabel = UILabel()
    private var titleLabel = UILabel()
    private var aboutMeLabel = UILabel()
    private var introduceTextView = UITextView()
    var contactData: Contact? {
        didSet {
            if let contact = contactData {
                self.setupName(firstName: contact.first_name, lastName: contact.last_name)
                self.setupTitle(contact.title)
                self.setupIntroduction(contact.introduction)
            }
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

    override func layoutSubviews() {
        super.layoutSubviews()

        var topY: CGFloat = 20
        let nameFrame = CGRect(x: 0, y: topY, width: self.contentView.frame.width, height: 24)
        self.nameLabel.frame = nameFrame

        topY = nameFrame.maxY + 4
        let titleFrame = CGRect(x: 0, y: topY, width: nameFrame.width, height: 18)
        self.titleLabel.frame = titleFrame

        topY = titleFrame.maxY + 32
        let aboutFrame = CGRect(x: 16, y: topY, width: titleFrame.width - 32, height: 18)
        self.aboutMeLabel.frame = aboutFrame

        topY = aboutFrame.maxY + 4
        let introduceFrame = CGRect(x: 16, y: topY, width: aboutFrame.width, height: self.contentView.frame.height - topY)
        self.introduceTextView.frame = introduceFrame
    }

    private func commonInit() {
        self.backgroundColor = UIColor.white
        let contentSize = self.contentView.frame.size
        var topY: CGFloat = 20

        self.nameLabel.textAlignment = .center
        self.nameLabel.textColor = UIColor.darkText
        self.nameLabel.font = UIFont.systemFont(ofSize: 20)
        self.nameLabel.frame = CGRect(x: 0, y: topY, width: contentSize.width, height: 24)
        self.contentView.addSubview(self.nameLabel)

        topY += 24 + 4
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = UIColor.gray
        self.titleLabel.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel.frame = CGRect(x: 0, y: topY, width: contentSize.width, height: 18)
        self.contentView.addSubview(self.titleLabel)

        topY += 18 + 32
        self.aboutMeLabel.textAlignment = .left
        self.aboutMeLabel.textColor = UIColor.darkText
        self.aboutMeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.aboutMeLabel.frame = CGRect(x: 16, y: topY, width: contentSize.width - 32, height: 18)
        self.aboutMeLabel.text = "About me"
        self.contentView.addSubview(self.aboutMeLabel)

        topY += 18 + 4
        self.introduceTextView.textColor = UIColor.gray
        self.introduceTextView.font = UIFont.systemFont(ofSize: 16)
        self.introduceTextView.frame = CGRect(x: 16, y: topY, width: contentSize.width - 32, height: contentSize.height - topY)
        self.introduceTextView.isEditable = false
        self.introduceTextView.isSelectable = false
        self.introduceTextView.showsVerticalScrollIndicator = false
        self.introduceTextView.showsHorizontalScrollIndicator = false
        self.introduceTextView.textContainer.lineFragmentPadding = 0
        self.introduceTextView.textContainerInset = .zero
        self.contentView.addSubview(self.introduceTextView)
    }

    private func setupName(firstName: String, lastName: String) {
        let boldAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        let firstNameAttribute = NSAttributedString(string: firstName, attributes: boldAttributes)

        let normalAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        let lastNameAttribute = NSAttributedString(string: lastName, attributes: normalAttributes)

        let attributedName = NSMutableAttributedString(attributedString: firstNameAttribute)
        attributedName.append(NSAttributedString(string: " "))
        attributedName.append(lastNameAttribute)

        self.nameLabel.attributedText = attributedName
    }

    private func setupTitle(_ title: String) {
        self.titleLabel.text = title
    }

    private func setupIntroduction(_ text: String) {
        self.introduceTextView.text = text
    }

}
