//
//  ContactsViewController.swift
//  ContactsDemo
//
//  Created by Wang Kai on 2018/11/12.
//  Copyright © 2018 github. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, ContactsViewDataSource {

    private var contactList = [Contact]()
    private var contactsView: ContactsView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadData()
        self.setupContactsView()
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

    private func setupContactsView() {
        var bottomInset: CGFloat = 0
        var topInset: CGFloat = 0
        if #available(iOS 11.0, *) {
            bottomInset = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
            topInset = UIApplication.shared.keyWindow!.safeAreaInsets.top
        }
        let height = self.view.bounds.height - bottomInset - topInset
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: height)
        self.contactsView = ContactsView(frame: frame)
        self.contactsView.dataSource = self
        self.contactsView.backgroundColor = UIColor.white

        self.view.addSubview(self.contactsView)
    }

    // MARK: - ContactsView DataSource

    func numberOfItems(in contactsView: ContactsView) -> Int {
        return self.contactList.count
    }

    func contactsView(_ contactsView: ContactsView, contactDataAt index: Int) -> Contact {
        return self.contactList[index]
    }
}
