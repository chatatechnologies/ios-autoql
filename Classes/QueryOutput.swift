//
//  QueryOutput.swift
//  chata
//
//  Created by Vicente Rincon on 16/09/20.
//

import Foundation
import WebKit
public class QueryOutput: UIView, WKNavigationDelegate{
    public var authenticationInput: authentication = authentication()
    let Doingtest = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
        <title></title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1.0, user-scalable=no">
        <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
        <script src="https://unpkg.com/sticky-table-headers"></script>
                <script src="https://code.highcharts.com/highcharts.js"></script>
        <link href=“https://fonts.googleapis.com/css?family=Titillium+Web” rel=“stylesheet”>
        <meta http-equiv='cache-control' content='no-cache'>
        <meta http-equiv='expires' content='0'>
        <meta http-equiv='pragma' content='no-cache'>
        </head>
        <body>
        <style type="text/css">
            body, table, th{
                background: #ffffff!important;
                color: #5D5D5D!important;
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
                display: table;
                min-width: 100%;
                white-space: nowrap;
                border-collapse: separate;
                border-spacing: 0px!important;
                border-color: grey;
            }
            table {
                font-family: '-apple-system','HelveticaNeue';
                font-size: 15.5px;
            }
            tr td:first-child {
                text-align: center;
            }
            td {
                padding: 3px;
                text-align: center!important;
            }
            td, th {
              font-family: '-apple-system','HelveticaNeue';
              font-size: 15.5px;
              max-width: 200px;
              white-space: nowrap;
              width: 50px;
              overflow: hidden;
              text-overflow: ellipsis;
              border: 0.5px solid #cccccc;
            }
            .green{
                color: #2ecc40;
            }
            .red {
                color: red;
            }
            .highcharts-credits,.highcharts-button-symbol, .highcharts-exporting-group {
                display: none;
            }
            .highcharts-background{
                fill: #ffffff!important;
            }
            .splitView{
                position: relative;
            }
        </style>
        <div class="splitView">
        <div id='container' class='container'></div>
            
            
            <table id='idTableBasic'><thead><tr><th>Invoice Number</th><th>Batch</th><th>Customer Number</th><th>Customer Name</th><th>Date</th><th>Invoice Amount</th><th>Type</th><th>Status</th><th>Term</th><th>Term Description</th><th>Discount Date</th><th>Tax</th><th>Due Date</th><th>Discount Percent</th><th>Report Name</th><th>Report Description</th></tr></thead><tbody><tr><td><span class='limit'>INV00000003</span></td><td><span class='limit'>AR00000003</span></td><td><span class='limit'>CUST007</span></td><td><span class='limit'>Bill & Sons</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$3,150</span></td><td><span class='limit'>Invoiced</span></td><td><span class='limit'>Printed</span></td><td><span class='limit'>30</span></td><td><span class='limit'>Due in 30 days.</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$150</span></td><td><span class='limit'>Aug 10 2016</span></td><td><span class='limit'>$0</span></td><td><span class='limit'>Invoice Report</span></td><td><span class='limit'>Invoice Report</span></td></tr><tr><td><span class='limit'>INV00000003</span></td><td><span class='limit'>AR00000003</span></td><td><span class='limit'>CUST007</span></td><td><span class='limit'>Bill & Sons</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$3,150</span></td><td><span class='limit'>Invoiced</span></td><td><span class='limit'>Printed</span></td><td><span class='limit'>30</span></td><td><span class='limit'>Due in 30 days.</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$150</span></td><td><span class='limit'>Aug 10 2016</span></td><td><span class='limit'>$0</span></td><td><span class='limit'>Invoice Report</span></td><td><span class='limit'>Invoice Report</span></td></tr><tr><td><span class='limit'>INV00000004</span></td><td><span class='limit'>AR00000004</span></td><td><span class='limit'>CUST007</span></td><td><span class='limit'>Bill & Sons</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$2,174</span></td><td><span class='limit'>Invoiced</span></td><td><span class='limit'>Printed</span></td><td><span class='limit'>30</span></td><td><span class='limit'>Due in 30 days.</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$104</span></td><td><span class='limit'>Aug 10 2016</span></td><td><span class='limit'>$0</span></td><td><span class='limit'>Invoice Report</span></td><td><span class='limit'>Invoice Report</span></td></tr><tr><td><span class='limit'>INV00000004</span></td><td><span class='limit'>AR00000004</span></td><td><span class='limit'>CUST007</span></td><td><span class='limit'>Bill & Sons</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$2,174</span></td><td><span class='limit'>Invoiced</span></td><td><span class='limit'>Printed</span></td><td><span class='limit'>30</span></td><td><span class='limit'>Due in 30 days.</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$104</span></td><td><span class='limit'>Aug 10 2016</span></td><td><span class='limit'>$0</span></td><td><span class='limit'>Invoice Report</span></td><td><span class='limit'>Invoice Report</span></td></tr><tr><td><span class='limit'>INV00000005</span></td><td><span class='limit'>AR00000004</span></td><td><span class='limit'>CUST007</span></td><td><span class='limit'>Bill & Sons</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$1,906</span></td><td><span class='limit'>Invoiced</span></td><td><span class='limit'>Printed</span></td><td><span class='limit'>30</span></td><td><span class='limit'>Due in 30 days.</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$91</span></td><td><span class='limit'>Aug 10 2016</span></td><td><span class='limit'>$0</span></td><td><span class='limit'>Invoice Report</span></td><td><span class='limit'>Invoice Report</span></td></tr><tr><td><span class='limit'>INV00000005</span></td><td><span class='limit'>AR00000004</span></td><td><span class='limit'>CUST007</span></td><td><span class='limit'>Bill & Sons</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$1,906</span></td><td><span class='limit'>Invoiced</span></td><td><span class='limit'>Printed</span></td><td><span class='limit'>30</span></td><td><span class='limit'>Due in 30 days.</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$91</span></td><td><span class='limit'>Aug 10 2016</span></td><td><span class='limit'>$0</span></td><td><span class='limit'>Invoice Report</span></td><td><span class='limit'>Invoice Report</span></td></tr><tr><td><span class='limit'>INV00000006</span></td><td><span class='limit'>AR00000005</span></td><td><span class='limit'>CUST001</span></td><td><span class='limit'>Great Big North</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$2,688</span></td><td><span class='limit'>Invoiced</span></td><td><span class='limit'>Printed</span></td><td><span class='limit'>30</span></td><td><span class='limit'>Due in 30 days.</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$128</span></td><td><span class='limit'>Aug 10 2016</span></td><td><span class='limit'>$0</span></td><td><span class='limit'>Invoice Report</span></td><td><span class='limit'>Invoice Report</span></td></tr><tr><td><span class='limit'>INV00000006</span></td><td><span class='limit'>AR00000005</span></td><td><span class='limit'>CUST001</span></td><td><span class='limit'>Great Big North</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$2,688</span></td><td><span class='limit'>Invoiced</span></td><td><span class='limit'>Printed</span></td><td><span class='limit'>30</span></td><td><span class='limit'>Due in 30 days.</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$128</span></td><td><span class='limit'>Aug 10 2016</span></td><td><span class='limit'>$0</span></td><td><span class='limit'>Invoice Report</span></td><td><span class='limit'>Invoice Report</span></td></tr><tr><td><span class='limit'>INV00000007</span></td><td><span class='limit'>AR00000005</span></td><td><span class='limit'>CUST001</span></td><td><span class='limit'>Great Big North</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$2,688</span></td><td><span class='limit'>Invoiced</span></td><td><span class='limit'>Printed</span></td><td><span class='limit'>30</span></td><td><span class='limit'>Due in 30 days.</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$128</span></td><td><span class='limit'>Aug 10 2016</span></td><td><span class='limit'>$0</span></td><td><span class='limit'>Invoice Report</span></td><td><span class='limit'>Invoice Report</span></td></tr><tr><td><span class='limit'>INV00000007</span></td><td><span class='limit'>AR00000005</span></td><td><span class='limit'>CUST001</span></td><td><span class='limit'>Great Big North</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$2,688</span></td><td><span class='limit'>Invoiced</span></td><td><span class='limit'>Printed</span></td><td><span class='limit'>30</span></td><td><span class='limit'>Due in 30 days.</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$128</span></td><td><span class='limit'>Aug 10 2016</span></td><td><span class='limit'>$0</span></td><td><span class='limit'>Invoice Report</span></td><td><span class='limit'>Invoice Report</span></td></tr><tr><td><span class='limit'>INV00000008</span></td><td><span class='limit'>AR00000005</span></td><td><span class='limit'>CUST001</span></td><td><span class='limit'>Great Big North</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$2,688</span></td><td><span class='limit'>Invoiced</span></td><td><span class='limit'>Printed</span></td><td><span class='limit'>30</span></td><td><span class='limit'>Due in 30 days.</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$128</span></td><td><span class='limit'>Aug 10 2016</span></td><td><span class='limit'>$0</span></td><td><span class='limit'>Invoice Report</span></td><td><span class='limit'>Invoice Report</span></td></tr><tr><td><span class='limit'>INV00000008</span></td><td><span class='limit'>AR00000005</span></td><td><span class='limit'>CUST001</span></td><td><span class='limit'>Great Big North</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$2,688</span></td><td><span class='limit'>Invoiced</span></td><td><span class='limit'>Printed</span></td><td><span class='limit'>30</span></td><td><span class='limit'>Due in 30 days.</span></td><td><span class='limit'>Jul 11 2016</span></td><td><span class='limit'>$128</span></td><td><span class='limit'>Aug 10 2016</span></td><td><span class='limit'>$0</span></td><td><span class='limit'>Invoice Report</span></td><td><span class='limit'>Invoice Report</span></td></tr></tbody></table>
        </div>
        <script>
            var type = '#idTableBasic';
            var xAxis = 'Date';
            var yAxis = 'Batch';
            var dataChartBi = [["Jul 11 2016", 30586.5]];
            var datachartTri = [];
            var dataChartLine = [];
            var categoriesX = ["Jul 11 2016"];
            var categoriesY = [];
            var drillX = ["1468195200", "1468195200", "1468195200", "1468195200", "1468195200", "1468195200", "1468195200", "1468195200", "1468195200", "1468195200", "1468195200", "1468195200"];
            var drillTableY = [];
            var drillSpecial = [];
            var drillY = [];
            var colorAxis = "#5D5D5D";
            var colorFill = "#ffffff";
            var second = ""
        var color1 = "#355C7D";              var actual = "";
              var colors = ["#355C7D", "#6C5B7B", "#C06C84", "#F67280", "#F8B195"];
              var chart;
              var colorGhost = 'rgba(0,0,0,0)';
              var styleTooltip = {color: '#fff', display: 'none'}
              var subTitle = { text:'' }
              var yAxisTitle = {
                title: {
                    text: yAxis,
                    style: {
                            color: colorAxis
                    }
                }
              }
            var xAxisStyle = { color: colorAxis };
            var defaultChart =
              {
                chart: {
                  backgroundColor: colorGhost,
                  fill: colorGhost,
                  plotBackgroundColor: null,
                  plotBorderWidth: null,
                  plotShadow: false,
                  type: "column"
                },
                title: subTitle,
                subTitle: subTitle,
                colorAxis: {
                  reversed: false,
                  min: 0,
                  minColor: '#FFFFFF',
                  maxColor: '#26a7df'
                },
                showInLegend: true,
                legend: false,
                dataLabels: {
                  enabled: false
                },
                tooltip: {
                  backgroundColor: colorGhost,
                  style: styleTooltip,
                  formatter: function () {
                    if (dataChartBi.length > 0){
                         drillDown(drillX[this.point.x])
                    } else{
                         drillDown(drillX[this.point.y]);
                    }
                    return "";
                  }
                },
                plotOptions: {
                  pie: {
                  allowPointSelect: true,
                  cursor: 'pointer',
                  dataLabels: {
                    enabled: false,
                    style: {
                      color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                  },
                    showInLegend: true
                  }
                },
                colors: colors,
                series: [0]
              };

                    $('td').click(function() {
                    triTypeTable = datachartTri.length > 0;
                    var $this = $(this);
                    var row = $this.closest('tr').index();
                    var column = $this.closest('td').index();
                    var firstColumn = $this.closest('tr');
                    var finalText = firstColumn[0].firstChild.innerText;
                    var strDate = firstColumn[0].children[1].innerText;
                    if (type == "idTableDataPivot" ){
                        finalText += "_"+drillSpecial[column - 1];
                    } else if (type == "idTableDatePivot" ) {
                        finalText = $this[0].childNodes[0].id
                    } else if ((type == "#idTableBasic" && triTypeTable) || (type == "idTableBasic" && triTypeTable) ) {
                        finalText += "_"+drillTableY[row];
                    }
                    //var d = new Date( Date.parse('2017 2') );
                   drillDown( finalText );
            });
            function formatterLabel(value) {
                if (value.length > 7) {
                    return value.slice(0, 7) + "...";
                }
              return value;
            }
            function drillDown(position){
                try {
                    webkit.messageHandlers.drillDown.postMessage(position+""+second);
                } catch(err) {
                    console.log(position);
                };
            }
            function changeGraphic(graphic) {
               if (graphic == "idTableBasic" || graphic == "idTableDataPivot" || graphic == "idTableDatePivot"){
                   typeTable()
               }
               else{
                   typeChart(graphic)
               }
            }
            function typeTable(){
               //$('#container').hide(400);
            }
            function finalSize(invert){
                var defaultWidth = "100%";
                var defaultHeight = "90%";
                var dynamicWidthSize = ""+categoriesX.length * 10+"%";
                var widthSize = categoriesX.length <= 10 ? defaultWidth : dynamicWidthSize;
                var dynamicHeightSize = ""+categoriesY.length * 10+"%";
                var heightSize = categoriesY.length <= 10 ? defaultHeight : dynamicHeightSize;
                var heightSizeFinal = invert ? heightSize : defaultHeight;
                $('.container, #container').css({ "width": widthSize, "position": "relative","height":heightSizeFinal, "z-index": "0" });
            }
            function typeChart(graphic){
               var inverted = graphic == "column" || graphic == "line" ? false : true;
               switch (graphic)
               {
                   case "pie":
                        pieType();
                        break;
                   case "line":
                        lineType();
                       break;
                   case "word_cloud":
                       cloudType();
                       break;
                   case "column":
                   case "bar":
                        biType(graphic,inverted);
                        break;
                   case "contrast_bar":
                   case "contrast_line":
                   case "contrast_column":
                       biType3(graphic,inverted);
                        break;
                   case "forecasting":
                   case "status_forecasting":
                       foresType(graphic);
                       break;
                   case "bubble":
                   case "heatmap":
                        triType(graphic);
                        break;
                   case "stacked_bar":
                        stackedType(true);
                        break;
                   case "stacked_column":
                        stackedType(false);
                        break;
                   case "stacked_area":
                   case "stacked_line":
                        stackedArea();
                        break;
                }
            }
                    function formatLabel(value) {
                if (value.length > 7) {
                    return value.slice(0, 7) + "...";
                }
              return value;
            }
            function pieType(){
               $('.container, #container').css({ "width": "99%", "position": "relative","height":"80%", "z-index": "0" });
               chart.destroy()
               chart = Highcharts.chart('container', {
                  
                chart: {
                  backgroundColor: colorGhost,
                  fill: colorGhost,
                  plotBackgroundColor: null,
                  plotBorderWidth: null,
                  plotShadow: false,
                  type: "pie",
                  inverted: false
                },
                title: subTitle,
                subTitle: subTitle,
                xAxis: {
                  gridLineWidth: 0,
                  categories: categoriesX,
                  labels: {
                    rotation: -60,
                    style: {
                            color: colorAxis,
                             fontSize:'15.5px',
                             fontFamily: ['-apple-system','HelveticaNeue']
                    },
                    
                  },

                  title: {
                    text: xAxis,
                    style: {
                            color: colorAxis
                        }
                  }
                },
                yAxis: {
                  gridLineWidth: 0,
                  labels: {
                    style: {
                        color: colorAxis,
                        fontSize:'15.5px',
                        fontFamily: ['-apple-system','HelveticaNeue']
                    },
                    
                  },
                  title: yAxisTitle
                },
                colorAxis: {
                  reversed: false,
                  min: 0,
                  minColor: '#FFFFFF',
                  maxColor: '#26a7df'
                },
                dataLabels: {
                  enabled: false
                },
                tooltip: {
                  backgroundColor: colorGhost,
                  style: styleTooltip,
                  formatter: function () {
                    if (dataChartBi.length > 0){
                         drillDown(drillX[this.point.x])
                    } else{
                         drillDown(drillX[this.point.y]);
                    }
                    return "";
                  }
                },
                plotOptions: {
                  pie: {
                  allowPointSelect: true,
                  cursor: 'pointer',
                  dataLabels: {
                    enabled: false,
                    style: {
                      color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                    }
                  },
                    showInLegend: true
                  }
                },
                colors: colors,
                series: [{
                       colorByPoint: true,
                       data: dataChartBi
                   }]
               });

            }
            function lineType(){
                finalSize(false);
                if (dataChartBi.length > 0){
                    biType("line",false);
                }else{
                    chart.destroy();
                        chart = Highcharts.chart('container', {
                            colors: colors,
                            title: subTitle,
                            subTitle: subTitle,
                            yAxis: {
                                title: {
                                    text: yAxis
                                },
                                labels: {
                                   style: {
                                       color: colorAxis,
                                   },
                                    
                                 },
                            },
                            legend: {
                                       itemStyle: {
                                           color: colorAxis,
                                           fontWeight: 'bold'
                                       }
                                   },
                            xAxis: {
                                categories: categoriesX,
                                legend:{
                                    step:1
                                },
                                labels: {
                                   style: {
                                       color: colorAxis,
                                   },
                                    formatter: function(){
                                      return formatterLabel(this.value);
                                    }
                                 },
                               
                                title: {
                                    text: xAxis,
                                    style: {
                                       color: colorAxis,
                                       fontSize:'15.5px',
                                       fontFamily: ['-apple-system','HelveticaNeue']
                                   }
                                }
                            },
                            chart: {
                                type: "line"
                            },
                            series: dataChartLine,
                            tooltip: {
                                formatter: function () {
                                    drillDown(drillX[this.point.x])
                                    return "";
                                }
                            },
                        });
                        
                }
            }
            function biType(type,inverted){
                finalSize(inverted);
                chart.destroy()
                        chart = Highcharts.chart('container', defaultChart);
                chart.update({
                            chart: {
                                type: type,
                                inverted: inverted
                            },
                            
                            xAxis: {
                                 gridLineWidth: 0,
                                 categories: categoriesX,
                                 labels: {
                                   rotation: inverted ? 0 : -60,
                                   style: xAxisStyle,
                                    formatter: function(){
                                      return formatterLabel(this.value);
                                    }
                                 },
                                 
                                 title: {
                                   text: xAxis
                                 }
                               },
                            series: [{
                                    colorByPoint: false,
                                    name: categoriesX,
                                    data: dataChartBi
                                }],
                            tooltip: {
                                backgroundColor: colorGhost,
                                style: styleTooltip,
                                formatter: function () {
                                    drillDown(drillX[this.point.x])
                                    return "";
                                }
                            }
                        });
            }
            function biType3(type,inverted){
                finalSize(inverted);
                typeFinal = type.replace("contrast_", "");
                chart.destroy()
                        chart = Highcharts.chart('container', {
                            chart: {
                                type: typeFinal
                            },
                            colors: colors,
                            xAxis: {
                                 gridLineWidth: 0,
                                 categories: categoriesX,
                                 labels: {
                                   rotation:-60,
                                   style: xAxisStyle,
                                    formatter: function(){
                                      return formatterLabel(this.value);
                                    }
                                 },
                                 
                                 title: {
                                   text: xAxis
                                 }
                               },
                            series: dataChartLine
                        });
            }
                    function triType(type){
                finalSize(false);
                chart.destroy();
                        chart = Highcharts.chart('container', {
                            chart: {
                                type: type,
                                inverted: false
                            },
                            title: subTitle,
                            subTitle: subTitle,
                            xAxis: {
                                gridLineWidth: 0,
                                categories: categoriesX,
                                labels: {
                                    rotation: -60,
                                    step:1,
                                    style: xAxisStyle,
                                    formatter: function(){
                                      return formatterLabel(this.value);
                                    }
                                },
                                title: {
                                    text: xAxis
                                }
                            },
                            yAxis: {
                                min: 0,
                                gridLineWidth: 0,
                                categories: categoriesY,
                                title: {
                                    text: yAxis
                                },
                                labels: {
                                   style: {
                                       color: colorAxis
                                   },
                                    
                                 },
                            },
                            colorAxis: {
                                reversed: false,
                                min: 0,
                                minColor: colorFill,
                                maxColor: colors[0]
                            },
                            legend: {
                                align: 'right',
                                layout: 'vertical',
                                margin: 0,
                                reversed: false,
                                verticalAlign: 'middle'
                            },
                            tooltip: {
                                backgroundColor: colorGhost,
                                 style: styleTooltip,
                                formatter: function () {
                                     drillDown(""+categoriesX[this.point.x]+"_"+drillY[this.point.y])
                                    return "";
                                }
                            },
                            series: [{
                                    colorByPoint: false,
                                    dataLabels: {
                                        enabled: false
                                    },
                                    data: datachartTri
                           }]
                        });
            }
            
            function stackedType(invert){
                finalSize(invert);
                var rotation = invert ? 0 : -60
                chart.destroy();
                        chart = Highcharts.chart('container', {
                            chart: {
                                type: 'column',
                                inverted: invert
                            },
                            title: subTitle,
                            subTitle: subTitle,
                            yAxis: {
                                title: {
                                    text: yAxis
                                },
                                labels: {
                                   style: {
                                       color: colorAxis,
                                   },
                                    
                                 },
                            },
                            legend: {
                                enabled: false
                            },
                            xAxis: {
                                categories: categoriesX,
                                labels: {
                                    rotation: rotation,
                                    step:1,
                                    style: xAxisStyle,
                                    formatter: function(){
                                      return formatterLabel(this.value);
                                    }
                                },
                                title: {
                                    text: xAxis
                                }
                            },
                            dataLabels: {
                                enabled: false,
                                style: {
                                    color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                                }
                            },
                            tooltip: {
                                 backgroundColor: colorGhost,
                                 style: styleTooltip,
                                 formatter: function () {
                                     var position = categoriesY.indexOf(this.series.name);
                                     console.log(position);
                                     drillDown(""+categoriesX[this.point.x]+"_"+drillY[position]);
                                   return "";
                                 }
                               },
                            colors: colors,
                            plotOptions: {
                                column: {
                                    stacking: 'normal'
                                }
                            },
                            series: dataChartLine
                        });
            }
        function stackedArea(){
            
            var rotation = -60
            chart.destroy();
                    chart = Highcharts.chart('container', {
                        chart: {
                            type: "area",
                            inverted: false
                        },
                        title: subTitle,
                        subTitle: subTitle,
                        yAxis: {
                            title: {
                                text: xAxis
                            },
                            labels: {
                               style: {
                                   color: colorAxis,
                               },
                                
                             },
                        },
                        legend: {
                            enabled: false
                        },
                        xAxis: {
                            categories: categoriesY,
                            labels: {
                                rotation: rotation,
                                step:1,
                                style: xAxisStyle,
                                formatter: function(){
                                  return formatterLabel(this.value);
                                }
                            },
                            title: {
                                text: yAxis
                            }
                        },
                        dataLabels: {
                            enabled: false,
                            style: {
                                color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                            }
                        },
                        tooltip: {
                             backgroundColor: colorGhost,
                             style: styleTooltip,
                             formatter: function () {
                                 var position = categoriesY.indexOf(this.series.name);
                                 console.log(position);
                                 drillDown(""+categoriesX[this.point.x]+"_"+drillY[position]);
                               return "";
                             }
                           },
                        colors: [colors[0]],
                        plotOptions: {
                            column: {
                                stacking: 'normal'
                            }
                        },
                        series: dataChartLine
                    });
        }
        startScript();
        function startScript() {
            chart = Highcharts.chart('container', defaultChart);
        }
        hideAll();
        function hideAll(){
            $('table').css({ "width": "100%", "position": "relative","height":"90%", "z-index": "0" });
            $( "#idTableBasic, #idTableDataPivot, #idTableDatePivot, #container" ).hide();
            if (type == "#idTableBasic" || type == "#idTableDataPivot" || type == "#idTableDatePivot"){
                $(""+type+"").show()
            } else{
                $("#container").show()
                changeGraphic(type);
                if (false){
                    $( "#idTableBasic").show()
                }
            }
        }
        function hideTables(idHide, idShow, type2) {
            if (idHide != idShow){
              $( idHide ).hide(0);
              $( idShow ).show(0);
            }
            //$( idShow ).show("slow");
            type = type2;
            changeGraphic(type2);
        }
        </script>
        </body>
        </html>
    """
    
    public var queryResponse: [String: Any] = [:]
    //public var queryInputRef = nil
    public var displayType: String = ""
    public var height: Int = 0
    public var width: Int = 0
    public var activeChartElementKey: String = ""
    public var renderTooltips: Bool = true
    public var autoSelectQueryValidationSuggestion: Bool = true
    public var queryValidationSelections : String = ""
    public var renderSuggestionsAsDropdown: Bool = false
    public var suggestionSelection: String = ""
    //public var dataFormatting: [S
    var wvMain = WKWebView()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public func start(mainView: UIView, subView: UIView) {
        mainView.addSubview(self)
        self.edgeTo(mainView, safeArea: .bottomPaddingtoTop, subView)
        self.backgroundColor = .black
        DataConfig.authenticationObj = self.authenticationInput
        wsUrlDynamic = self.authenticationInput.domain
        generateComponents()
    }
    private func generateComponents() {
        self.addSubview(wvMain)
        wvMain.edgeTo(self, safeArea: .nonePadding, height: 16, padding: 16)
        wvMain.loadHTMLString(Doingtest, baseURL: nil)
    }
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
}

