//
//  ChartsFunctions.swift
//  chata
//
//  Created by Vicente Rincon on 10/04/20.
//

import Foundation
func getFooterScript() -> String{
    return """
            \(getConstants())
            \(getConfigScript())
            \(getBiTypeCharts())
            \(getTriTypeChart())
    """
}
private func getConstants() -> String {
    return """
          var actual = "";
          var colors = \(DataConfig.themeConfigObj.chartColors);
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
                formatter: function(){
                  return formatterLabel(this.value);
                }
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
    
    """
}
private func getBiTypeCharts() -> String{
    return """
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
    """
}
func getTriTypeChart() -> String {
    return """
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
            var rotation = invert ? 10 : 40
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
    """
}
func getConfigScript() -> String {
    return """
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
                webkit.messageHandlers.drillDown.postMessage(position);
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
    """
}
