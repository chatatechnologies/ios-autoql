//
//  File.swift
//  
//
//  Created by Vicente Rincon on 09/02/22.
//

import Foundation
class WebviewString {
    static let instance = WebviewString()
    func generateWB(_ tableString: String = "") -> String {
        
        return """
            \(getHeaderWB())
            \(getStyleWB())
            \(getBodyWB(tableString))
            \(getScriptWB())
        """
    }
    private func getHeaderWB() -> String {
        return """
            <!DOCTYPE html>
            <html lang="en">
            <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1.0, user-scalable=no">
            <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
            <script src="https://d3js.org/d3.v6.min.js"></script>
            <title></title>
        """
    }
    private func getStyleWB() -> String {
        return """
            <style>
                body, table, th{
                    background: #3b3f46!important;
                    color: #ffffff!important;
              }
                table {
                    padding-top: 0px!important;
                }
                th {
                    position: sticky;
                    top: 0px;
                    z-index: 10;
                    padding: 10px 3px 5px 3px;
                }
                table {
                    font-size: 16px;
                    display: table;
                    min-width: 100%;
                    white-space: nowrap;
                    border-collapse: separate;
                    border-spacing: 0px!important;
                    border-color: grey;
                }
                tr td:first-child {
                    text-align: center;
                }
                td {
                    padding: 3px;
                    text-align: center!important;
              }
                td, th {
                    font-size: 16px;
                    max-width: 200px;
                    white-space: nowrap;
                    width: 50px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    border: 0.5px solid #cccccc;
              }
              span {
                display: none;
              }
              /*border for svg*/
              svg {
                border: 1px solid #aaa;
                /*width: 100%;
                position: relative;
                height: 100%;
                z-index: 0;*/
              }
                tfoot {
                /*display: table-header-group;*/
                    display: none;
              }
              .button {
                border: none;
                color: white;
                padding: 15px 32px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
              }
            </style>
        """
    }
    private func getBodyWB(_ tableString: String = "") -> String {
        return """
            </head>
            <body>

                <div style="display: none;">
                <button class="button" onclick="updateData(TypeEnum.TABLE)">TABLE</button>
                <button class="button" onclick="updateData(TypeEnum.COLUMN)">COLUMN</button>
                <button class="button" onclick="updateData(TypeEnum.BAR)">BAR</button>
                <button class="button" onclick="updateData(TypeEnum.LINE)">LINE</button>
                <button class="button" onclick="updateData(TypeEnum.PIE)">PIE</button>
              </div>
            \(tableString)
        """
    }
    private func getVariablesChart() -> String{
        return """
                var backgroundColor = '#3b3f46';
                var colorPie = ["#26a7e9", "#a5cd39", "#dd6a6a", "#ffa700", "#00c1b2"];
                var colorBi = ['#26a7e9'];//Main color for bars

                var axisX = 'Month';
                var axisY = 'Total Revenue';
                var axisMiddle = 'Total Revenue';
                var nColumns = 0;

                //Main data
                var indexData = -1;
                var dataTmp = [];
                var data = [{name: "May 2019", value: 106630.75},
                {name: "Agoo 2019", value: 104254.00},
                {name: "Sep 2019", value: 57326.75},
                {name: "Oct 2019", value: 122868.00},
                {name: "Nov 2019", value: 100500.00}];
                var aStacked = [];
                var aStacked2 = [];
                var aStackedTmp = [];
                var aCategoryX = [];
                var data2 = [];
                var aAllData = [];
                var aMaxData = [];
                var dataFormatted = [];
                var opacityMarked = [];
                var indexIgnore = [];
                var drillTableY = [106630.75, 104254.00, 57326.75, 122868.00, 100500.00];
                var drillX = ["2019-05", "2019-08", "2019-09", "2019-10", "2019-11"];
                var aDrillData = [];
                var limitName = 0;
                var isCurrency = true;
                var maxValue = 122868;
                var minValue = 0;
                var maxValue2 = -1;
                var minValue2 = -1;
                var aMax = [];
                var aMax2 = [];
                var aCategory = [];
                var aCategory2 = [];
                var aCommon = [];
                //endregion
                //axis X for heatmap
                var aCatHeatX = [];
                //axis Y for heatmap
                var aCatHeatY = [];
        """
    }
    private func getScriptWB() -> String {
        return """
            \(D3Static.functionsD3)
            \(D3Static.typeD3)
            \(getVariablesChart())
            \(D3Static.forD3)
            \(D3Static.initialConfigD3)
            \(D3Charts3D.stackedBar)
            \(D3Charts3D.stackedColumn)
            \(D3Charts3D.bubble)
            \(D3Charts3D.heatMap)
            \(D3Charts3D.multiBar)
            \(D3Charts3D.multiColumn)
            \(D3Charts3D.multiLine)
            \(D3Charts2D.line)
            \(D3Charts2D.bar)
            \(D3Charts2D.column)
            \(D3Charts2D.donut)
            \(D3Static.footerD3)
        """
    }

}
