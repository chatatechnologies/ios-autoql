//
//  NotificationCell.swift
//  chata
//
//  Created by Vicente Rincon on 24/09/20.
//

import Foundation
protocol NotificationCellDelegate: class {
    func deleteNotification(index: Int, id: String)
}
class NotificationCell: UITableViewCell {
    private var lblTitle = UILabel()
    private var lblDescription = UILabel()
    private var lblDate = UILabel()
    private var vwMain = UIView()
    private var btnDelete = UIButton()
    private var itemNotif = NotificationItemModel()
    var index = 0
    weak var delegate: NotificationCellDelegate?
    static var identifier: String {
        return String(describing: self)
    }
    func configCell(item: NotificationItemModel, index: Int) {
        itemNotif = item
        self.index = index
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        self.index = index
        loadComponents()
    }
    func loadComponents() {
        contentView.addSubview(vwMain)
        contentView.backgroundColor = chataDrawerBackgroundColor
        vwMain.edgeTo(self, safeArea: .nonePadding, height: 4, padding: 4)
        vwMain.cardView()
        loadDeleteBtn()
        loadTitle()
        loadDate()
        loadDescription()
    }
    func loadDeleteBtn() {
        let image = UIImage(named: "icCancel.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let image2 = image?.resizeT(maxWidthHeight: 20)
        btnDelete.setImage(image2, for: .normal)
        btnDelete.setImage(btnDelete.imageView?.changeColor().image, for: .normal)
        btnDelete.addTarget(self, action: #selector(deleteNotification), for: .touchUpInside)
        btnDelete.setTitleColor(chataDrawerTextColorPrimary, for: .normal)
        vwMain.addSubview(btnDelete)
        btnDelete.edgeTo(vwMain, safeArea: .rightTop, height: 20.0, vwMain, padding: 16)
    }
    func loadTitle() {
        lblTitle.text = itemNotif.ruleTitle
        vwMain.addSubview(lblTitle)
        lblTitle.setSize(16, true)
        lblTitle.numberOfLines = 0
        lblTitle.textColor = chataDrawerTextColorPrimary
        lblTitle.edgeTo(vwMain, safeArea: .elementToRight, height: 16, btnDelete, padding: 16)
    }
    func loadDescription() {
        lblDescription.text = itemNotif.ruleMessage
        vwMain.addSubview(lblDescription)
        lblDescription.setSize(14)
        lblDescription.textColor = chataDrawerTextColorPrimary
        lblDescription.edgeTo(lblTitle, safeArea: .fullPadding, lblTitle, lblDate)
    }
    func loadDate() {
        lblDate.text = itemNotif.createdAt
        vwMain.addSubview(lblDate)
        lblDate.setSize(12)
        lblDate.textColor = chataDrawerBorderColor
        lblDate.edgeTo(vwMain, safeArea: .bottomPadding, height: 20, padding: 16)
    }
    @IBAction func hideMenu(_ sender: AnyObject){
        superview?.removeView(tag: 2)
    }
    @objc func deleteNotification() {
        delegate?.deleteNotification(index: index, id: itemNotif.id)
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
