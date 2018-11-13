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
        self.title = "Contacts"

        self.loadData()

        self.setupAvatarSliderView()

        let line = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 100))
        line.center = CGPoint(x: self.view.frame.width / 2, y: 100)
        line.backgroundColor = UIColor.black
        self.view.addSubview(line)

        let left = UIView(frame: CGRect(x: line.frame.origin.x - 88, y: line.frame.origin.y, width: 1, height: 100))
        left.backgroundColor = UIColor.black
        self.view.addSubview(left)

        let right = UIView(frame: CGRect(x: line.frame.origin.x + 88, y: line.frame.origin.y, width: 1, height: 100))
        right.backgroundColor = UIColor.black
        self.view.addSubview(right)
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

    func sliderView(_ sliderView: AvatarSliderView, cellForItemAt index: Int) -> SliderViewCell {
        let cell = sliderView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, at: index)

        if let avatarCell = cell as? AvatarViewCell {
            avatarCell.imageName = self.contactList[index].avatar_filename
        }

        return cell
    }

    // MARK: - UICollectionView Datasource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contactList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)

        if let avatarCell = cell as? AvatarViewCell {
            avatarCell.imageName = self.contactList[indexPath.row].avatar_filename
        }

        return cell
    }

}
