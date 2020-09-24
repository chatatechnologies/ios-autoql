//
//  NotificationCell.swift
//  chata
//
//  Created by Vicente Rincon on 24/09/20.
//

import Foundation
class NotificationCell: UITableViewCell {
    private var lblTitle = UILabel()
    private var lblDescription = UILabel()
    private var lblDate = UILabel()
    private var itemNotif = NotificationItemModel()
    var index = 0
    static var identifier: String {
        return String(describing: self)
    }
    func configCell(item: NotificationItemModel, index: Int) {
        itemNotif = item
        self.index = index
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        self.index = index
    }
    private func createButton(btn: ButtonMenu) -> myCustomButton {
        let button = myCustomButton()
        button.idButton = btn.idHTML
        let image = UIImage(named: btn.imageStr, in: Bundle(for: type(of: self)), compatibleWith: nil)
        let image2 = image?.resizeT(maxWidthHeight: 30)
        button.setImage(image2, for: .normal)
        //button.setImage(button.imageView?.changeColor().image, for: .normal)
        button.addTarget(self, action: btn.action, for: .touchUpInside)
        return button
    }
    @objc func showHide() {
        print("Func")
    }
    @IBAction func hideMenu(_ sender: AnyObject){
        superview?.removeView(tag: 2)
    }
}
struct NotificationModel{
    var items: NotificationItemModel
    var limit: Int
    var notifications: NotificationItemModel
    var offset: Int
    var pageNumber: Int
    var pagination: PaginationNotificationModel
    var totalElements: Int
    var totalPages: Int
    init(
           items: NotificationItemModel = NotificationItemModel(),
           limit: Int = 0,
           notifications: NotificationItemModel = NotificationItemModel(),
           offset: Int = 0,
           pageNumber: Int = 0,
           pagination: PaginationNotificationModel = PaginationNotificationModel(),
           totalElements: Int = 0,
           totalPages: Int = 0
    ) {
        self.items = items
        self.limit = limit
        self.notifications = notifications
        self.offset = offset
        self.pageNumber = pageNumber
        self.pagination = pagination
        self.totalElements = totalElements
        self.totalPages = totalPages
    }
}
struct NotificationItemModel {
    var createdAt: String
    var id: String
    var notificationType: String
    var ruleId: Int
    var ruleMessage: String
    var ruleQuery: String
    var ruleTitle: String
    var ruletype: String
    var state: String
    init(
        createdAt: String = "",
        id: String = "",
        notificationType: String = "",
        ruleId: Int = 0,
        ruleMessage: String = "",
        ruleQuery: String = "",
        ruleTitle: String = "",
        ruletype: String = "",
        state: String = ""
    ) {
        self.createdAt = createdAt
        self.id = id
        self.notificationType = notificationType
        self.ruleId = ruleId
        self.ruleMessage = ruleMessage
        self.ruleQuery = ruleQuery
        self.ruleTitle = ruleTitle
        self.ruletype = ruletype
        self.state = state
    }
}
struct PollModel {
    var acknowledged: Int
    var dismissed: Int
    var unacknowledged: Int
    init(
        acknowledged: Int = 0,
        dismissed: Int = 0,
        unacknowledged: Int = 0) {
        self.acknowledged = acknowledged
        self.dismissed = dismissed
        self.unacknowledged = unacknowledged
    }
}
struct PaginationNotificationModel {
    var currentPage: Int
    var nextUrl: String
    var pageSize: Int
    var previousUrl: String
    var totalItems: Int
    var totalPages: Int
    init(
        currentPage: Int = 0,
        nextUrl: String = "",
        pageSize: Int = 0,
        previousUrl: String = "",
        totalItems: Int = 0,
        totalPages: Int = 0
    ) {
        self.currentPage = currentPage
        self.nextUrl = nextUrl
        self.pageSize = pageSize
        self.previousUrl = previousUrl
        self.totalItems = totalItems
        self.totalPages = totalPages
    }
}
