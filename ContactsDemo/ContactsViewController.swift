//
//  ContactsViewController.swift
//  ContactsDemo
//
//  Created by Wang Kai on 2018/11/12.
//  Copyright © 2018 github. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, AvatarSliderViewDelegate, AvatarSliderViewDataSource {

    private var contactList = [Contact]()
    private let cellReuseIdentifier = "AvatarCell"
    private var avatarSliderView = AvatarSliderView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadData()

        self.setupAvatarSliderView()
    }

    private func loadData() {
        if let path = Bundle.main.path(forResource: "contacts", ofType: "json") {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                if let list = try? JSONDecoder().decode([Contact].self, from: jsonData) {
                    self.contactList = list
                }
            }
        }
    }

    private func setupAvatarSliderView() {
        self.avatarSliderView.register(AvatarViewCell.self, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.avatarSliderView.delegate = self
        self.avatarSliderView.dataSource = self
        self.avatarSliderView.backgroundColor = UIColor.white
        self.avatarSliderView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)

        self.view.addSubview(self.avatarSliderView)
    }

    // MARK: - AvatarSliderView Datasource

    func numberOfItems(in pagerView: AvatarSliderView) -> Int {
        return self.contactList.count
    }

    func sliderView(_ sliderView: AvatarSliderView, cellForItemAt index: Int) -> AvatarViewCell {
        let cell = sliderView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, at: index)
        cell.imageName = self.contactList[index].avatar_filename
        return cell
    }

    // MARK: - AvatarSliderView Delegate

    func sliderView(_ sliderView: AvatarSliderView, didSelectItemAt index: Int) {
        sliderView.deselectItem(at: index, animated: false)
        sliderView.scrollToItem(at: index, animated: true)
    }

}
