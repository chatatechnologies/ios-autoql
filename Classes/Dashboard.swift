//
//  Dashboard.swift
//  chata
//
//  Created by Vicente Rincon on 28/04/20.
//

import Foundation
import WebKit
public class Dashboard: UIView, DashboardComponentCellDelegate, WKNavigationDelegate {
    let tbMain = UITableView()
    var dataDash: [DashboardModel] = []
    var imageView = UIImageView(image: nil)
    let vwDrillDown = UIView()
    var mainView = UIView()
    var vwWebview = UIView()
    var wbMain = WKWebView()
    var imageView2 = UIImageView(image: nil)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        tbMain.delegate = self
        tbMain.dataSource = self
        self.addSubview(tbMain)
        tbMain.edgeTo(self, safeArea: .none)
        //print(testVAR)
    }
    
    public func loadDashboard(
        view: UIView,
        autentification: authentication,
        mainView: UIView
    ){
        self.backgroundColor = .red
        self.edgeTo(view, safeArea: .none)
        self.mainView = mainView
        DashboardService().getDashboards(apiKey: autentification.apiKey) { (dashboards) in
            DispatchQueue.main.async {
                self.dataDash = dashboards
                self.tbMain.reloadData()
               
            }
            
        }
    }
    func sendDrillDown(idQuery: String, obj: [String], name: [String], title: String) {
        print(idQuery)
        vwDrillDown.tag = 100
        vwDrillDown.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        mainView.addSubview(vwDrillDown)
        vwDrillDown.edgeTo(mainView, safeArea: .none)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(closeDrillDown))
        vwDrillDown.addGestureRecognizer(tapgesture)
        let component = UIView()
        component.backgroundColor = .white
        component.cardView()
        vwDrillDown.addSubview(component)
        component.edgeTo(vwDrillDown, safeArea: .nonePadding, height: 30, padding: 50)
        let lbTitle = UILabel()
        lbTitle.text = title
        lbTitle.textAlignment = .center
        component.addSubview(lbTitle)
        lbTitle.edgeTo(component, safeArea: .topPadding, height: 30, padding: 20)
        component.addSubview(vwWebview)
        vwWebview.backgroundColor = .gray
        vwWebview.edgeTo(component, safeArea: .bottomPaddingtoTop, lbTitle, padding: 20 )
        vwWebview.addSubview(wbMain)
        wbMain.edgeTo(vwWebview, safeArea: .none)
        wbMain.navigationDelegate = self
        loaderWebview()
        DashboardService.instance.getDrillDownDashboard(idQuery: idQuery, name: obj, value: name) { (dataComponent) in
            DispatchQueue.main.async {
                self.wbMain.loadHTMLString(dataComponent.webView, baseURL: nil)
            }
        }
    }
    func loaderWebview(_ load: Bool = true){
        if load {
            let bundle = Bundle(for: type(of: self))
            let path = bundle.path(forResource: "gifBalls", ofType: "gif")
            let url = URL(fileURLWithPath: path!)
            imageView2.loadGif(url: url)
            //let jeremyGif = UIImage.gifImageWithName("preloader")
            //let imageView = UIImageView(image: image)
            imageView2.tag = 5
            vwWebview.addSubview(imageView2)
            imageView2.edgeTo(vwWebview, safeArea: .centerSize, height: 50, padding: 100)
        } else{
            vwWebview.subviews.forEach { (view) in
                if view.tag == 5{
                    view.removeFromSuperview()
                }
            }
        }
    }
    @objc func closeDrillDown(){
        for view in mainView.subviews{
            if view.tag == 100 {
                view.removeFromSuperview()
            }
        }
    }
    public func executeDashboard(){
        
        for (index, dash) in self.dataDash.enumerated() {
            //let indexPath = IndexPath(row: index, section: 0)
            //guard let cell = self.tbMain.cellForRow(at: indexPath) as? DashboardComponentCell else {return}
            //cell.loaderWebview()
            print(index)
            DashboardService().getDashQuery(query: dash.query, type: dash.displayType,
                                            split: dash.splitView, splitType: dash.secondDisplayType) { (component) in
                DispatchQueue.main.async {
                    self.dataDash[index].webview = component.webView
                    self.dataDash[index].type = component.type
                    self.dataDash[index].text = component.text
                    self.dataDash[index].idQuery = component.idQuery
                    self.dataDash[index].columnsInfo = component.columnsInfo
                    self.tbMain.reloadData()
                }
            }
        }
    }
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loaderWebview(false)
        //progress(off: true, viewT: wbChart!)
    }
    
}
extension Dashboard: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataDash.count
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getSizeDashboard(row: dataDash[indexPath.row], width: self.frame.width)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DashboardComponentCell()
        cell.delegate = self
        cell.configCell(data: dataDash[indexPath.row])
        //cell.addSubview(newView)
        return cell
    }
    
    
}
