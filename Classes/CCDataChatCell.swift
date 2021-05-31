//
//  DataChatCell.swift
//  chata
//
//  Created by Vicente Rincon on 24/02/20.
//

import Foundation
protocol DataChatCellDelegate: class {
    func updateTableColumn(indexTab: Int, columns: [ChatTableColumn])
    func sendText(_ text: String, _ safe: Bool)
    func deleteQuery(idQuery: String)
    func updateSize(numRows: Int, index: Int, toTable: Bool, isTable: Bool)
    func sendDrillDown(idQuery: String, obj: String, name: String)
    func sendDrillDownManual(newData: [[String]], columns: [ChatTableColumn], idQuery: String)
}
class DataChatCell: UITableViewCell, ChatViewDelegate, BoxWebviewViewDelegate, QueryBuilderViewDelegate, IntroductionInteractionViewDelegate, UITableViewDelegate, UITableViewDataSource, ColumnsCellDelegate {
    private var mainData = ChatComponentModel()
    private var menuButtons: [ButtonMenu] = []
    private var index: Int = 0
    private var functionJS = ""
    private var arrColumnsData: [ColumnsItemModel] = []
    private let tbMain = UITableView()
    private var dataOriginal = ChatComponentModel()
    private var isCheckBoxActive: Bool = false
    private let imgCheck = UIImageView()
    let btnReport = UIButton()
    var vwFather: UIView = UIApplication.shared.keyWindow!
    var problemMessage = ""
    private var menuReportProblem: [StackSelection] = [
        StackSelection(title: "The data is incorrect", action: #selector(reportProblem), tag: 0),
        StackSelection(title: "The data is incomplete", action: #selector(reportProblem), tag: 1),
        StackSelection(title: "Other", action: #selector(reportProblem), tag: 2)
    ]
    private var subMenuOptions: [SubMenuOption] = [
        SubMenuOption(title: "View generated SQL", action: #selector(showSQL), tag: 0, img: "icSQL"),
    ]
    let boxWeb = BoxWebviewView()
    var defaultType = ButtonMenu(imageStr: "icTable", action: #selector(changeChart), idHTML: "idTableBasic")
    var formatWB = false
    var buttonDefault: myCustomButton?
    var lastQuery: Bool = false
    weak var delegate: DataChatCellDelegate?
    weak var delegateQB: QueryBuilderViewDelegate?
    static var identifier: String {
        return String(describing: self)
    }
    func configCell(allData: ChatComponentModel, index: Int, lastQueryFinal: Bool = false) {
        lastQuery = lastQueryFinal
        mainData = allData
        //self.
        self.index = index
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        buildDataColumns()
        genereteData()
    }
    func buildDataColumns(){
        arrColumnsData = []
        for col in mainData.columnsInfo {
            let finalcol = ColumnsItemModel(columnName: col.name, visibility: col.isVisible)
            arrColumnsData.append(finalcol)
        }
    }
    func loadLeftMenu(report: Bool = false, sql: Bool = true) {
        let new = ButtonMenu(imageStr: "icDelete", action: #selector(deleteQuery), idHTML: "idDelete")
        menuButtons.append(new)
        if report {
            let reportProblem = ButtonMenu(imageStr: "icReport", action: #selector(showMenu), idHTML: "icReport")
            menuButtons.append(reportProblem)
            if sql {
                let sqlButton = ButtonMenu(imageStr: "icPoints", action: #selector(showSubMenu), idHTML: "icPoints")
                menuButtons.append(sqlButton)
            }
        }
    }
    func genereteData() {
        formatWB = false
        switch mainData.type {
        case .Introduction:
            let valid = mainData.text.count < 15
            loadLeftMenu(report: valid, sql: valid)
            getIntroduction()
        case .IntroductionInteractive:
            loadLeftMenu(report: true)
            getIntroductionInteractive()
        case .Webview, .Table, .Bar, .Line, .Column, .Pie, .Bubble, .Heatmap, .StackBar, .StackColumn, .StackArea:
            formatWB = true
            if !mainData.isLoading{
                loadLeftMenu(report: true)
                getWebView()
            }
        case .Suggestion:
            loadLeftMenu(report: true, sql: false)
            getSuggestion()
        case .Safetynet:
            loadLeftMenu()
            getSafetynet()
        case .QueryBuilder:
            getQueryBuilder()
        }
    }
    private func getIntroduction(){
        let newView = IntroductionView()
        self.contentView.addSubview(newView)
        newView.cardView()
        newView.loadLabel(text: mainData.text, user: mainData.user )
        let align: DViewSafeArea = mainData.user ? .paddingTopRight : .paddingTopLeft
        newView.backgroundColor = mainData.user ? chataDrawerAccentColor : chataDrawerBackgroundColorPrimary
        if !mainData.user && index != 0 && DataConfig.autoQLConfigObj.enableDrilldowns && mainData.webView != "error"{
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(showDrillDown))
            newView.addGestureRecognizer(tapgesture)
        }
        newView.lbl.textColor = mainData.user ? .white : chataDrawerTextColorPrimary
        if //mainData.referenceID != "1.1.430" &&
            mainData.referenceID != "1.1.431" {
            mainData.user || mainData.webView == "" ? nil : loadButtons(area: .modalRight, buttons: menuButtons, view: newView)
        }
        newView.edgeTo(self, safeArea: align)
        if !mainData.user && mainData.text.count < 9 {
            newView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        }
        self.sizeToFit()
    }
    private func getIntroductionInteractive(){
        let newView = IntroductionInteractionView()
        newView.delegate = self
        self.contentView.addSubview(newView)
        newView.edgeTo(self, safeArea: .paddingTop)
        newView.cardView()
        newView.loadLabel(text: mainData.text, user: mainData.user )
        loadButtons(area: .modalRight, buttons: menuButtons, view: newView)
        /*let align: DViewSafeArea = mainData.user ? .paddingTopRight : .paddingTopLeft
        newView.backgroundColor = mainData.user ? chataDrawerAccentColor : chataDrawerBackgroundColorPrimary
        if !mainData.user && index != 0 && DataConfig.autoQLConfigObj.enableDrilldowns && mainData.webView != "error"{
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(showDrillDown))
            newView.addGestureRecognizer(tapgesture)
        }
        newView.lbl.textColor = mainData.user ? .white : .red
        if mainData.referenceID != "1.1.430" && mainData.referenceID != "1.1.431" {
            mainData.user || mainData.webView == "" ? nil : loadButtons(area: .modal2Right, buttons: menuButtons, view: newView)
        }
        
        if !mainData.user && mainData.text.count < 7 {
            newView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        }*/
        self.sizeToFit()
    }
    private func getQueryBuilder() {
        let viewQB = QueryBuilderView()
        viewQB.delegate = self
        viewQB.delegateQB = self
        self.contentView.addSubview(viewQB)
        viewQB.cardView()
        viewQB.edgeTo(self, safeArea: .paddingTop)
        
    }
    private func getWebView() {
        var icImage = "icColumn"
        var idChart = "cidcolumn"
        if mainData.groupable {
            if mainData.dataRows.count > 0 {
                if mainData.dataRows[0].count == 3 {
                    icImage = "icStackedColumn"
                    idChart = "cidstacked_column"
                }
            }
        }
        print(mainData.biChart)
        let imgStr = mainData.groupable && mainData.biChart  ? icImage : "icTable"
        let idHTML = mainData.groupable && mainData.biChart ? idChart : "idTableBasic"
        defaultType = ButtonMenu(imageStr: imgStr, action: #selector(changeChart), idHTML: idHTML)
        if imgStr == "icTable" {
            mainData.type = .Table
        }
        buttonDefault = createButton(btn: defaultType)
        boxWeb.loadWebview(strWebview: mainData.webView, idQuery: mainData.idQuery)
        boxWeb.cardView()
        boxWeb.backgroundColor = chataDrawerBackgroundColorPrimary
        boxWeb.dataMain = mainData
        boxWeb.drilldown = mainData.drillDown
        boxWeb.delegate = self
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(showHide))
        boxWeb.addGestureRecognizer(tapgesture)
        self.contentView.addSubview(boxWeb)
        boxWeb.edgeTo(self, safeArea: .paddingTop)
        let buttons = getButtons(num: mainData.dataRows.count > 0 ? mainData.dataRows[0].count : 0,
                                 columns: mainData.columns)
        loadButtons(area: .modalLeft, buttons: buttons, view: boxWeb)
        loadButtons(area: .modalRight, buttons: menuButtons, view: boxWeb)
        if mainData.limit {
            let btnWarning = UIButton()
            btnWarning.setConfig(text: "i",
                                 backgroundColor: .orange,
                                 textColor: .white,
                                 executeIn: self,
                                 action: #selector(showAlertWarning))
            btnWarning.circle(30)
            btnWarning.tag = 11
            boxWeb.addSubview(btnWarning)
            btnWarning.edgeTo(boxWeb, safeArea: .bottomRight, height: 30, padding: 8, secondPadding: -8)
        }
        self.sizeToFit()
    }
    private func loadButtons(area: DViewSafeArea, buttons: [ButtonMenu], view: UIView) {
        let changeViewMain = UIView()
        let changeView = UIStackView()
        let nTag = area == .modalRight ? 1 : 0
        changeViewMain.tag = nTag
        changeViewMain.cardView()
        changeViewMain.backgroundColor = chataDrawerBackgroundColorPrimary
        self.contentView.addSubview(changeViewMain)
        changeViewMain.edgeTo(self, safeArea: area, height: 35, view, padding: CGFloat(buttons.count * 38) )
        //changeView.cardView()
        changeView.getSide()
        changeViewMain.addSubview(changeView)
        changeView.edgeTo(changeViewMain, safeArea: .modal, height: 35)
        changeViewMain.layer.zPosition = 1
        for btn in buttons {
            let button = createButton(btn: btn)
            changeView.addArrangedSubview(button)
        }
    }
    private func createButton(btn: ButtonMenu) -> myCustomButton {
        let button = myCustomButton()
        button.idButton = btn.idHTML
        let image = UIImage(named: btn.imageStr, in: Bundle(for: type(of: self)), compatibleWith: nil)
        let image2 = image?.resizeT(maxWidthHeight: 30)
        button.setImage(image2, for: .normal)
        button.addTarget(self, action: btn.action, for: .touchUpInside)
        return button
    }
    private func getButtons(num: Int, columns: [ChatTableColumnType]) -> [ButtonMenu] {
        var buttonsFinal: [ButtonMenu] = []
        let datePivot = supportPivot(columns: mainData.columns)
        var contrast = false
        switch num {
        case 2:
            if mainData.biChart {
                buttonsFinal = getBichart(dataCount: mainData.rowsClean.count)
            }
        case 3:
            if columns[0] == .string && columns[1] == .string && columns[2] == .string{
                buttonsFinal = []
            } else{
                contrast = supportContrast(columns: columns)
                let typeTry = contrast ? "contrast_" : "stacked_"
                
                if !contrast {
                    buttonsFinal += [
                    ButtonMenu(imageStr: "icTableData", action: #selector(changeChart), idHTML: "idTableDataPivot"),
                    ButtonMenu(imageStr: "icHeat", action: #selector(changeChart), idHTML: "cidheatmap"),
                    ButtonMenu(imageStr: "icBubble", action: #selector(changeChart), idHTML: "cidbubble")
                    ]
                    var firstButton = ButtonMenu(imageStr: "icStackedColumn", action: #selector(changeChart), idHTML: "cid\(typeTry)Column")
                    if mainData.groupable {
                        firstButton = ButtonMenu(imageStr: "icTable", action: #selector(changeChart), idHTML: "idTableBasic")

                    }
                    buttonsFinal += [
                        firstButton,
                        ButtonMenu(imageStr: "icStackedBar", action: #selector(changeChart), idHTML: "cid\(typeTry)bar"),
                        ButtonMenu(imageStr: "icArea", action: #selector(changeChart), idHTML: "cidstacked_area")
                    ]
                }
            }
        default:
            if mainData.biChart{
                buttonsFinal = getBichart(dataCount: mainData.rowsClean.count)
            }
            //buttonsFinal = []
        }
        if datePivot && !contrast{
            let datePivot = ButtonMenu(imageStr: "icTableData", action: #selector(changeChart), idHTML: "idTableDatePivot")
            buttonsFinal.append(datePivot)
        }
        return buttonsFinal
    }
    func getBichart(dataCount: Int = 0) -> [ButtonMenu] {
        var firstButton = ButtonMenu(imageStr: "icColumn", action: #selector(changeChart), idHTML: "cidcolumn")
        if mainData.groupable {
            firstButton = ButtonMenu(imageStr: "icTable", action: #selector(changeChart), idHTML: "idTableBasic")

        }
        var final = [
            firstButton,
            ButtonMenu(imageStr: "icBar", action: #selector(changeChart), idHTML: "cidbar"),
            ButtonMenu(imageStr: "icLine", action: #selector(changeChart), idHTML: "cidline"),
            
        ]
        if dataCount < 6{
            let pie = ButtonMenu(imageStr: "icPie", action: #selector(changeChart), idHTML: "cidpie")
            final.append(pie)
        }
        return final
    }
    @objc func showHide() {}
    @objc func showAlertWarning() {
        generateAlert()
    }
    @objc func showDrillDown() {
        delegate?.sendDrillDown(idQuery: mainData.idQuery, obj: "", name: "")
    }
    private func getSuggestion() {
        let newView = SuggestionView()
        newView.delegate = self
        newView.backgroundColor = chataDrawerBackgroundColorPrimary
        newView.loadConfig(options: mainData.options, query: mainData.text)
        newView.cardView()
        self.contentView.addSubview(newView)
        newView.edgeTo(self, safeArea: .paddingTop)
        loadButtons(area: .modalRight, buttons: menuButtons, view: newView)
        self.sizeToFit()
    }
    private func getSafetynet() {
        let newView = SafetynetView()
        newView.backgroundColor = chataDrawerBackgroundColorPrimary
        newView.cardView()
        self.contentView.addSubview(newView)
        newView.edgeTo(self, safeArea: .paddingTop)
        newView.loadConfig(mainData, lastQueryFinal: lastQuery)
        newView.delegate = self
        loadButtons(area: .modalRight, buttons: menuButtons, view: newView)
        self.sizeToFit()
    }
    func sendText(_ text: String, _ safe: Bool) {
        delegate?.sendText(text, safe)
    }
    @IBAction func deleteQuery(_ sender: AnyObject){
        delegate?.deleteQuery(idQuery: mainData.idQuery)
    }
    @IBAction func closeModal(_ sender: AnyObject) {
        resetData()
        let btnD = UIButton()
        self.hideMenu(btnD)
        vwFather.removeView(tag: 200)
    }
    @IBAction func applyChanges(_ sender: AnyObject) {
        ChataServices.instance.saveColumnChanges(columns: mainData.columnsInfo)
        let btnD = UIButton()
        self.hideMenu(btnD)
        delegate?.updateTableColumn(indexTab: index, columns: mainData.columnsInfo)
        vwFather.removeView(tag: 200)
    }
    @IBAction func showSQL(_ sender: AnyObject){
        generatePopUpSQL()
    }
    @IBAction func showColumns(_ sender: AnyObject){
        generateSelectColumns()
    }
    @IBAction func showFilter(_ sender: AnyObject){
        showFilters()
    }
    @IBAction func showSubMenu(_ sender: AnyObject){
        superview?.removeView(tag: 2)
        vwFather.removeView(tag: 2)
        generateSubMenu()
    }
    @IBAction func showMenu(_ sender: AnyObject){
        superview?.removeView(tag: 2)
        vwFather.removeView(tag: 2)
        genereMenuReport()
    }
    @IBAction func hideMenu(_ sender: AnyObject){
        superview?.removeView(tag: 2)
        vwFather.removeView(tag: 2)
    }
    @IBAction func hideMenu2(gesture: UITapGestureRecognizer){
        if gesture.state == .began {
                    // do something...
            superview?.removeView(tag: 2)
        } else if gesture.state == .ended { // optional for touch up event catching
                    // do something else...
            print("tap up")
        }
        
    }
    @IBAction func reportProblem(_ sender: UIButton){
        
        switch sender.tag {
        case 0:
            showAlertResult(msg: "The data is incorrect")
        case 1:
            showAlertResult(msg: "The data is incomplete")
        case 2:
            generatePopUp()
        default:
            print("error")
        }
        superview?.removeView(tag: 2)
    }
    func showAlertResult(msg: String) {
        let newAlert = UIAlertController(title: "", message: "Thank you for your feedback", preferredStyle: .alert)
        newAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        var finalID = mainData.idQuery
        if finalID.contains("drilldown"){
            let newFinalID = finalID.components(separatedBy: "drilldown")
            finalID = newFinalID[0]
        }
        ChataServices.instance.reportProblem(queryID: finalID, problemType: msg) { (success) in
            DispatchQueue.main.async {
                newAlert.message = success ? "Thank you for your feedback" : "Error in report"
                UIApplication.shared.keyWindow?.rootViewController?.present(newAlert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func changeChart(_ sender: myCustomButton){
        let btnTemp: myCustomButton = myCustomButton()
        var newID = sender.idButton
        var oldID = buttonDefault?.idButton ?? ""
        var newTypeStr = newID.replace(target: "cid", withString: "")
        btnTemp.setImage(sender.imageView?.image, for: .normal)
        btnTemp.idButton = newID
        sender.setImage(buttonDefault?.imageView?.image, for: .normal)
        sender.idButton = oldID
        buttonDefault?.setImage(btnTemp.imageView?.image, for: .normal)
        buttonDefault?.idButton = btnTemp.idButton
        let type = newID.contains("cid") ? newID.replace(target: "cid", withString: "") : newID
        newID = newID.contains("cid") ? "container" : newID
        oldID = oldID.contains("cid") ? "container" : oldID
        let numRows = newID.contains("Table") ? self.mainData.dataRows.count : 12
        functionJS = "hideTables('#\(oldID)','#\(newID)', '\(type)');"
        self.delegate?.updateSize(numRows: numRows,
                                  index: self.index,
                                  toTable: oldID != newID,
                                  isTable: newID.contains("Table"))
        newTypeStr = newID.contains("Table") ? "table" : newTypeStr
        mainData.type = ChatComponentType.withLabel(newTypeStr)
        boxWeb.updateType(newType: mainData.type)
        mainData.isLoading = true
    }
    func isEyeOn() -> Bool {
        for column in self.mainData.columnsInfo {
            if !column.isVisible {
                return true
            }
        }
        return false
    }
    func generateSubMenu() {
        let vwBackgroundMenu = UIView()
        superview?.addSubview(vwBackgroundMenu)
        vwBackgroundMenu.edgeTo(vwFather, safeArea: .none)
        vwBackgroundMenu.isUserInteractionEnabled = false
        vwBackgroundMenu.tag = 2
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        contentView.addGestureRecognizer(gesture)
        let vwMenu = UIView()
        vwMenu.tag = 2
        vwMenu.backgroundColor = chataDrawerBackgroundColorPrimary
        vwFather.addSubview(vwMenu)
        vwMenu.cardView()
        if mainData.type != .Table || !formatWB {
            if subMenuOptions.count > 1 {
                subMenuOptions.remove(at: 1)
            }
        } else {
            if subMenuOptions.count < 2 {
                let icon = isEyeOn() ? "icEyeColumnNot" : "icEyeColumn"
                let newOpt = SubMenuOption(title: "Show/Hide columns", action: #selector(showColumns), tag: 1, img: icon)
                subMenuOptions.append(newOpt)
                let newOpt2 = SubMenuOption(title: "Filter Table", action: #selector(showFilter), tag: 3, img: "icFilter")
                subMenuOptions.append(newOpt2)
            }
        }
        contentView.subviews.forEach { (subView) in
            if subView.tag == 1 {
                var finalSafe: DViewSafeArea = .dropDownTopHeight
                if self.mainData.type == .Introduction {
                    finalSafe = .dropDownBottomHeight
                } else if lastQuery {
                    let rowValidation = self.mainData.dataRows.count < 3
                    finalSafe = rowValidation ? .dropDownBottomHeightLeft : finalSafe
                }
                vwMenu.edgeTo(self, safeArea: finalSafe, height: CGFloat(subMenuOptions.count * 40), subView)
            }
        }
        let newStack = UIStackView()
        newStack.getSide(axis: .vertical)
        vwMenu.addSubview(newStack)
        newStack.edgeTo(vwMenu, safeArea: .none)
        subMenuOptions.forEach { (newItem) in
            let newView = UIButton()
            newView.setConfig(text: newItem.title,
                              backgroundColor: .clear,
                              textColor: chataDrawerTextColorPrimary,
                              executeIn: self,
                              action: newItem.action)
            let image = UIImage(named: newItem.img, in: Bundle(for: type(of: self)), compatibleWith: nil)!
            let image2 = image.resizeT(maxWidthHeight: 30)
            newView.contentHorizontalAlignment = .left
            newView.setImage(image2, for: .normal)
            newView.titleLabel?.font = generalFont
            newView.tag = newItem.tag
            newStack.addArrangedSubview(newView)
            newView.edgeTo(newStack, safeArea: .fullStackH)
            newView.clipsToBounds = true
        }
    }
    func generatePopUpSQL() {
        let vwBackgroundMenu = UIView()
        vwBackgroundMenu.tag = 200
        vwBackgroundMenu.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        vwFather.addSubview(vwBackgroundMenu)
        vwBackgroundMenu.edgeTo(vwFather, safeArea: .none)
        let newView = UIView()
        newView.backgroundColor = chataDrawerBackgroundColorPrimary
        newView.cardView()
        vwBackgroundMenu.addSubview(newView)
        newView.edgeTo(vwBackgroundMenu, safeArea: .centerSizeUp, height: 260, padding: 300)
        let lblTitle = UILabel()
        lblTitle.setConfig(text: "Generated SQL",
                           textColor: chataDrawerTextColorPrimary,
                           align: .center)
        newView.addSubview(lblTitle)
        lblTitle.edgeTo(newView, safeArea: .topHeight, height: 50)
        lblTitle.addBorder()
        
        let btnCancel = UIButton()
        btnCancel.setConfig(text: "Ok",
                            backgroundColor: chataDrawerAccentColor,
                            textColor: .white,
                            executeIn: self,
                            action: #selector(closeModal))
        newView.addSubview(btnCancel)
        btnCancel.edgeTo(newView, safeArea: .bottomHeight, height: 40, padding: 8)
        let taSql = UITextView()
        taSql.font = generalFont
        var finalSqlText = ""
        for text in mainData.sql {
            finalSqlText += text
        }
        taSql.backgroundColor = chataDrawerBorderColor
        taSql.text = finalSqlText
        newView.addSubview(taSql)
        taSql.edgeTo(newView, safeArea: .fullPadding , lblTitle, btnCancel , padding: 8)
        
    }
    func generateSelectColumns() {
        dataOriginal = mainData
        let vwBackgroundMenu = UIView()
        vwBackgroundMenu.tag = 200
        vwBackgroundMenu.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        vwFather.addSubview(vwBackgroundMenu)
        vwBackgroundMenu.edgeTo(vwFather, safeArea: .none)
        let newView = UIView()
        newView.backgroundColor = chataDrawerBackgroundColorPrimary
        newView.cardView()
        vwBackgroundMenu.addSubview(newView)
        newView.edgeTo(vwBackgroundMenu, safeArea: .centerSizeUp, height: 260, padding: 300)
        let lblTitle = UILabel()
        lblTitle.setConfig(text: "Show/Hide Columns",
                           textColor: chataDrawerTextColorPrimary,
                           align: .center)
        newView.addSubview(lblTitle)
        lblTitle.edgeTo(newView, safeArea: .topHeight, height: 50)
        lblTitle.addBorder()
        let boxHeader = UIView()
        boxHeader.backgroundColor = .clear
        newView.addSubview(boxHeader)
        boxHeader.edgeTo(newView, safeArea: .topHeightPadding, height: 30, lblTitle, padding: 16)
        isCheckBoxActive = false
        changeCheckStr()
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeState) )
        imgCheck.isUserInteractionEnabled = true
        imgCheck.addGestureRecognizer(tap)
        newView.addSubview(imgCheck)
        imgCheck.edgeTo(boxHeader, safeArea: .rightCenterY, height: 25, padding: 0)
        let lblHeader = UILabel()
        lblHeader.setConfig(text: "Column Name",
                           textColor: chataDrawerTextColorPrimary,
                           align: .center)
        lblHeader.setSize(16, true)
        boxHeader.addSubview(lblHeader)
        lblHeader.edgeTo(boxHeader, safeArea: .leftCenterY, height: 30, imgCheck, padding: 0)
        let lblInfo = UILabel()
        lblInfo.setSize(16, true)
        lblInfo.setConfig(text: "Visibility",
                          textColor: chataDrawerTextColorPrimary,
                          align: .right)
        boxHeader.addSubview(lblInfo)
        lblInfo.edgeTo(boxHeader, safeArea: .leftCenterY, height: 30, imgCheck, padding: 0)
        tbMain.backgroundColor = chataDrawerBorderColor
        newView.addSubview(tbMain)
        tbMain.edgeTo(newView, safeArea: .topHeightPadding, height: 90, boxHeader, padding: 16)
        let stackView = UIStackView()
        stackView.getSide()
        newView.addSubview(stackView)
        stackView.edgeTo(newView, safeArea:.midTopBottom2, tbMain, padding: 16)
        let btnCancel = UIButton()
        btnCancel.setConfig(text: "Cancel",
                            backgroundColor: chataDrawerBorderColor,
                            textColor: chataDrawerTextColorPrimary,
                            executeIn: self,
                            action: #selector(closeModal))
        stackView.addArrangedSubview(btnCancel)
        //btnCancel.edgeTo(newView, safeArea: .fullStackV, height: 50)
        let btnApply = UIButton()
        btnApply.setConfig(text: "Apply",
                           backgroundColor: chataDrawerAccentColor,
                           textColor: .white,
                           executeIn: self,
                           action: #selector(applyChanges))
        stackView.addArrangedSubview(btnApply)
        tbMain.setConfig(dataSource: self)
        tbMain.backgroundColor = .clear
        //btnApply.edgeTo(newView, safeArea: .fullStackV, height: 50)
        
    }
    @objc func changeState(sender: UITapGestureRecognizer) {
        isCheckBoxActive = !isCheckBoxActive
        changeCheckStr()
        for (idx, _) in mainData.columnsInfo.enumerated(){
            mainData.columnsInfo[idx].isVisible = isCheckBoxActive
            arrColumnsData[idx].visibility = isCheckBoxActive
        }
        tbMain.reloadData()
    }
    func changeCheckStr(){
        let imgCheckStr = isCheckBoxActive ? "icCheckTrue" : "icCheckFalse"
        let image = UIImage(named: imgCheckStr, in: Bundle(for: type(of: self)), compatibleWith: nil)!
        let image2 = image.resizeT(maxWidthHeight: 25)
        imgCheck.image = image2
    }
    func generatePopUp () {
        let vwBackgroundMenu = UIView()
        vwBackgroundMenu.tag = 200
        vwBackgroundMenu.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        vwFather.addSubview(vwBackgroundMenu)
        vwBackgroundMenu.edgeTo(vwFather, safeArea: .none)
        let newView = UIView()
        newView.backgroundColor = chataDrawerBackgroundColorPrimary
        newView.cardView()
        vwBackgroundMenu.addSubview(newView)
        newView.edgeTo(vwBackgroundMenu, safeArea: .centerSizeUp, height: 260, padding: 300)
        let lblTitle = UILabel()
        lblTitle.setConfig(text: "Report Problem",
                           textColor: chataDrawerTextColorPrimary,
                           align: .center)
        newView.addSubview(lblTitle)
        lblTitle.edgeTo(newView, safeArea: .topHeight, height: 50)
        let buttonCancel = UIButton()
        buttonCancel.setConfig(text: "✕",
                               backgroundColor: chataDrawerBorderColor,
                               textColor: .darkGray,
                               executeIn: self,
                               action: #selector(closeModal))
        newView.addSubview(buttonCancel)
        buttonCancel.edgeTo(newView, safeArea: .alignViewLeft, height: 50, lblTitle)
        let lblInfo = UILabel()
        lblInfo.setConfig(text: "Please tell us more about the problem you are experiencing:",
                          textColor: chataDrawerTextColorPrimary,
                          align: .center)
        newView.addSubview(lblInfo)
        lblInfo.edgeTo(newView, safeArea: .topHeightPadding, height: 50, lblTitle, padding: 16)
        let tfReport = UITextField()
        tfReport.font = generalFont
        tfReport.textColor = chataDrawerTextColorPrimary
        newView.addSubview(tfReport)
        tfReport.edgeTo(newView, safeArea: .topHeightPadding, height: 70, lblInfo, padding: 16)
        tfReport.cardView()
        tfReport.setLeftPaddingPoints(10)
        tfReport.configStyle()
        tfReport.addTarget(self, action: #selector(actionTyping), for: .editingChanged)
        let stackView = UIStackView()
        stackView.getSide()
        newView.addSubview(stackView)
        stackView.edgeTo(newView, safeArea:.midTopBottom2, tfReport, padding: 16)
        let btnCancel = UIButton()
        btnCancel.setConfig(text: "Cancel",
                            backgroundColor: chataDrawerBorderColor,
                            textColor: chataDrawerTextColorPrimary,
                            executeIn: self,
                            action: #selector(closeModal))
        stackView.addArrangedSubview(btnCancel)
        btnCancel.edgeTo(stackView, safeArea: .fullStackV, height: 100)
        btnReport.setConfig(text: "Report",
                            backgroundColor: chataDrawerAccentColor,
                            textColor: .white,
                            executeIn: self,
                            action: #selector(reportProblemName))
        stackView.addArrangedSubview(btnReport)
        btnReport.edgeTo(stackView, safeArea: .fullStackV, height: 100)
    }
    @objc func nothing(sender: UITapGestureRecognizer) {
        
    }
    @objc func actionTyping(_ sender: UITextField) {
        /*let valid = (sender.text ?? "") != ""
        UIView.animate(withDuration: 0.3) {
            self.btnReport.backgroundColor = valid ? chataDrawerAccentColor : chataDrawerBorderColor
        }*/
        problemMessage = sender.text ?? ""
    }
    @objc func reportProblemName(_ sender: UIButton) {
        vwFather.removeView(tag: 200)
        showAlertResult(msg: problemMessage)
    }
    func generateAlert() {
        let vwBackgroundMenu = UIView()
        superview?.addSubview(vwBackgroundMenu)
        vwBackgroundMenu.edgeTo(vwFather, safeArea: .none)
        vwBackgroundMenu.tag = 2
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        vwBackgroundMenu.addGestureRecognizer(gesture)
        let vwAlert = UIView()
        vwAlert.backgroundColor = .black
        vwBackgroundMenu.addSubview(vwAlert)
        vwAlert.edgeTo(self, safeArea: .bottomHeight, height: 100, padding: 16, secondPadding: 40)
        vwAlert.isHidden = true
        let txtMain = UILabel()
        txtMain.setConfig(text: "The display limit of rows has been reached. Try queryng a smaller time-frame to ensure all yout data is displayed.",
                          textColor: .white,
                          align: .center)
        vwAlert.addSubview(txtMain)
        txtMain.edgeTo(vwAlert, safeArea: .none, padding: 8)
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                        vwAlert.isHidden = false
        }, completion: nil)
        
    }
    func genereMenuReport() {
        let vwBackgroundMenu = UIView()
        superview?.addSubview(vwBackgroundMenu)
        vwBackgroundMenu.edgeTo(vwFather, safeArea: .none)
        vwBackgroundMenu.tag = 2
        vwBackgroundMenu.isUserInteractionEnabled = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        contentView.addGestureRecognizer(gesture)
        let vwMenu = UIView()
        vwMenu.tag = 2
        vwMenu.backgroundColor = chataDrawerBackgroundColorPrimary
        vwFather.addSubview(vwMenu)
        vwMenu.cardView()
        contentView.subviews.forEach { (subView) in
            if subView.tag == 1 {
                var finalSafe: DViewSafeArea = .dropDownTopHeight
                if self.mainData.type == .Introduction {
                    finalSafe = .dropDownBottomHeight
                } else if lastQuery {
                    let rowValidation = self.mainData.dataRows.count < 3
                    finalSafe = rowValidation ? .dropDownBottomHeightLeft : finalSafe
                }
                vwMenu.edgeTo(self, safeArea: finalSafe, height: 120, subView)
            }
        }
        let newStack = UIStackView()
        newStack.getSide(axis: .vertical)
        vwMenu.addSubview(newStack)
        newStack.edgeTo(vwMenu, safeArea: .none)
        menuReportProblem.forEach { (newItem) in
            let newView = UIButton()
            newView.setConfig(text: newItem.title,
                              backgroundColor: .clear,
                              textColor: chataDrawerTextColorPrimary,
                              executeIn: self,
                              action: newItem.action)
            newView.tag = newItem.tag
            newStack.addArrangedSubview(newView)
            newView.edgeTo(newStack, safeArea: .fullStackH)
            newView.clipsToBounds = true
        }
    }
    public func updateChart(){
        self.boxWeb.wbMain.evaluateJavaScript(functionJS, completionHandler: {
            (_,_) in
        })
    }
    public func showFilters(){
        self.boxWeb.wbMain.evaluateJavaScript("showFilter();", completionHandler: {
            (_,_) in
        })
        let tt: AnyObject = "" as AnyObject
        closeModal(tt)
    }
    func sendDrillDown(idQuery: String, obj: String, name: String) {
        delegate?.sendDrillDown(idQuery: idQuery, obj: obj, name: name)
    }
    func sendDrillDownManual(newData: [[String]], columns: [ChatTableColumn], idQuery: String) {
        delegate?.sendDrillDownManual(newData: newData, columns: columns, idQuery: idQuery)
    }
    func updateSize(numQBOptions: Int, index: Int) {
        delegateQB?.updateSize(numQBOptions: numQBOptions, index: self.index)
    }
    func callTips(text: String) {
        delegateQB?.callTips(text: text)
    }
    func openReport(){
        generatePopUp()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrColumnsData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ColumnsCell()
        cell.delegate = self
        cell.configCell(item: arrColumnsData[indexPath.row], index: indexPath.row)
        return cell
    }
    func updateCell(index: Int, visibility: Bool) {
        self.mainData.columnsInfo[index].isVisible = visibility
        arrColumnsData[index].visibility = visibility
        isCheckBoxActive = isStatusOn()
        changeCheckStr()
        tbMain.reloadData()
    }
    func isStatusOn() -> Bool {
        for column in arrColumnsData {
            if !column.visibility{
                return false
            }
        }
        return true
    }
    func resetData() {
        self.mainData = dataOriginal
        self.isCheckBoxActive = false
        buildDataColumns()
        tbMain.reloadData()
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if subview.frame.contains(point) {
                return true
            }
        }
        return false
    }
}
func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}
struct StackSelection {
    var title: String
    var action: Selector
    var tag: Int
    init(
        title: String = "",
        action: Selector = #selector(DataChatCell.reportProblem),
        tag: Int = 0
    ) {
        self.title = title
        self.action = action
        self.tag = tag
    }
}
struct SubMenuOption {
    var title: String
    var action: Selector
    var tag: Int
    var img: String
    init(
        title: String = "",
        action: Selector = #selector(DataChatCell.reportProblem),
        tag: Int = 0,
        img: String = ""
    ) {
        self.title = title
        self.action = action
        self.tag = tag
        self.img = img
    }
}
struct ButtonMenu {
    var imageStr: String
    var action: Selector
    var idHTML: String
}
class myCustomButton: UIButton{
    var idButton: String = ""
}
class newClass: UIButton {
    var newString = ""
}
