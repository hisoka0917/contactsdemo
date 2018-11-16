//
//  ContactsView.swift
//  ContactsDemo
//
//  Created by Wang Kai on 2018/11/15.
//  Copyright © 2018 github. All rights reserved.
//

import UIKit

protocol ContactsViewDataSource: NSObjectProtocol {
    func numberOfItems(in contactsView: ContactsView) -> Int
    func contactsView(_ contactsView: ContactsView, contactDataAt index: Int) -> Contact
}

class ContactsView: UIView {
    public weak var dataSource: ContactsViewDataSource?

    private var avatarSliderView = AvatarSliderView(frame: .zero)
    private var pagerView = ContactPagerView(frame: .zero)
    private var itemCounts: Int = 0
    private let avatarReuseIdentifier = "AvatarCell"
    private let pageReuseIdentifier = "ContactPageCell"
    private let avatarSliderHeight: CGFloat = 100

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        self.avatarSliderView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.avatarSliderHeight)

        let frame = CGRect(x: 0,
                           y: self.avatarSliderHeight,
                           width: self.bounds.width,
                           height: self.bounds.height - self.avatarSliderHeight)
        self.pagerView.frame = frame
    }

    private func commonInit() {
        self.setupAvatarSlider()
        self.setupPagerView()
    }

    private func setupAvatarSlider() {
        self.avatarSliderView.register(AvatarViewCell.self, forCellWithReuseIdentifier: self.avatarReuseIdentifier)
        self.avatarSliderView.delegate = self
        self.avatarSliderView.dataSource = self
        self.avatarSliderView.backgroundColor = UIColor.white
        self.avatarSliderView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.avatarSliderHeight)

        self.addSubview(self.avatarSliderView)
    }

    private func setupPagerView() {
        self.pagerView.register(ContactPageCell.self, forCellWithReuseIdentifier: self.pageReuseIdentifier)
        self.pagerView.delegate = self
        self.pagerView.dataSource = self
        self.pagerView.backgroundColor = UIColor.white

        self.addSubview(self.pagerView)
    }

}

extension ContactsView: ContactPagerViewDelegate, ContactPagerViewDataSource {

    func numberOfPages(in pagerView: ContactPagerView) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        self.itemCounts = dataSource.numberOfItems(in: self)
        return self.itemCounts
    }

    func pagerView(_ pagerView: ContactPagerView, cellForItemAt index: Int) -> ContactPageCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: self.pageReuseIdentifier, at: index)

        if let dataSource = self.dataSource {
            let contact = dataSource.contactsView(self, contactDataAt: index)
            cell.contactData = contact
        }

        return cell
    }

    func pagerViewDidScroll(_ pagerView: ContactPagerView) {
        let offset = pagerView.scrollOffset
        let avatarItemWidth = self.avatarSliderView.cellWidth + self.avatarSliderView.interitemSpacing
        let offsetX = offset * avatarItemWidth
        self.avatarSliderView.setContentOffset(offsetX, animated: false)
    }

    func pagerViewDidStopped(at index: Int) {
        self.avatarSliderView.setSelectItem(index)
    }
    
}

extension ContactsView: AvatarSliderViewDelegate, AvatarSliderViewDataSource {

    // MARK: - AvatarSliderView Datasource

    func numberOfItems(in sliderView: AvatarSliderView) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        self.itemCounts = dataSource.numberOfItems(in: self)
        return self.itemCounts
    }

    func sliderView(_ sliderView: AvatarSliderView, cellForItemAt index: Int) -> AvatarViewCell {
        let cell = sliderView.dequeueReusableCell(withReuseIdentifier: self.avatarReuseIdentifier, at: index)
        if let dataSource = self.dataSource {
            let contact = dataSource.contactsView(self, contactDataAt: index)
            cell.imageName = contact.avatar_filename
        }
        return cell
    }

    // MARK: - AvatarSliderView Delegate

    func sliderView(_ sliderView: AvatarSliderView, didSelectItemAt index: Int) {
        sliderView.deselectItem(at: index, animated: false)
        sliderView.scrollToItem(at: index, animated: true)
    }

    func sliderViewDidScroll(_ sliderView: AvatarSliderView) {
        let offset = sliderView.scrollOffset
        let offsetY = offset * self.pagerView.frame.height
        self.pagerView.setContentOffset(offsetY, animated: false)
    }
}
