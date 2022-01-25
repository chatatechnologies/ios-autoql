//
//  ViewController.swift
//  chata
//
//  Created by Vicente Rincón on 02/12/2020.
//  Copyright (c) 2020 Vicente Rincón. All rights reserved.
//

import UIKit
import chata
class DemoViewController: UIViewController, DemoParameterCellDelegate {
    @IBOutlet weak var aiMain: UIActivityIndicatorView!
    let label = UILabel()
    let dataChat = DataMessenger(authentication: authentication(apiKey: "", domain: "", token: ""), projectID: "")
    var parameters: [String : Any] = [:]
    let dashboardView = DashboardView()
    let inputMainView = QueryInputView()
    @IBOutlet weak var tbMain: UITableView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var scMain: UISegmentedControl!
    
    var loginSection: DemoSectionsModel =
    DemoSectionsModel(
        title: "Authentication", arrParameters: [
        DemoParameter(label: "* Project ID", type: .input, value: "", key: "projectID"),
        DemoParameter(label: "* User Email", type: .input, key: "userID", inputType: .mail),
        DemoParameter(label: "* API key", type: .input, value: "", key: "apiKey"),
        DemoParameter(label: "* Domain URL", type: .input, value: "", key: "domain"),
        DemoParameter(label: "* Username", type: .input, key: "username" ),
        DemoParameter(label: "* Password", type: .input, key: "password", inputType: .password),
        DemoParameter(label: "Authenticate", type: .button, key: "login")
    ])
    var constSections: [DemoSectionsModel] = []
    var allSection: [DemoSectionsModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getCredentials(isProd: true)
        addObservers()
        detectDevice()
        dataChat.config.demo = false
        loadSections()
        loadColors()
        loadConfig()
        loadData()
        hideKeyboardWhenTappedAround()
        loadOptions()
        constSections = allSection
        allSection = [allSection[0],allSection[1]]
        tbMain.reloadData()
    }
    func getCredentials(isProd: Bool = false) {
            let pid = isProd ? "accounting-demo" : "spira-demo3"
            let keyS = "AIzaSyCWcKQfsJo3Lk6t2VHflBEY6CF51kEPdx8"//isProd ? "AIzaSyA8EomrHDJxkTnc2euI3NOaGDnUGJLCj2c" : "AIzaSyBxmGxl9J9siXz--dS-oY3-5XRSFKt_eVo"
            let urlS = "https://chata-staging.chata.io"/*isProd ? "https://accounting-demo.chata.io" :
                "https://spira-staging.chata.io"*/
            let user = "admin"/*isProd ? "accountdemo" :
                "admin"*/
            let pass = "admin123"/*isProd ? "accountdemo123" :
                "admin123"*/
            loginSection.arrParameters[0].value = pid
            loginSection.arrParameters[1].value = "vicente@rinro.com.mx"
            loginSection.arrParameters[2].value = keyS
            loginSection.arrParameters[3].value = urlS
            loginSection.arrParameters[4].value = user
            loginSection.arrParameters[5].value = pass
    }
    @IBAction func changeSection(_ sender: Any) {
        switch scMain.selectedSegmentIndex {
        case 0:
            loadDataSource()
        case 1:
            if dataChat.config.authenticationObj.token == "" {
                let alert = UIAlertController(title: "", message: "Please log in", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                scMain.selectedSegmentIndex = 0
            } else {
                loadDashboard()
            }
        default:
            if dataChat.config.authenticationObj.token == "" {
                let alert = UIAlertController(title: "", message: "Please log in", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                scMain.selectedSegmentIndex = 0
            } else {
                loadInput()
            }
        }
    }
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.vwMain.frame.origin.y == 0.0 {
                let size = keyboardSize.height
                self.vwMain.frame.origin.y -= size
            }
        }
    }
    @objc func keyboardWillHide() {
        self.vwMain.frame.origin.y = 0
    }
    func loadDataSource() {
        let mainTag = 100
        tbMain.isHidden = false
        inputMainView.hideAutocomplete()
        tbMain.tag = mainTag
        toggleView(tag: mainTag)
    }
    func loadDashboard() {
        let mainTag = 101
        tbMain.isHidden = true
        inputMainView.isHidden = true
        dashboardView.tag = mainTag
        vwMain.addSubview(dashboardView)
        toggleView(tag: mainTag)
        inputMainView.hideAutocomplete()
        dashboardView.edgeTo(tbMain, safeArea: .none)
        dashboardView.configLoad(authFinal: dataChat.config.authenticationObj, mainView: self.view)
    }
    func loadInput() {
        let mainTag = 102
        inputMainView.tag = mainTag
        vwMain.addSubview(inputMainView)
        inputMainView.loadView()
        toggleView(tag: mainTag)
        inputMainView.edgeTo(vwMain, safeArea: .none)
    }
    func toggleView(tag: Int) {
        vwMain.subviews.forEach { (subView) in
            if subView.tag == tag {
                subView.isHidden = false
            }
            else {
                subView.isHidden = true
            }
            if subView.tag == 1000{
                subView.isHidden = false
            }
        }
        
    }
    func loadOptions(login: Bool = false) {
        if !login {
            scMain.removeSegment(at: 2, animated: false)
            scMain.removeSegment(at: 1, animated: false)
        } else {
            if scMain.numberOfSegments == 1 {
                scMain.insertSegment(withTitle: "Dashboard", at: 1, animated: true)
            }
            
            //scMain.insertSegment(withTitle: "Input/Output", at: 2, animated: true)
        }
    }
    func loadSections(){
        allSection = [
            /*DemoSectionsModel(title: "Data Source", arrParameters: [
                DemoParameter(label: "Demo data", type: .toggle, value: "true", key: "demo")
            ]),*/
            DemoSectionsModel(title: "", arrParameters: [
                DemoParameter(label: "", type: .segment, options: ["Login", "Parameters"], value: "Login", key: "loginS")
            ]),
            loginSection,
            DemoSectionsModel(title: "Customize Widgets", arrParameters: [
                DemoParameter(label: "Reload Data Messenger", type: .button),
                DemoParameter(label: "Open Data Messenger", type: .button, key: "openChat"),
            ]),
            DemoSectionsModel(title: "AutoQL API Configuration Options", arrParameters: [
                DemoParameter(label: "Enable Autocomplete", type: .toggle, value: "\(dataChat.config.autoQLConfigObj.enableAutocomplete)", key: "enableAutocomplete"),
                DemoParameter(label: "Enable Query Validation", type: .toggle, value: "\(dataChat.config.autoQLConfigObj.enableQueryValidation)", key: "enableQueryValidation"),
                DemoParameter(label: "Enable Query Suggestions", type: .toggle, value: "\(dataChat.config.autoQLConfigObj.enableQuerySuggestions)", key: "enableQuerySuggestions"),
                DemoParameter(label: "Enable DrillDowns", type: .toggle, value: "\(dataChat.config.autoQLConfigObj.enableDrilldowns)", key: "enableDrilldowns"),
                DemoParameter(label: "Enable Column Visibility Editor", type: .toggle, value: "\(dataChat.config.autoQLConfigObj.enableColumnVisibilityManager)", key: "enableColumnVisibilityManager"),
                DemoParameter(label: "Enable Notifications", type: .toggle, value: "\(dataChat.config.autoQLConfigObj.enableNotifications)", key: "enableNotifications")
            ]),
            DemoSectionsModel(title: "UI Configuration Options", arrParameters: [
                DemoParameter(label: "Show Data Messenger Button", type: .toggle, value: "\(dataChat.config.isVisible)", key:"isVisible"),
                DemoParameter(label: "Darken Background Behind Data Messenger", type: .toggle, value: "\(dataChat.config.darkenBackgroundBehind)", key:"darkenBackgroundBehind"),
                DemoParameter(label: "Theme", type: .segment, options: ["Light", "Dark"], value: dataChat.config.themeConfigObj.theme.capitalized, key: "theme"),
                DemoParameter(label: "Drawer Placement", type: .segment, options: ["Top", "Bottom", "Left", "Right"], value: dataChat.config.placement.capitalized, key: "placement"),
                DemoParameter(label: "Default Tab", type: .segment, options: ["data-messenger", "explore-queries"], value: dataChat.config.themeConfigObj.theme.capitalized, key: "defaultTab"),
                DemoParameter(label: "Currency Code", type: .input, value: dataChat.config.dataFormattingObj.currencyCode, key: "currencyCode"),
                DemoParameter(label: "Language Code", type: .input, value: dataChat.config.dataFormattingObj.languageCode, key: "languageCode"),
                DemoParameter(label: "Format for Month, Year", type: .input, value: dataChat.config.dataFormattingObj.monthYearFormat, key: "monthYearFormat"),
                DemoParameter(label: "Format for Day, Month, Year", type: .input, value: dataChat.config.dataFormattingObj.dayMonthYearFormat, key: "dayMonthYearFormat"),
                DemoParameter(label: "Number of Decimals for Currency Values", type: .input, value: "\(dataChat.config.dataFormattingObj.currencyDecimals)", key: "currencyDecimals"),
                DemoParameter(label: "Number of Decimals for Quantity Values", type: .input, value: "\(dataChat.config.dataFormattingObj.quantityDecimals)", key: "quantityDecimals"),
                DemoParameter(label: "User Display Name", type: .input, value: dataChat.config.userDisplayName, key: "userDisplayName"),
                DemoParameter(label: "Intro Message", type: .input, value: dataChat.config.introMessage, key: "introMessage"),
                DemoParameter(label: "Query Input Placeholder", type: .input, value: dataChat.config.inputPlaceholder, key: "inputPlaceholder"),
                DemoParameter(label: "Title", type: .input, value: dataChat.config.title, key: "title")
            ]),
            DemoSectionsModel(title: "Chart Colors", arrParameters: [
                
            ]),
            DemoSectionsModel(title: "Dashboard Colors", arrParameters: [
                DemoParameter(label: "Dashboard Title Color", type: .color, value: "#28A8E0", key: "dashboardTitleColor"),
                DemoParameter(label: "Dashboard Background Color", type: .color, value: "#fafafa", key: "dashboardBackgroundColor"),
            ]),
            DemoSectionsModel(title: "Themes Colors", arrParameters: [
                DemoParameter(label: "Light Theme Accent Color", type: .color, value: "#28A8E0", key: "lightTheme"),
                DemoParameter(label: "Dark Theme Accent Color", type: .color, value: "#28A8E0", key: "darkTheme")
            ]),
            DemoSectionsModel(title: "More Configurations", arrParameters: [
                DemoParameter(label: "Maximum Number of Messages", type: .input, value: "\(dataChat.config.maxMessages)", key: "maxMessages"),
                DemoParameter(label: "Enable Explore Queries Tab", type: .toggle, value: "\(dataChat.config.autoQLConfigObj.enableExploreQueriesTab)", key: "enableExploreQueriesTab"),
                DemoParameter(label: "Enable Notifications Tab", type: .toggle, value: "\(dataChat.config.autoQLConfigObj.enableNotificationTab)", key: "enableNotificationTab"),
                DemoParameter(label: "Enable Speech to Text", type: .toggle, value: "\(dataChat.config.enableVoiceRecord)", key: "enableVoiceRecord")
            ])
        ]
        
    }
    func loadColors() {
        let posFather = allSection.firstIndex { (father) -> Bool in
            father.title == "Chart Colors"
        } ?? 0
        for (index, color) in dataChat.config.themeConfigObj.chartColors.enumerated() {
            let demoP = DemoParameter(label: "\(index)", type: .color, value: color, key: "\(index)")
            allSection[posFather].arrParameters.append(demoP)
        }
        tbMain.reloadData()
    }
    func loadData(){
        dataChat.config.isVisible = true
        dataChat.config.userDisplayName = "Test"
        aiMain.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        aiMain.cardView()
    }
    func searchValue(_ key: String) -> String{
        var value = ""
        for section in allSection {
            for sect in section.arrParameters{
                if sect.key == key{
                    value = sect.value
                }
            }
        }
        return value
    }
    func toogleAction(value: Bool, key: String) {
        self.view.endEditing(true)
        setValueByKey(key, "\(value)")
        switch key {
        case "demo":
            dataChat.config.demo = value
            if value { allSection.remove(at: 1) } else { allSection.insert(loginSection, at: 1) }
            tbMain.reloadData()
        case "isVisible":
            dataChat.config.isVisible = !value
            dataChat.isHidden = !value
        case "darkenBackgroundBehind":
            dataChat.config.darkenBackgroundBehind = value
        case "enableAutocomplete":
            dataChat.config.autoQLConfigObj.enableAutocomplete = value
        case "enableQueryValidation":
            dataChat.config.autoQLConfigObj.enableQueryValidation = value
        case "enableQuerySuggestions":
            dataChat.config.autoQLConfigObj.enableQuerySuggestions = value
        case "enableDrilldowns":
            dataChat.config.autoQLConfigObj.enableDrilldowns = value
        case "enableColumnVisibilityManager":
            dataChat.config.autoQLConfigObj.enableColumnVisibilityManager = value
        case "enableNotifications":
            dataChat.config.autoQLConfigObj.enableNotifications = value
        case "enableNotificationTab":
            dataChat.config.autoQLConfigObj.enableNotificationTab = value
        case "enableExploreQueriesTab":
            dataChat.config.autoQLConfigObj.enableExploreQueriesTab = value
        case "enableVoiceRecord":
            dataChat.config.enableVoiceRecord = value
        case "clearOnClose":
            dataChat.config.clearOnClose = value
        default:
            print("invalid toggle")
        }
    }
    func butonAction(key: String){
        self.view.endEditing(true)
        switch key {
        case "login":
            if dataChat.config.authenticationObj.token == "" {
                let posFather = allSection.firstIndex { (father) -> Bool in
                    father.title == "Authentication"
                } ?? 0
                var dict:[String: Any] = [:]
                for input in allSection[posFather].arrParameters {
                    if input.type == DemoParameterType.input{
                        dict[input.key] = input.value
                    }
                }
                self.view.isUserInteractionEnabled = false
                self.aiMain.isHidden = false
                self.aiMain.startAnimating()
                dataChat.login(body: dict) { (success) in
                    DispatchQueue.main.async {
                        let message = success ? "Login Successful!" : "Invalid Credentials"
                        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        auth = DataConfig.authenticationObj
                        self.view.isUserInteractionEnabled = true
                        self.aiMain.stopAnimating()
                        if success {
                            self.resetLogin()
                        }
                    }
                }
            } else {
                dataChat.logout { (success) in
                    let alert = UIAlertController(title: "", message: "Successfully logged out", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    self.resetLogout()
                }
            }
        case "openChat":
            dataChat.createChat()
            /*let vwFather: UIView = UIApplication.shared.keyWindow!
            
            if vwFather.subviews.count >= 2 {
                vwFather.subviews[1].isHidden = false
            } else{
                dataChat.createChat()
            }*/
        default:
            print("invalid button")
        }
    }
    func resetLogout(){
        self.setNewValue(fatherP: "Authentication", sonP: "Logout", value: "Authenticate", changeLabel: true)
        self.loadOptions(login: false)
        self.tbMain.reloadData()
    }
    func resetLogin(){
        self.setNewValue(fatherP: "Authentication", sonP: "Authenticate", value: "Logout", changeLabel: true)
        self.loadOptions(login: true)
        self.tbMain.reloadData()
    }
    func segmentAction(key: String, value: String) {
        self.view.endEditing(true)
        setValueByKey(key, "\(value)")
        switch key {
        case "theme":
            let dark: Bool = value == "Dark"
            let theme = dark ? "darkTheme" : "lightTheme"
            let accentColor = theme.getDataValue(allSection: allSection)
            dataChat.config.themeConfigObj.theme = dark ? "dark" : "light"
            dataChat.config.themeConfigObj.accentColor = accentColor
            dataChat.changeColor()
        case "loginS":
            var tempC = constSections
            if value == "Login" {
                tempC = [constSections[0],constSections[1]]
                
            }
            else {
                tempC.remove(at: 1)
            }
            tempC[0].arrParameters[0].value = value
            allSection = tempC
            tbMain.reloadData()
            if value == "Login" {
                if dataChat.config.authenticationObj.token == "" {
                    self.resetLogout()
                } else {
                    self.resetLogin()
                }
            }
            
        case "defaultTab":
            dataChat.config.defaultTab = value
        case "placement":
            dataChat.config.placement = value.lowercased()
            dataChat.movePosition()
        default:
            print("invalid Key")
        }
    }
    func chageText(name: String, value: String, key: String, color: Bool) {
        setValueByKey(key, "\(value)")
        setDataValue(key: key, value: value)
        if color {
            if value.count == 7 && value.first == "#" {
                tbMain.reloadData()
            }
        }
    }
    func setDataValue(key: String, value: String) {
        switch key {
        case "currencyCode":
            dataChat.config.dataFormattingObj.currencyCode = value
        case "languageCode":
            dataChat.config.dataFormattingObj.languageCode = value
        case "monthYearFormat":
            dataChat.config.dataFormattingObj.monthYearFormat = value
        case "dayMonthYearFormat":
            dataChat.config.dataFormattingObj.dayMonthYearFormat = value
        case "currencyDecimals":
            dataChat.config.dataFormattingObj.currencyDecimals = Int(value) ?? 0
        case "quantityDecimals":
            dataChat.config.dataFormattingObj.quantityDecimals = Int(value) ?? 0
        case "userDisplayName":
            dataChat.config.userDisplayName = value
        case "introMessage":
            dataChat.config.introMessage = value
        case "inputPlaceholder":
            dataChat.config.inputPlaceholder = value
        case "title":
            dataChat.config.title = value
        case "maxMessages":
            dataChat.config.maxMessages = Int(value) ?? 0
        case "0", "1", "2", "3", "4":
            if value.count == 7 && value.first == "#" {
                let idx = Int(key) ?? 0
                dataChat.config.themeConfigObj.chartColors[idx] = value
            }
        case "dashboardTitleColor":
            dataChat.config.dashboardParameters.titleColor = value
        case "dashboardBackgroundColor":
            dataChat.config.dashboardParameters.backgroundDashboard = value
        default:
            print("Invalid")
        }
    }
    func setValueByKey(_ key: String, _ newValue: String) {
        for (posFather, section) in allSection.enumerated() {
            for (posSon, sect) in section.arrParameters.enumerated(){
                if sect.key == key{
                    allSection[posFather].arrParameters[posSon].value = newValue
                    break
                }
            }
        }
    }
    func setNewValue(fatherP: String, sonP: String, value: String, byKey: Bool = false, changeLabel: Bool = false) {
        let posFather = allSection.firstIndex { (father) -> Bool in
            father.title == fatherP
        } ?? 0
        let sonPosition = allSection[posFather].arrParameters.firstIndex { (son) -> Bool in
            if byKey{
                return son.key == sonP
            } else {
                return son.label == sonP
            }
        } ?? 0
        if changeLabel {
            allSection[posFather].arrParameters[sonPosition].label = "\(value)"
        } else{
            allSection[posFather].arrParameters[sonPosition].value = "\(value)"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension DemoViewController: UITableViewDelegate, UITableViewDataSource {
    func loadConfig() {
        view.backgroundColor = .white
        dataChat.show(self.view)
        tbMain.dataSource = self
        tbMain.delegate = self
        tbMain.separatorStyle = .none
        tbMain.bounces = true
        tbMain.allowsSelection = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSection[section].arrParameters.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = getSize(type: allSection[indexPath.section].arrParameters[indexPath.row].type, text: allSection[indexPath.section].title)
        return size
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let finalCell = DemoParameterCell()
        finalCell.contentView.backgroundColor = .white
        finalCell.textLabel?.textColor = .black
        finalCell.delegate = self
        finalCell.configCell(data: allSection[indexPath.section].arrParameters[indexPath.row])
        return finalCell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.text = allSection[section].title
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        view.addSubview(label)
        view.backgroundColor = .white
        label.edgeTo(view, safeArea:.none)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return allSection[section].title == "" ? 0 : 30
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return allSection.count
    }
    func getSize (type: DemoParameterType, text: String) -> CGFloat {
        switch type {
        case .button:
            return 50
        case .toggle, .defaultCase :
            return 90
        case .input:
            return 70
        case .color:
            return 70
        case .segment:
            let size: CGFloat = text == "" ? 30 : 60
            return size
        }
        
    }
    func detectDevice () {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        isIpad = deviceIdiom == .pad
    }
}
extension String {
    func hexToColor () -> UIColor {
        var cString: String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if (cString.count) <= 5 {
            return UIColor.gray
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 235.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 235.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 235.0,
            alpha: CGFloat(1.0)
        )
    }
}
extension UITextField {
    func borderRadius() {
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.cornerRadius = 5.0
    }
    
}
extension String {
    func getDataValue(allSection: [DemoSectionsModel], value: Bool = true) -> String {
        var father = ""
        for section in allSection {
            for sect in section.arrParameters{
                if sect.key == self{
                    father = value ? sect.value : section.title
                }
            }
        }
        return father
    }
}
extension UIView {
    func cardView(border: Bool = true, color: UIColor = .gray) {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = color.cgColor
        /*self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0*/
        self.layer.masksToBounds = false
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
