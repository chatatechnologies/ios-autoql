//
//  DataChatCell.swift
//  chata
//
//  Created by Vicente Rincon on 24/02/20.
//

import Foundation
protocol DataChatCellDelegate: class {
    func sendText(_ text: String, _ safe: Bool)
    func deleteQuery(numQuery: Int)
    func updateSize(numRows: Int, index: Int, toTable: Bool, isTable: Bool)
    func sendDrillDown(idQuery: String, obj: String, name: String)
}
class DataChatCell: UITableViewCell, ChatViewDelegate, BoxWebviewViewDelegate {
    private var data = ChatComponentModel()
    private var menuButtons: [ButtonMenu] = []
    private var index: Int = 0
    private var functionJS = ""
    let boxWeb = BoxWebviewView()
    let defaultType = ButtonMenu(imageStr: "icTable", action: #selector(changeChart), idHTML: "idTableBasic")
    var buttonDefault: myCustomButton?
    var lastQuery: Bool = false
    weak var delegate: DataChatCellDelegate?
    static var identifier: String {
        return String(describing: self)
    }
    func configCell(allData: ChatComponentModel, index: Int, lastQueryFinal: Bool = false) {
        lastQuery = lastQueryFinal
        data = allData
        //self.
        self.index = index
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        genereteData()
        self.index = index
    }
    func loadLeftMenu(report: Bool = false) {
        let new = ButtonMenu(imageStr: "icDelete", action: #selector(deleteQuery), idHTML: "idDelete")
        let reportProblem = ButtonMenu(imageStr: "icReport", action: #selector(deleteQuery), idHTML: "icReport")
        menuButtons.append(new)
        menuButtons.append(reportProblem)
    }
    func genereteData() {
        switch data.type {
        case .Introduction:
            getIntroduction()
            loadLeftMenu()
        case .Webview, .Table, .Bar, .Line, .Column, .Pie, .Bubble, .Heatmap, .StackBar, .StackColumn, .StackArea:
            if !data.isLoading{
                getWebView()
                loadLeftMenu()
            }
        case .Suggestion:
            getSuggestion()
            loadLeftMenu()
        case .Safetynet:
            getSafetynet()
            loadLeftMenu()
        case .QueryBuilder:
            getQueryBuilder()
        }
    }
    private func getIntroduction(){
        let newView = IntroductionView()
        newView.loadLabel(text: data.text)
        self.contentView.addSubview(newView)
        newView.cardView(border: !data.user)
        let align: DViewSafeArea = data.user ? .paddingTopRight : .paddingTopLeft
        newView.backgroundColor = data.user ? chataDrawerAccentColor : chataDrawerBackgroundColor
        if !data.user && index != 0 && DataConfig.autoQLConfigObj.enableDrilldowns && data.webView != "error"{
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(showDrillDown))
            newView.addGestureRecognizer(tapgesture)
        }
        newView.lbl.textColor = data.user ? .white : chataDrawerTextColorPrimary
        data.user || data.webView == "" ? nil : loadButtons(area: .modal2Right, buttons: menuButtons, view: newView)
        newView.edgeTo(self, safeArea: align)
        self.sizeToFit()
    }
    private func getQueryBuilder() {
        let viewQB = QueryBuilderView()
        viewQB.delegate = self
        self.contentView.addSubview(viewQB)
        viewQB.cardView()
        viewQB.edgeTo(self, safeArea: .paddingTop)
        
    }
    private func getWebView() {
        buttonDefault = createButton(btn: defaultType)
        boxWeb.loadWebview(strWebview: data.webView, idQuery: data.idQuery)
        boxWeb.cardView()
        boxWeb.dataMain = data
        boxWeb.drilldown = data.drillDown
        boxWeb.delegate = self
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(showHide))
        boxWeb.addGestureRecognizer(tapgesture)
        self.contentView.addSubview(boxWeb)
        boxWeb.edgeTo(self, safeArea: .paddingTop)
        let buttons = getButtons(num: data.dataRows.count > 0 ? data.dataRows[0].count : 0,
                                 columns: data.columns)
        loadButtons(area: .modal2, buttons: buttons, view: boxWeb)
        loadButtons(area: .modal2Right, buttons: menuButtons, view: boxWeb)
        self.sizeToFit()
    }
    private func loadButtons(area: DViewSafeArea, buttons: [ButtonMenu], view: UIView) {
        let changeViewMain = UIView()
        let changeView = UIStackView()
        changeViewMain.cardView()
        changeViewMain.backgroundColor = chataDrawerBackgroundColor
        self.contentView.addSubview(changeViewMain)
        changeViewMain.edgeTo(self, safeArea: area, height: 40, view, padding: CGFloat(buttons.count * 40) )
        changeView.cardView()
        changeView.getHorizontal()
        changeViewMain.addSubview(changeView)
        changeView.edgeTo(changeViewMain, safeArea: .modal, height: 40)
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
        //button.setImage(button.imageView?.changeColor().image, for: .normal)
        button.addTarget(self, action: btn.action, for: .touchUpInside)
        return button
    }
    private func getButtons(num: Int, columns: [ChatTableColumnType]) -> [ButtonMenu] {
        var buttonsFinal: [ButtonMenu] = []
        let datePivot = supportPivot(columns: data.columns)
        var contrast = false
        switch num {
        case 2:
            if data.biChart {
                buttonsFinal = getBichart()
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
                    buttonsFinal += [
                        ButtonMenu(imageStr: "icStackedBar", action: #selector(changeChart), idHTML: "cid\(typeTry)bar"),
                        ButtonMenu(imageStr: "icStackedColumn", action: #selector(changeChart), idHTML: "cid\(typeTry)column"),
                        ButtonMenu(imageStr: "icArea", action: #selector(changeChart), idHTML: "cidstacked_area")
                        //ButtonMenu(imageStr: "icLine", action: #selector(changeChart), idHTML: "cid\(contrast ? typeTry : "")line"),
                    ]
                }
            }
        default:
            if data.biChart{
                buttonsFinal = getBichart()
            }
            //buttonsFinal = []
        }
        if datePivot && !contrast{
            let datePivot = ButtonMenu(imageStr: "icTableData", action: #selector(changeChart), idHTML: "idTableDatePivot")
            buttonsFinal.append(datePivot)
        }
        return buttonsFinal
    }
    func getBichart() -> [ButtonMenu] {
        return [
                         ButtonMenu(imageStr: "icColumn", action: #selector(changeChart), idHTML: "cidcolumn"),
                         ButtonMenu(imageStr: "icBar", action: #selector(changeChart), idHTML: "cidbar"),
                         ButtonMenu(imageStr: "icLine", action: #selector(changeChart), idHTML: "cidline"),
                         ButtonMenu(imageStr: "icPie", action: #selector(changeChart), idHTML: "cidpie")
        ]
    }
    @objc func showHide() {
        print("Func")
    }
    @objc func showDrillDown() {
        delegate?.sendDrillDown(idQuery: data.idQuery, obj: "", name: "")
    }
    private func getSuggestion() {
        let newView = SuggestionView()
        newView.delegate = self
        newView.loadConfig(options: data.options, query: data.text)
        //newView.loadWebview(strWebview: data.webView)
        newView.cardView()
        self.contentView.addSubview(newView)
        newView.edgeTo(self, safeArea: .paddingTop)
        loadButtons(area: .modal2Right, buttons: menuButtons, view: newView)
        self.sizeToFit()
    }
    private func getSafetynet() {
        let newView = SafetynetView()
        newView.cardView()
        self.contentView.addSubview(newView)
        newView.edgeTo(self, safeArea: .paddingTop)
        newView.loadConfig(data, lastQueryFinal: lastQuery)
        newView.delegate = self
        loadButtons(area: .modal2Right, buttons: menuButtons, view: newView)
        self.sizeToFit()
    }
    func sendText(_ text: String, _ safe: Bool) {
        delegate?.sendText(text, safe)
    }
    @IBAction func deleteQuery(_ sender: AnyObject){
        delegate?.deleteQuery(numQuery: index)
    }
    @IBAction func changeChart(_ sender: myCustomButton){
        let btnTemp: myCustomButton = myCustomButton()
        var newID = sender.idButton
        var oldID = buttonDefault?.idButton ?? ""
        let newTypeStr = newID.replace(target: "cid", withString: "")
        btnTemp.setImage(sender.imageView?.image, for: .normal)
        btnTemp.idButton = newID
        sender.setImage(buttonDefault?.imageView?.image, for: .normal)
        sender.idButton = oldID
        buttonDefault?.setImage(btnTemp.imageView?.image, for: .normal)
        buttonDefault?.idButton = btnTemp.idButton
        let type = newID.contains("cid") ? newID.replace(target: "cid", withString: "") : newID
        newID = newID.contains("cid") ? "container" : newID
        oldID = oldID.contains("cid") ? "container" : oldID
        let numRows = newID.contains("Table") ? self.data.dataRows.count : 12
        functionJS = "hideTables('#\(oldID)','#\(newID)', '\(type)');"
        print(functionJS)
        //if oldID != newID{
        self.delegate?.updateSize(numRows: numRows,
                                  index: self.index,
                                  toTable: oldID != newID,
                                  isTable: newID.contains("Table"))
        //data.type =
        data.type = ChatComponentType.withLabel(newTypeStr)
        boxWeb.updateType(newType: data.type)
        data.isLoading = true
        //}
        /*delayWithSeconds(0.2) {
            self.boxWeb.wbMain.evaluateJavaScript("hideTables('#\(oldID)','#\(newID)', '\(type)');", completionHandler: {
               (_,_) in
               
           })
        }*/
        
    }
    public func updateChart(){
        self.boxWeb.wbMain.evaluateJavaScript(functionJS, completionHandler: {
            (_,_) in
        })
    }
    func sendDrillDown(idQuery: String, obj: String, name: String) {
        delegate?.sendDrillDown(idQuery: idQuery, obj: obj, name: name)
    }
}
func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
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
