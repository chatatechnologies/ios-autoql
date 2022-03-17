//
//  File.swift
//  
//
//  Created by Vicente Rincon on 09/02/22.
//

import Foundation
var webviewStringExample = "<html><body><h1>Hello World</h1></body></html>"
func generateWB() -> String {
    return """
        \(getHeaderWB())
        \(getStyleWB())
        \(getBodyWB())
        \(getScriptWB())
    """
}
func getHeaderWB() -> String {
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
func getStyleWB() -> String {
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
func getBodyWB() -> String {
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
                
        <table id="idTableBasic"><thead><tr><th>Month</th><th>Total Revenue</th></tr></thead><tfoot><tr><th>Month</th><th>Total Revenue</th></tr></tfoot><tbody><tr><td>Nov 2019</td><td>$106,630.75</td></tr><tr><td>Oct 2019</td><td>$104,254.00</td></tr><tr><td>Sep 2019</td><td>$57,326.75</td></tr><tr><td>Ago 2019</td><td>$122,868.00</td></tr><tr><td>May 2019</td><td>$100,500.00</td></tr></tbody></table>
    """
}
func getScriptWB() -> String {
    return """
        <script>
        function getFirst10(string) {
          var newString = '';
          if (string.length < 11) {
            newString = string;
          } else {
            newString = string.substring(0, 10) + '...';
          }
          return newString;
        }

        function digitsCount(n) {
            var count = 0;
            if ( n >= 1) ++count;

            while (n/ 10 >= 1) {
                n /= 10;
                ++count;
            }
            return count;
        }

        function angle(d) {
            var a = (d.startAngle + d.endAngle) * 90 / Math.PI - 90;
            return a > 90 ? a - 180 : a;
        }

        function isHorizontal(type) {
          return (type == TypeEnum.BAR);
        }

        function clearSvg() {
            //remove svg
            d3.select('svg').remove();
        }

        function updateSize() {
          if (typeChart === TypeEnum.LINE) {
            if (nColumns === 2) {
              var width1 = getWidthMargin();
              width = (width1 * 1.5);
            } else {
              width = getWidthMargin();
            }
          } else {
            switch (typeChart) {
              case TypeEnum.COLUMN:
              case TypeEnum.BAR:
              case TypeEnum.PIE:
                var width1 = getWidthMargin();
                width = (width1 * 1.5);
                break;
              default:
                width = getWidthMargin();
                break;
            }
          }
          height = $(window).height() - margin.top - margin.bottom;
          radius = Math.min(width, height) / 2;
        }

        function getWidthMargin() {
          return $(window).width() - margin.left - margin.right;
        }

        function isMultiple(typeChart) {
          return nColumns > 3 && (typeChart == TypeEnum.BAR || typeChart == TypeEnum.COLUMN || typeChart == TypeEnum.LINE);
        }

        function updateData(tmpChart, isReload) {
          //region set nColumns
            var aTmpData = getDataOrMulti();
          var keys = Object.keys(aTmpData.length !== 0 ?  aTmpData[0] : {'':''});
          nColumns = keys.length;
          //endregion
            var _isMultiple = isMultiple(tmpChart);
            if (dataTmp.length && (isAgain || _isMultiple))
          {
                if (_isMultiple)
              typeChart = tmpChart;
            isAgain = false;
          }
          else
          {
            dataTmp = [];
                var aTmp = getDataOrMulti();
            aTmp.forEach(element => {
                    var copied = Object.assign({}, element);
                    indexIgnore.forEach(index => {
                delete copied[`time_${index}`];
              });
                    dataTmp.push(copied);
                });
                if (typeChart != tmpChart || isReload) {
              typeChart = tmpChart;
            }
          }

          updateSize();
          //region choose table or chart
          switch (tmpChart) {
            case TypeEnum.TABLE:
            case TypeEnum.PIVOT:
              $("svg").hide(0);
              var aID = tmpChart == TypeEnum.TABLE ? ["idTableBasic", "idTableDataPivot"] : ["idTableDataPivot", "idTableBasic"];
              $(`#${aID[0]}`).show(0);
              $(`#${aID[1]}`).hide(0);
              break;
            default:
              $("#idTableBasic").hide(0);
              $("#idTableDataPivot").hide(0);
              clearSvg();
              switch(typeChart) {
                case TypeEnum.COLUMN:
                  if (nColumns == 2) {
                    setColumn();
                  } else {
                    setMultiColumn();
                  }
                break;
                case TypeEnum.BAR:
                  if (nColumns == 2) {
                      setBar();
                    } else {
                      setMultiBar();
                    }
                  break;
                case TypeEnum.LINE:
                  if (nColumns == 2) {
                    setLine();
                  } else {
                    setMultiLine();
                  }
                  break;
                case TypeEnum.PIE:
                  setDonut();
                  break;
                        case TypeEnum.HEATMAP:
                            setHeatMap();
                            break;
                        case TypeEnum.BUBBLE:
                  setBubble();
                  break;
                case TypeEnum.STACKED_BAR:
                  setStackedBar();
                  break;
                        case TypeEnum.STACKED_COLUMN:
                            setStackedColumn();
                            break;
              }
              break;
          }
          //endregion
        }

        function drillDown(content) {
            try {
                Android.drillDown(content);
            } catch(err) {
                console.log("Good content: " + content);
            };
        }

        function modalCategories(type, content) {
          try {
                Android.modalCategories(type, content);
            } catch(err) {
                console.log(`Good content: ${content}; ${type}`);
            };
        }

        function updateSelected(index_value) {
          try {
            Android.updateSelected(index_value);
          } catch (err) {
            console.log(`Good content: ${index_value}`);
          }
        }

        function getAxisX() {
          var extra = '';
          if (nColumns > 2) {
            extra = '▼';
          }
          return `${axisX} ${extra}`;
        }

        function getAxisY() {
          var extra = '';
          if (nColumns > 2) {
            extra = '▼';
          }
          return `${axisY} ${extra}`;
        }

        function svgMulti() {
          var svg = d3.select('body').append('svg')
                .attr('width', width + margin.bottom + margin.right)
                .attr('height', height + margin.top + margin.left + 30);
          return svg;
        }

        function addText(svg, textAnchor, fontSize, rotate, x, y, fillColor, id, text, click) {
          svg.append('text')
                .attr('text-anchor', textAnchor)
                .style('font-size', fontSize)
            .attr('transform', `rotate(${rotate})`)
                .attr('x', x)//for center
                .attr('y', y)//for set on bottom with -10
                .attr('fill', fillColor)
                .attr('id', id)
                .text(text)
            .on('click', click);
        }

        function addCircle(svg, cx, cy, r, fill, id, fStyle, fClick) {
          svg.append('circle')
            .attr('cx', cx)
            .attr('cy', cy)
            .attr('r', r)
            .attr('fill', fill)
            .attr('id', id)
            .attr('style', fStyle)
            .on('click', fClick);
        }

        function splitAxis(x) {
          return `${getFirst10(x.split('_')[0])}`;
        }

        function formatAxis(y) {
          return `${fformat(y)}`;
        }

        function axisMulti(svg, isLeft, xBand, height, _tickSize, formatAxis) {
          var svg = svg.append("g");
          if (height !== undefined)
          {
            svg = svg.attr('transform', `translate(0,${height})`)
          }
          var axis = isLeft ? d3.axisLeft(xBand) : d3.axisBottom(xBand);
          axis = axis.tickSize(_tickSize).tickFormat(x => formatAxis(x));
            svg.call(axis);
          return svg;
        }

        function completeAxisMultiple(axis, pointX, pointY, rotate) {
          axis
            .selectAll('text')
            //rotate text
            .attr('transform', `translate(${pointX}, ${pointY})rotate(${rotate})`)
            //Set color each item on X axis
            .attr('fill', '#909090')
            .style('text-anchor', 'end');
        }

        function setMultiCategory(aIndex, _IsCurrency, onlyIndex) {
            if (onlyIndex !== undefined) {
            var aTmp = _IsCurrency ? aCategory : aCategory2;
            axisY = aTmp[onlyIndex];
          } else {
            axisY = _IsCurrency ? 'Amount' : 'Quantity';
          }
          indexIgnore = [];
          aIndex.forEach(index => {
            indexIgnore.push(index);
          });
            isCurrency = _IsCurrency;
          dataTmp = [];
          updateData(typeChart, true);
        }

        function setIndexData(indexRoot, indexCommon) {
          var common = aCommon[indexCommon];
          axisX = common;
          indexData = indexRoot;
          dataTmp = [];
          updateData(typeChart, true);
        }

        //region not mutable
        const TypeEnum = Object.freeze({
          "TABLE": 1,
          "PIVOT": 2,
          "COLUMN": 3,
          "BAR": 4,
          "LINE": 5,
          "PIE": 6,
          "HEATMAP": 7,
          "BUBBLE": 8,
          "STACKED_BAR": 9,
          "STACKED_COLUMN": 10,
          "STACKED_AREA": 11,
          "UNKNOWN": 0});
            
        const TypeManage = Object.freeze({
            'CATEGORIES': 'CATEGORIES',
            'DATA': 'DATA',
          'SELECTABLE': 'SELECTABLE',
          'PLAIN': 'PLAIN'
        });

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

        //REGION max letters in name
        for (const item in getDataOrMulti()) {
          var value = getDataOrMulti()[item].name.length;
          if (limitName < value) {
            limitName = value;
            if (limitName > 10) {
              limitName = 110;
              break;
            } else {
              limitName *= 10;
            }
          }
        }
        //ENDREGION

        //REGION get max value
        for (const item in getDataOrMulti()) {
          var value = getDataOrMulti()[item].value;
          if (getMaxValue() < value) {
            maxValue = value;
          }
        }
        //ENDREGION

        //The left margin makes the left border visible
        var typeChart = TypeEnum.COLUMN;
        var digits = digitsCount(getMaxValue());
        var _plusSingle = digits == 1 ? 10 : 0;
        var _maxValue = (digits * 8) + 35 + _plusSingle;
        var _bottom = typeChart == isHorizontal() ? _maxValue : limitName;
        var _left = typeChart == isHorizontal() ? limitName : _maxValue;
        //width dynamic, height dynamic
        var margin = {
          top: 20,
          right: 20,
          bottom: _bottom,
          left: _left
        };
        var width = 0;
        var height = 0;
        var isAgain = false;

        function setStackedBar() {
          var svg = svgMulti().append('g')
                .attr('transform', `translate(${margin.left + 60}, ${margin.top})`);

            var withReduce = width - 100;
            //region rewrite
          var subgroups = [];
            var stackedData = getStackedData();
          stackedData.map(function(a1) {
            var keys1 = Object.keys(a1);
            keys1.map(function(b1) {
              if (b1 != 'name' && subgroups.indexOf(b1) === -1) {
                subgroups.push(b1);
              }
            });
          });
          //endregion
          var groups = [];
          stackedData.map(function(item) {
            var vGroup = item.name;
            if (groups.indexOf(vGroup) === -1) {
              groups.push(vGroup);
            }
          });
          // Add X axis
          var x = d3.scaleBand()
            .domain(groups)
            .range([0, height])
            .padding(0.2);
          svg.append('g')
            .call(d3.axisLeft(x)
              .tickSize(7)
              .tickSizeOuter(0)
                    .tickFormat(x =>`${getFirst10(x)}`)
                )
          //set color for domain and ticks
            .style("color", '#909090');

          // Add Y axis
          var y = d3.scaleLinear()
            .domain([0, getStackedMax()])
            .range([0, withReduce]);
          svg.append('g')
            .attr('transform', 'translate(0,' + height + ')')
            .call(
              d3.axisBottom(y)
              .tickSize(0))
            .call(
                    g => g.selectAll('.tick line')
                    .clone()
                    .attr('stroke-opacity', 0.1)
                    .attr('y2', -height))
            //Remove line on domain for Y axis
            .call(g => g.select('.domain').remove())
            .selectAll('text')
              .attr('fill', '#909090');;

          // color palette = one color per subgroup
          var colorPie = ["#26a7e9", "#a5cd39", "#dd6a6a", "#ffa700", "#00c1b2"];
          var color = d3.scaleOrdinal()
            .domain(subgroups)
            .range(colorPie);
            
          var stackedData = d3.stack().keys(subgroups)(stackedData);

          // Show the bars
          svg.append('g')
            .selectAll('g')
            // Enter in the stack data = loop key per key = group per group
            .data(stackedData)
            .enter().append('g')
            .attr('fill', function(d) { return color(d.key); })
            .selectAll('rect')
            // enter a second time = loop subgroup per subgroup to add all rectangles
            .data(function(d) { return d; })
            .enter()
                .append('rect')
                    .attr('id', function(item, _) { return `${item.data.name}`;})
              .attr('x', function(d) { return y(d[0]); })
              .attr('height', x.bandwidth())
              .attr('y', function(d) { return x(d.data.name); })
              .attr('width', function(d) { return y(d[1]) - y(d[0]); })
              .on('click', function(_, d) {
                        var idParent = this.id;
                var subgroupName = d3.select(this.parentNode).datum().key;
                var subgroupValue = d.data[subgroupName];
                drillDown(subgroupName + '_' + idParent);
              });
                    
            //Add X axis label:
          addText(svg, 'end', 16, 0, (withReduce  / 2) + margin.top, height + margin.left, '#808080', '', axisMiddle + '▼', function () {
            modalCategories(TypeManage.CATEGORIES);
          });
            
            //Y axis label:
          addText(svg, 'end', 16, -90, margin.top + (-height / 2), 0  -margin.bottom + 25, '#808080', axisY, getAxisY(), function () {
            modalCategories(TypeManage.DATA, this.id);
          });

          var withReduce = width - 100;
          var factorBack = margin.top;
          addText(svg, 'start', 16, 0, withReduce + margin.right - 10, 0, '#808080', axisX, getAxisX(), function () {
            modalCategories(TypeManage.DATA, this.id);
          });
          for (var index = 0; index < getCategoriesStack().length; index++) {
                if (indexIgnore.includes(index)) continue;
            var item = getCategoriesStack()[index];

            addText(svg, 'start', 12, 0, withReduce + margin.right + 10, factorBack, '#808080', `id_${index}`, item, function () {
              var id = this.id;
              adminStacked(id, subgroups);
            });

            addCircle(svg, withReduce + margin.right - 5, factorBack - 5, 5, colorPie[indexCircle(index)], `idcircle_${index}`,
            function () {
              return `opacity: ${opacityMarked.includes(index) ? '0.5' : '1'}`;
            },
            function () {
              var id = this.id;
              adminStacked(id, subgroups);
            });

            factorBack += 20;
          }
        }

        function setStackedColumn() {
          var svg = svgMulti().append('g')
                .attr('transform', `translate(${margin.left + 60}, ${margin.top})`);

          var withReduce = width - 100;
            //region rewrite
          var subgroups = [];
            var stackedData = getStackedData();
          stackedData.map(function(a1) {
            var keys1 = Object.keys(a1);
            keys1.map(function(b1) {
              if (b1 != 'name' && subgroups.indexOf(b1) === -1) {
                subgroups.push(b1);
              }
            });
          });
          //endregion
          var groups = [];
          stackedData.map(function(item) {
            var vGroup = item.name;
            if (groups.indexOf(vGroup) === -1) {
              groups.push(vGroup);
            }
          });
          // Add X axis
          var x = d3.scaleBand()
            .domain(groups)
            .range([0, withReduce])
            .padding(0.2);
          svg.append('g')
            .attr('transform', 'translate(0,' + height + ')')
            .call(
              d3.axisBottom(x)
              .tickSize(7)
              .tickSizeOuter(0)
                    .tickFormat(x =>`${getFirst10(x)}`)
            )
            //set color for domain and ticks
            .style("color", '#909090')
            .selectAll('text')
              .attr('transform', d => getCategoriesStack()[0].length > 10 ? `translate(0, 5)rotate(0)` : `translate(-35, 30)rotate(-45)`);

          // Add Y axis
          var y = d3.scaleLinear()
            .domain([0, getStackedMax()])
            .range([ height, 0 ]);
          svg.append('g')
            .call(
              d3.axisLeft(y)
              .tickSize(0))
          //Remove line on domain for Y axis
          .call(g => g.select('.domain').remove())
          //region set lines by each value for y axis
          .call(
                g => g.selectAll('.tick line')
                .clone()
                .attr('stroke-opacity', 0.1)
                .attr('x2', withReduce))
          .selectAll('text')
            .attr('fill', '#909090');

          // color palette = one color per subgroup
          var colorPie = ["#26a7e9", "#a5cd39", "#dd6a6a", "#ffa700", "#00c1b2"];
          var color = d3.scaleOrdinal()
            .domain(subgroups)
            .range(colorPie);

          var stackedData = d3.stack().keys(subgroups)(stackedData);

          // Show the bars
          svg.append('g')
            .selectAll('g')
            // Enter in the stack data = loop key per key = group per group
            .data(stackedData)
            .enter().append('g')
            .attr('fill', function(d) { return color(d.key); })
            .selectAll('rect')
            // enter a second time = loop subgroup per subgroup to add all rectangles
            .data(function(d) { return d; })
            .enter()
            .append('rect')
            .attr('id', function(item, _) { return `${item.data.name}`;})
            .attr('x', function(d) { return x(d.data.name); })
            .attr('height', function(d) { return y(d[0]) - y(d[1]); })
            .attr('y', function(d) { return y(d[1]); })
            .attr('width', x.bandwidth())
            .on('click', function(_, d) {
              var idParent = this.id;
              var subgroupName = d3.select(this.parentNode).datum().key;
              var subgroupValue = d.data[subgroupName];
              drillDown(subgroupName + '_' + idParent);
            });
                
            //Add X axis label:
          addText(svg, 'end', 16, 0, (width / 2) + margin.top, height + margin.left + 20, '#808080', axisY, getAxisY(), function () {
            modalCategories(TypeManage.DATA, this.id);
          });
            
            //Y axis label:
          addText(svg, 'end', 16, -90, margin.top + (-height / 2), 0  -margin.bottom + 25, '#808080', '', axisMiddle + '▼', function () {
            modalCategories(TypeManage.CATEGORIES);
          });

          var withReduce = width - 100;
          var factorBack = margin.top;
          addText(svg, 'start', 16, 0, withReduce + margin.right - 10, 0, '#808080', axisX, getAxisX(), function () {
            modalCategories(TypeManage.DATA, this.id);
          });
          for (var index = 0; index < getCategoriesStack().length; index++) {
                if (indexIgnore.includes(index)) continue;
            var item = getCategoriesStack()[index];

            addText(svg, 'start', 12, 0, withReduce + margin.right + 10, factorBack, '#808080', `id_${index}`, item, function () {
              var id = this.id;
              adminStacked(id, subgroups);
            });

            addCircle(svg, withReduce + margin.right - 5, factorBack - 5, 5, colorPie[indexCircle(index)], `idcircle_${index}`,
            function () {
              return `opacity: ${opacityMarked.includes(index) ? '0.5' : '1'}`;
            },
            function () {
              var id = this.id;
              adminStacked(id, subgroups);
            });

            factorBack += 20;
          }
        }

        function setBubble() {
          var svg = svgMulti().append('g')
                .attr('transform', `translate(${margin.left + 60}, ${margin.top})`);

          // Add X axis
          var x = d3.scaleBand()
            .domain(aCatHeatX)
            .range([ 0, width ]);
          svg.append('g')
            .attr('transform', 'translate(0,' + height + ')')
            .call(
              d3.axisBottom(x)
              .tickSize(0))
            .call(g => g.select('.domain').remove())
            .selectAll('text')
            .attr('transform', 'translate(0, 10)')
            .attr('fill', '#909090');
          
          var y = d3.scaleBand()
            .range([ height, 0 ])
            .domain(aCatHeatY)
          svg.append("g")
            .call(
              d3.axisLeft(y)
              .tickSize(0)
              .tickFormat(x =>`${getFirst10(x)}`))
            //Remove line on domain for Y axis
            .call(g => g.select('.domain').remove())
            .selectAll('text')
              .attr('fill', '#909090');

          // Add dots
          svg.append('g')
            .selectAll('dot')
            .data(data)
            // .data(data1)
            .enter()
            .append('circle')
            .attr('id', function(item, i){ return `${item.name}_${item.group}`;})
            .attr('cx', function (d) { return x(d.group) + (x.bandwidth() / 2); } )
            .attr('cy', function (d) { return y(d.name) + (y.bandwidth() / 2); } )
            .attr('r', function (d) { return d.value; })
            .style('fill', '#26a7df')
            .style('opacity', '0.65')
            .attr('stroke', '#26a7e9')
            .on('click', function(_) {
              var idParent = this.id;
              drillDown(idParent);
            });
                
            //Add X axis label:
          addText(svg, 'end', 16, 0, (width / 2) + margin.top, height + margin.left, '#808080', '', axisY);
            
            //Y axis label:
          addText(svg, 'end', 16, -90, margin.top + (-height / 2), 0  -margin.bottom + 25, '#808080', '', axisX);
        }

        function setHeatMap() {
          var svg = svgMulti().append('g')
                .attr('transform', `translate(${margin.left + 60}, ${margin.top})`);

          var x = d3.scaleBand()
            .range([ 0, width ])
            .domain(aCatHeatX)
            .padding(0.01);
          svg.append('g')
            .attr('transform', 'translate(0,' + height + ')')
            .call(
              d3.axisBottom(x)
              .tickSize(0))
            .call(g => g.select('.domain').remove())
            .selectAll('text')
            .attr('transform', 'translate(0, 10)')
            .attr('fill', '#909090');

          var y = d3.scaleBand()
            .range([ height, 0 ])
            .domain(aCatHeatY)
            .padding(0.01);
          svg.append("g")
            .call(
              d3.axisLeft(y)
              .tickSize(0)
              .tickFormat(x =>`${getFirst10(x)}`))
            //Remove line on domain for Y axis
            .call(g => g.select('.domain').remove())
            .selectAll('text')
            .attr('fill', '#909090');
          
          var myColor = d3.scaleLinear()
            .range([backgroundColor, colorBi[0]])
            .domain([0, maxValue]);
          svg
            .selectAll()
            .data(data, function(d) {return d.group+':'+d.name;})
            .enter()
            .append('rect')
            .attr('id', function(item, i){ return `${item.name}_${item.group}`;})
            .attr('x', function(d) { return x(d.group) })
            .attr('y', function(d) { return y(d.name) })
            .attr('width', x.bandwidth() )
            .attr('height', y.bandwidth() )
            .style('fill', function(d) { return myColor(d.value)} )
            .on('click', function(d) {
              var idParent = this.id;
                    drillDown(idParent);
            });

          //Add X axis label:
          addText(svg, 'end', 16, 0, (width / 2) + margin.top, height + margin.left, '#808080', '', axisY);
          
          //Y axis label:
          addText(svg, 'end', 16, -90, margin.top + (-height / 2), 0  -margin.bottom + 25, '#808080', '', axisX);
        }

        function setMultiBar() {
          var svg = svgMulti().append('g')
                .attr('transform', `translate(${margin.bottom}, ${margin.top})`);

          var withReduce = width - 100;
            var keys1 = Object.keys(dataTmp[0]);
          const subgroups = keys1.slice(1);

          // List of groups = species here = value of the first column called group -> I show them on the X axis
          const groups = dataTmp.map(d => d.name);

          // Add X axis
          const x = d3.scaleBand()
            .domain(groups)
            .range([height, 0])
            .padding([0.2]);
          var axis = axisMulti(svg, true, x, 0, 5, splitAxis);
          axis = axis
            //Remove line on domain for X axis
            .call(g => g.select('.domain').remove())
            //region set opacity for each tick item
            .call(g => g.selectAll('.tick line')
              .attr('opacity', 0.2))
          completeAxisMultiple(axis, -10, -25, -45);

            // Add Y axis
          const y = d3.scaleLinear()
            .domain([0, getMaxValue()])
            .range([0, withReduce]);

          axis = axisMulti(svg, false, y, height, 0, formatAxis);
          axis = axis
            //Remove line on domain for X axis
            .call(g => g.select('.domain').remove())
            //region set lines by each value for y axis
            .call(
              g => g.selectAll('.tick line')
              .clone()
              .attr('stroke-opacity', 0.1)
              .attr('y2', -height))
          completeAxisMultiple(axis, 10, 10, -45);

          // Another scale for subgroup position?
          const xSubgroup = d3.scaleBand()
            .domain(subgroups)
            .range([x.bandwidth(), 0])
            .padding([0.05]);//TODO CHANGE

            // color palette = one color per subgroup
          const color = d3.scaleOrdinal()
            .domain(subgroups)
            .range(colorPie);

            // Show the bars
          svg.append('g')
            .selectAll('g')
            // Enter in data = loop group per group
            .data(dataTmp)
            .join('g')
              .attr('transform', d => `translate(0, ${x(d.name)})`)
                    .attr('id', function(_,i){ return 'item_' + i;})
            .selectAll('rect')
            .data(function(d) { return subgroups.map(function(key) { return {key: key, value: d[key]}; }); })
            .join('rect')
              .attr('x', d => 0)
              .attr('y', d => xSubgroup(d.key))
              .attr('height', xSubgroup.bandwidth())
              .attr('width', d => y(d.value))
              .attr('fill', d => color(d.key))
              .on('click', function () {
                var idParent = this.parentNode.id
                var aData = idParent.split('_')
                if (aData.length > 0)
                {
                  var index = aData[1];
                  var mValue = aDrillData[indexData][index];
                  var value = `${mValue}_${index}`;
                  drillDown(value);
                }
              });
                    
            //Add X axis label:
          addText(svg, 'end', 16, 0, ((withReduce + margin.right + 10) / 2) + margin.top, height + margin.bottom - 25, '#808080', axisY, getAxisY(), function () {
            modalCategories(TypeManage.SELECTABLE, this.id);
          });

          //Y axis label:
          addText(svg, 'end', 16, -90, margin.top + (-height / 2), -margin.left - 20, '#808080', axisX, getAxisX(), function () {
            modalCategories(TypeManage.PLAIN, this.id);
          });
            
          var factorBack = margin.top;
            var aCategoryTmp = getMultiCategory();
          if (aCategoryTmp.length - indexIgnore.length >= 3)
          {
            addText(svg, 'start', 16, 0, withReduce + margin.right - 10, 0, '#808080', '', 'Category');
            for (var index = 0; index < aCategoryTmp.length; index++)
            {
              if (!indexIgnore.includes(index))
              {
                var item = aCategoryTmp[index];
                addText(svg, 'start', 12, 0, withReduce + margin.right + 10, factorBack, '#808080', `id_${index}`, item, function () {
                  var id = this.id;
                  adminMulti(id, subgroups);
                });
                addCircle(svg, withReduce + margin.right - 5, factorBack - 5, 5, colorPie[indexCircle(index)], `idcircle_${index}`,
                function () {
                  return `opacity: ${opacityMarked.includes(index) ? '0.5' : '1'}`;
                },
                function () {
                  var id = this.id;
                  adminMulti(id, subgroups);
                });
                factorBack += 20;
              }
            }
          }
        }

        function setMultiColumn() {
          var svg = svgMulti().append('g')
            .attr('transform', `translate(${margin.left}, ${margin.top})`);

            var withReduce = width - 100;
          var keys1 = Object.keys(dataTmp[0]);
          const subgroups = keys1.slice(1);

          // List of groups = species here = value of the first column called group -> I show them on the X axis
          const groups = dataTmp.map(d => d.name);

          // Add X axis
          const x = d3.scaleBand()
            .domain(groups)
            .range([0, withReduce])
            .padding([0.2]);
          var axis = axisMulti(svg, false, x, height, 5, splitAxis);
            axis = axis
            //Remove line on domain for X axis
            .call(g => g.select('.domain').remove())
            //region set opacity for each tick item
            .call(g => g.selectAll('.tick line')
              .attr('opacity', 0.2))
          completeAxisMultiple(axis, 10, 10, -45);

          // Add Y axis
          const y = d3.scaleLinear()
            .domain([0, getMaxValue()])
            .range([ height, 0 ]);
          axis = axisMulti(svg, true, y, 0, 0, formatAxis);
            axis = axis
            //region set lines by each value for y axis
            .call(
              g => g.selectAll('.tick line')
              .clone()
              .attr('stroke-opacity', 0.1)
              .attr('x2', withReduce))
              .call(g => g.select('.domain').remove())
            completeAxisMultiple(axis, 0, 0, 0);

          // Another scale for subgroup position?
          const xSubgroup = d3.scaleBand()
            .domain(subgroups)
            .range([0, x.bandwidth()])
            .padding([0.05]);

          // color palette = one color per subgroup
          const color = d3.scaleOrdinal()
            .domain(subgroups)
            .range(colorPie);

          // Show the bars
          svg.append('g')
            .selectAll('g')
            // Enter in data = loop group per group
            .data(dataTmp)
            .join('g')
              .attr('transform', d => `translate(${x(d.name)}, 0)`)
                    .attr('id', function(_,i){ return 'item_' + i;})
            .selectAll('rect')
            .data(function(d) { return subgroups.map(function(key) { return {key: key, value: d[key]}; }); })
            .join('rect')
              .attr('x', d => xSubgroup(d.key))
              .attr('y', d => y(d.value))
              .attr('width', xSubgroup.bandwidth())
              .attr('height', d => height - y(d.value))
              .attr('fill', d => color(d.key))
              .on('click', function () {
                var idParent = this.parentNode.id;
                var aData = idParent.split('_');
                if (aData.length > 0)
                {
                  var index = aData[1];
                  var mValue = aDrillData[indexData][index];
                  var value = `${mValue}_${index}`;
                  drillDown(value);
                }
              });
                    
            //Add X axis label:
          addText(svg, 'end', 16, 0, ((withReduce + margin.right + 10) / 2) + margin.top, height + margin.bottom - 25, '#808080', axisX, getAxisX(), function () {
            modalCategories(TypeManage.PLAIN, this.id);
            });

            //Y axis label:
          addText(svg, 'end', 16, -90, margin.top + (-height / 2), -margin.left + 20, '#808080', axisY, getAxisY(), function () {
            modalCategories(TypeManage.SELECTABLE, this.id);
            });
            
          var factorBack = margin.top;
            var aCategoryTmp = getMultiCategory();
          if (aCategoryTmp.length - indexIgnore.length >= 3)
          {
            addText(svg, 'start', 16, 0, withReduce + margin.right - 10, 0, '#808080', '', 'Category');
            for (var index = 0; index < aCategoryTmp.length; index++)
            {
              if (!indexIgnore.includes(index))
              {
                var item = aCategoryTmp[index];
                addText(svg, 'start', 12, 0, withReduce + margin.right + 10, factorBack, '#808080', `id_${index}`, item, function () {
                  var id = this.id;
                  adminMulti(id, subgroups);
                });
                addCircle(svg, withReduce + margin.right - 5, factorBack - 5, 5, colorPie[indexCircle(index)], `idcircle_${index}`,
                function () {
                  return `opacity: ${opacityMarked.includes(index) ? '0.5' : '1'}`;
                },
                function () {
                  var id = this.id;
                  adminMulti(id, subgroups);
                });
                factorBack += 20;
              }
            }
          }
        }

        function setMultiLine() {
          var svg = svgMulti().append('g')
            .attr('transform', `translate(${margin.left}, ${margin.top})`);

          var withReduce = width - 100;
            var keys1 = Object.keys(dataTmp[0]);
          const subgroups = keys1.slice(1);
          
          // Reformat the data: we need an array of arrays of {x, y} tuples
          var dataReady = subgroups.map( function(grpName) { // .map allows to do something for each element of the list
            return {
              name: grpName,
              values: dataTmp.map(function(d) {
                return {subname: d.name, value: +d[grpName]};
              })
            };
          });

          var myColor = d3.scaleOrdinal()
            .domain(subgroups)
            .range(colorPie);

            // Add X axis --> it is a date format
          var x = d3.scaleBand()
            .domain(dataTmp.map(function(d) { return d.name; }))
            .range([0, withReduce])
            .padding(1);

          var axis = axisMulti(svg, false, x, height, 10, splitAxis);
          axis = axis
          //Remove line on domain for X axis
          .call(g => g.select('.domain').remove())
          //region set opacity for each tick item
          .call(
            g => g.selectAll('.tick line')
            .attr('opacity', 0.2))
          completeAxisMultiple(axis, 15, 10, -45);

          // Add Y axis
          var y = d3.scaleLinear()
            .domain([0, getMaxValue()])//maxValue is here
            .range([height, 0]);
          var axis = axisMulti(svg, true, y, 0, 0, formatAxis);
            axis = axis
            .call(
              g => g.selectAll('.tick line')
              .clone()
              .attr('stroke-opacity', 0.1)
              .attr('x2', withReduce)
            )
            //Remove line on domain for Y axis
            .call(g => g.select('.domain').remove())
          completeAxisMultiple(axis, 0, 0, 0);

            // Add the lines
          var line = d3.line()
            .x(function(d) { return x(d.subname) })
            .y(function(d) { return y(d.value) });
          svg.selectAll("myLines")
            .data(dataReady)
            .enter()
            .append("path")
              .attr("d", function(d){ return line(d.values) } )
              .attr("stroke", function(d){ return myColor(d.name) })
              .style("stroke-width", 1)
              .style("fill", "none");
                    
            // Add the points
          svg
            // First we need to enter in a group
            .selectAll()
            .data(dataReady)
            .enter()
              .append('g')
              .style("fill", function(d){ return myColor(d.name) })
            // Second we need to enter in the 'values' part of this group
            .selectAll()
            .data(function(d){ return d.values })
            .enter()
            .append("circle")
              .attr('id', function(_, i){ return 'item_' + i;})
              .attr("cx", function(d) { return x(d.subname) } )
              .attr("cy", function(d) { return y(d.value) } )
              .attr("r", 5)
              .attr("stroke", "white")
                .on('click', function () {
                  var idParent = this.id;
                  var aData = idParent.split('_');
                  if (aData.length > 0)
                  {
                  var index = aData[1];
                  var mValue = aDrillData[indexData][index];
                  var value = `${mValue}_${index}`;
                  drillDown(value);
                  }
                });
                
            //Add X axis label:
          addText(svg, 'end', 16, 0, ((withReduce + margin.right + 10) / 2) + margin.top, height + margin.bottom - 25, '#808080', axisX, getAxisX(), function () {
            modalCategories(TypeManage.PLAIN, this.id);
          });

          //Y axis label:
          addText(svg, 'end', 16, -90, margin.top + (-height / 2), -margin.left + 20, '#808080', axisY, getAxisY(), function () {
            modalCategories(TypeManage.SELECTABLE, this.id);
          });
            
          var factorBack = margin.top;
            var aCategoryTmp = getMultiCategory();
          if (aCategoryTmp.length - indexIgnore.length >= 3)
          {
            addText(svg, 'start', 16, 0, withReduce + margin.right - 10, 0, '#808080', '', 'Category');
            for (var index = 0; index < aCategoryTmp.length; index++)
            {
              if (!indexIgnore.includes(index))
              {
                var item = aCategoryTmp[index];
                addText(svg, 'start', 12, 0, withReduce + margin.right + 10, factorBack, '#808080', `id_${index}`, item, function () {
                  var id = this.id;
                  adminMulti(id, subgroups);
                });
                addCircle(svg, withReduce + margin.right - 5, factorBack - 5, 5, colorPie[indexCircle(index)], `idcircle_${index}`,
                function () {
                  return `opacity: ${opacityMarked.includes(index) ? '0.5' : '1'}`;
                },
                function () {
                  var id = this.id;
                  adminMulti(id, subgroups);
                });
                factorBack += 20;
              }
            }
          }
        }

        function setBar() {
            var svg = d3.select('body').append('svg')
                .attr('width', width + margin.bottom + margin.right)
                .attr('height', height + margin.top + margin.left)
                .append('g')
                .attr('transform', 'translate(' + margin.bottom + ',' + margin.top + ')');

            var x = d3.scaleBand()
                .range([height, 0])
                .padding(0.1);
            var y = d3.scaleLinear()
                .range([0, width]);

            x.domain(data.map(function(d) { return d.name; }));
            y.domain([getMinDomain(), d3.max(data, function(d) { return d.value; })]);

            svg.selectAll()
                .data(data)
                .enter().append('rect')
                .style('fill', function(d) {
                    return scaleColorBi(d.value);
                })
                .attr('x', function(d) { return x(d.value); })
                .attr('width', function(d) { return y(d.value); })
                .attr('y', function(d) { return x(d.name); })
                .attr('height', x.bandwidth())
                .on('click', function(_, d) {
                    var index = data.indexOf(d);
              var value = drillX[index];
              drillDown(value);
                });

            svg.append('g')
                .attr('transform', 'translate(0,' + height + ')')
                .call(
                    d3.axisBottom(y)
                    .tickSize(0)
                    //format data for each number on Y axis
                    .tickFormat(x => `${fformat(x)}`))
                .call(
                    g => g.selectAll('.tick line')
                    .clone()
                    .attr('stroke-opacity', 0.1)
                    .attr('y2', -height))
                //Remove line on domain for X axis
                .call(g => g.select('.domain').remove())
                .selectAll('text')
                .attr('transform', 'translate(10,10)rotate(-45)')
                .attr('fill', '#909090');

            svg.append('g')
                .call(
                    d3.axisLeft(x)
              .tickFormat(x =>`${getFirst10(x)}`))
                //region set opacity for each tick item
                .call(g => g.selectAll('.tick line')
                .attr('opacity', 0.2))
                //endregion
                //Remove line on domain for Y axis
                .call(g => g.select('.domain').remove())
                .selectAll('text')
                .attr('transform', 'translate(-10,-25)rotate(-45)')
                .attr('fill', '#909090');
            
              //Add X axis label:
              addText(svg, 'end', 16, 0, (width / 2) + margin.top, height + margin.left - 10, '#808080', '', axisY);
            
              //Y axis label:
              addText(svg, 'end', 16, -90, margin.top + (-height / 2), -margin.bottom + 20, '#808080', '', axisX);
            }

        function setColumn() {
          var svg = d3.select('body').append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
            .append('g')
            .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');

          var x = d3.scaleBand()
            .range([0, width])
            .padding(0.1);
          var y = d3.scaleLinear()
            .range([height, 0]);

          x.domain(data.map(function(d) { return d.name; }));
          y.domain([getMinDomain(), d3.max(data, function(d) { return d.value; })]);

          svg.selectAll()
            .data(data)
            .enter().append('rect')
            .style('fill', function(d) {
              return scaleColorBi(d.value);
            })
            .attr('x', function(d) { return x(d.name); })
            .attr('width', x.bandwidth())
            .attr('y', function(d) { return y(d.value); })
            .attr('height', function(d) { return height - y(d.value); })
            .on('click', function(_, d) {
              var index = data.indexOf(d);
              var value = drillX[index];
              drillDown(value);
            });

        //the X DATA for axis bar
        svg.append('g')
          .attr('transform', 'translate(0,' + height + ')')
          .call(
            d3.axisBottom(x)
            .tickFormat(x =>`${getFirst10(x)}`))
          //Remove line on domain for X axis
          .call(g => g.select('.domain').remove())
          //region set opacity for each tick item
          .call(g => g.selectAll('.tick line')
            .attr('opacity', 0.2))
          //endregion
          .selectAll('text')
          //rotate text
          .attr('transform', 'translate(10,10)rotate(-45)')
          //Set color each item on X axis
          .attr('fill', '#909090')
          .style('text-anchor', 'end');

            //the Y DATA for axis bar
            svg.append('g')
              //Format numbers on axis
              .call(
                d3.axisLeft(y)
                //remove short line for Y axis
                .tickSize(0)
                //format data for each number on Y axis
                .tickFormat(x => `${fformat(x)}`))
              //region set lines by each value for y axis
              .call(
                g => g.selectAll('.tick line')
                .clone()
                .attr('stroke-opacity', 0.1)
                .attr('x2', width))
              //endregion
              //Remove line on domain for Y axis
              .call(g => g.select('.domain').remove())
              .selectAll('text')
                .attr('transform', 'translate(0,0)rotate(0)')
              .attr('fill', '#909090');

            //Add X axis label:
          addText(svg, 'end', 16, 0, (width / 2) + margin.top, height + margin.bottom - 10, '#808080', '', axisX);
            
          //Y axis label:
          addText(svg, 'end', 16, -90, margin.top + (-height / 2), -margin.left + 20, '#808080', '', axisY);
        }

        function setLine() {
          var svg = d3.select('body').append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
            .append('g')
            .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');

            // Initialise a X axis:
            var xScaleBand = d3.scaleBand().range([0, width]).padding(1);

            // Initialize an Y axis
            var yScale = d3.scaleLinear().range([height, 0]);

            // create the X axis
            xScaleBand.domain(data.map(function(d) { return d.name; }));
            // create the Y axis
            yScale.domain([getMinDomain(), d3.max(data, function(d) { return d.value }) ]);

            svg.append("g")
              .attr("transform", "translate(0," + height + ")")
              .call(
                d3.axisBottom(xScaleBand)
                .tickFormat(x =>`${getFirst10(x)}`))
              //Remove line on domain for X axis
              .call(g => g.select('.domain').remove())
                    //region set opacity for each tick item
                    .call(g => g.selectAll('.tick line')
              .attr('opacity', 0.2))
              .selectAll('text')
              //rotate text
              .attr('transform', 'translate(10,10)rotate(-45)')
              //Set color each item on X axis
              .attr('fill', '#909090')
              .style('text-anchor', 'end');

            svg.append("g")
              .call(
                d3.axisLeft(yScale)
                .tickSize(0)
                .tickFormat(x => `${fformat(x)}`))
              //region set lines by each value for y axis
              .call(
                g => g.selectAll('.tick line')
                .clone()
                .attr('stroke-opacity', 0.1)
                .attr('x2', width)
              )
              //Remove line on domain for Y axis
              .call(g => g.select('.domain').remove())
              .selectAll('text')
              .attr('fill', '#909090');

            // Updata the line
            svg.selectAll()
              .data([data], function(d){ return d.value })
              .enter()
              .append("path")
              .attr("d", d3.line()
                .x(function(d) { return xScaleBand(d.name); })
                .y(function(d) { return yScale(d.value); })
                //.curve(d3.curveMonotoneX)
              )
              .attr("stroke", colorBi)
              .attr("stroke-width", 1.5)
              .attr("fill", "none");

            svg.selectAll()
              .data(data)
              .enter()
              .append("circle")
              .attr("cx", function(d) { return xScaleBand(d.name) })
              .attr("cy", function(d) { return yScale(d.value) })
              .attr("r", 5)
              .attr("fill", colorBi)
              .on('click', function(_, d) {
                  var index = data.indexOf(d);
                  var value = drillX[index];
                  drillDown(value);
                });
                    
                //Add X axis label:
            addText(svg, 'end', 16, 0, (width / 2) + margin.top, height + margin.bottom - 10, '#808080', '', axisX);
            //Y axis label:
            addText(svg, 'end', 16, -90, margin.top + (-height / 2), -margin.left + 20, '#808080', '', axisY);
            }
            
        function setDonut() {
          var arc = d3.arc()
            .outerRadius(radius)
                .innerRadius(radius * 0.5);

            var pie = d3.pie()
                .sort(null)
                .value(function(d) {
                    return d.value;
                });
                
            var maxWidth = width + margin.left + margin.right;
          var maxHeight = height + margin.top + margin.bottom;

            var svg = d3.select('body').append('svg')
            .attr('width', maxWidth)
            .attr('height', maxHeight)
                .append('g')
                .attr('transform', 'translate(' + maxWidth * 0.65 + ',' + maxHeight * 0.65 + ')');

            var g = svg.selectAll('.arc')
                .data(pie(dataTmp))
                .enter().append('g');

            g.append('path')
                .attr('d', arc)
                .style('fill', function(_, i) {
                    return colorPie[i];
                })
                .on('click', function(_, i) {
                    var index = i.index;
                    var value = drillX[index];
                    drillDown(value);
                });
                
            var factorBack = -(maxHeight / 2) - 30;
                
          for (const index in dataFormatted) {
            var item = dataFormatted[index];
            addText(svg, 'start', 12, 0, -(maxWidth / 2) - 20, factorBack, '#808080', `id_${index}`, item.name + ': ' + item.value, function () {
              var id = this.id;
              adminOpacity(id);
            });
                
            addCircle(svg, -(maxWidth / 2) - 30, factorBack - 5, 5, colorPie[index], `idcircle_${index}`,
              function () {
                return `opacity: ${opacityMarked.includes(index) ? '0.5' : '1'}`;
              },
              function () {
                var id = this.id;
                adminOpacity(id);
            });
            factorBack += 20;
          }
        }


        $('#idTableBasic tfoot th').each(function () {
            var indexInput = $(this).index();
            var title = $(this).text();
            var idInput = title.replace(' ', '_').replace('(', '_').replace(')', '_').replace('&', '_') + '_Basic';
            $(this).html(
                '<input id=' + idInput +
                ' type="text" placeholder="filter column..."/>');

            $("#" + idInput).on('input', function () {
                var filter = $(this).val().toUpperCase();
                var table = document.getElementById("idTableBasic");
                var tr = table.getElementsByTagName("tr");

                for (index = 0; index < tr.length; index++) {
                    td = tr[index].getElementsByTagName("td")[indexInput];
                    if (td) {
                        txtValue = td.textContent || td.innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            tr[index].style.display = "";
                        } else {
                            tr[index].style.display = "none";
                        }
                    }
                }
            });
        });

        $('#idTableDataPivot tfoot th').each(function () {
            var indexInput = $(this).index();
            var title = $(this).text();
            var idInput = title.replace(' ', '_').replace('(', '_').replace(')', '_').replace('&', '_') + '_DataPivot';
            $(this).html(
                '<input id=' + idInput +
                ' type="text" placeholder="Search on ' + title + '"/>');

            $("#" + idInput).on('input', function () {
                var filter = $(this).val().toUpperCase();
                var table = document.getElementById("idTableDataPivot");
                var tr = table.getElementsByTagName("tr");

                for (index = 0; index < tr.length; index++) {
                    td = tr[index].getElementsByTagName("td")[indexInput];
                    if (td) {
                        txtValue = td.textContent || td.innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            tr[index].style.display = "";
                        } else {
                            tr[index].style.display = "none";
                        }
                    }
                }
            });
        });

        function showFilter() {
            var display = $('tfoot').is(':visible') ? 'none' : 'table-header-group';
          $('tfoot').css({'display': display});
        }

        function adminMulti(id, subgroups) {
          var words = id.split('_');
          var index = parseInt(words[1]);
          var subGroup = subgroups[index];
          var exist = opacityMarked.includes(index);
          if (exist) {
            var tmp = -1;
            for (let _index = 0; _index < opacityMarked.length; _index++) {
              if (index == opacityMarked[_index])
              {
                tmp = _index;
                break;
              }
            }
            opacityMarked.splice(tmp, 1);
          }
          else opacityMarked.push(index);

          var aTmp = getDataMulti();
            for (position in dataTmp) {
            var element = aTmp[position];
                var itEdit = dataTmp[position];
          
                itEdit[subGroup] = exist ? element[subGroup] : 0;
          }
          isAgain = true;
          updateData(typeChart, true);
        }

        function callAdminStacked(aIndex, subgroups) {
            indexIgnore = aIndex;
          if (aIndex.length > 0) {
            for (let index = 0; index < aIndex.length; index++) {
              const element = aIndex[index];
              controlStacked(element, subgroups);
            }
          } else {
            for (let index1 = 0; index1 < opacityMarked.length; index1++) {
              const element = opacityMarked[index1];
              controlStacked(element, subgroups);
            }
          }
          isAgain = true;
          updateData(typeChart, true);
        }

        function adminStacked(id, subgroups) {
          var words = id.split('_');
          controlStacked(words[1], subgroups);
          isAgain = true;
          updateData(typeChart, true);
        }

        function controlStacked(id, subgroups) {
          var index = parseInt(id);
          var exist = opacityMarked.includes(index);
          if (exist) {
            var tmp = -1;
            for (let _index = 0; _index < opacityMarked.length; _index++) {
              if (index == opacityMarked[_index])
              {
                tmp = _index;
                break;
              }
            }
            opacityMarked.splice(tmp, 1);
          }
          else {
            opacityMarked.push(index);
          }
          //#endregion
          //#region set value original or zero
          var sub = getCategoriesStack()[index];
          for (var index1 = 0; index1 < aStacked.length; index1++) {
            var element = aStackedTmp[index1];
            var edit = aStacked[index1];
            edit[sub] = exist ? element[sub] : 0;
          }
          //#endregion
            updateSelected(`${index}_${exist}`);
        }

        function adminOpacity(id) {
          var words = id.split('_');
          var index = words[1];

          var exist = opacityMarked.includes(index);
          if (exist)
          {
            var tmp = -1;
            for (let _index = 0; _index < opacityMarked.length; _index++) {
              if (index == opacityMarked[_index])
              {
                tmp = _index;
                break;
              }
            }
            var item = getDataOrMulti()[index];
            dataTmp[index].value = item.value;
            opacityMarked.splice(tmp, 1);
          }
          else
          {
            dataTmp[index].value = 0;
            opacityMarked.push(index);
          }
          isAgain = true;
          updateData(typeChart, true);
        }

        function getMaxValue()
        {
            if (aMaxData.length !== 0)
          {
            var aTotalIndices = [];
            var key = `${indexData}_${isCurrency ? 1 : 2}`;
            var aTmp = aMaxData.length !== 0 ? aMaxData[key] : [];
            var aTmp = aMaxData[key];
            for (index = 0; index < aTmp.length; index++)
            {
              if (indexIgnore.includes(index)) continue;
              var value = aTmp[index];
              aTotalIndices.push(value);
            }
            var maxMath = Math.max.apply(null, aTotalIndices);
            return maxMath !== 0 ? maxMath : 1;
          }
          else
          {
            return maxValue;
          }
        }

        function getMinDomain() {
          var minDomain = 0;
          if (minValue2 === -1) {
            var values = [];
            for (let index = 0; index < data.length; index++) {
              const item = data[index];
              values.push(item.value);
            }
            var minimum = Math.min.apply(Math, values);
            var residue = minimum % 10000;
            minimum =  minimum - residue;
            if (minimum > 0) {
              minDomain = minimum;
            }
          }
          return minDomain;
        }

        function getMinValue()
        {
          return isCurrency ? minValue : minValue2;
        }

        function getDataOrMulti()
        {
            return data.length !== 0 ? data : getDataMulti();
        }

        function getDataMulti()
        {
            if (aAllData.length !== 0)
            {
            var key = `${indexData}_${isCurrency ? 1 : 2}`;
            return aAllData[key];
            }
            else return [];
        }

        function getStackedMax()
        {
          var sumTop = 0;
          var aStacked = getStackedData();
          var aCat = getCategoriesStack();
          for (var index1 = 0; index1 < aStacked.length; index1++)
          {
            var sum = 0;
            const iStacked = aStacked[index1];
            for (var index2 = 0; index2 < aCat.length; index2++)
            {
              const iCat = aCat[index2];
              sum += iStacked[iCat];
            }
            if (sumTop < sum) sumTop = sum;
          }
          return sumTop;
        }

        function setOtherStacked()
        {
          isCurrency = !isCurrency;
          var tmp = axisX;
          axisX = axisY;
          axisY = tmp;
          isAgain = true;
          updateData(typeChart, true);
        }

        function getCategoriesStack()
        {
          return isCurrency ? aCatHeatY : aCatHeatX;
        }

        function getStackedData()
        {
          return isCurrency ? aStacked : aStacked2;
        }

        function getMultiCategory()
        {
          return isCurrency ? aCategory : aCategory2;
        }

        function indexCircle(index)
        {
          return index % colorPie.length;
        }

        $('td').click(function() {
          var $this = $(this);
          var row = $this.closest('tr').index();
          var column = $this.closest('td').index();
          var firstColumn = $this.closest('tr');
          var finalText = firstColumn[0].firstChild.innerText;
          var strDate = firstColumn[0].children[1].innerText;
          var index = aCategoryX.indexOf(finalText);
            if (nColumns == 3) {
            switch (typeChart) {
              case TypeEnum.TABLE:
                var secondCell = firstColumn[0].children[1].innerText;
                finalText += `_${secondCell}`;
                break;
              case TypeEnum.PIVOT:
                if (column == 0) return;
                var secondCell = aCategoryX[column - 1];
                finalText = `${secondCell}_${finalText}`;
                break;
              default:
                break;
            }
            }
          else
            finalText = drillX[index];
          drillDown(finalText);
        });
        var scaleColorBi = d3.scaleOrdinal().range(colorBi);

        //region locale settings
        var locale = d3.formatLocale({
          "decimal": ",",//","
          "thousands": ",",//" ",
          "grouping": [3],
          "currency": ["$", ""]//["€", ""] first if prefix, second is suffix
        });
        var fformat = locale.format("$,");
        //endregion

        $(window).resize(function() {
          updateData(typeChart, true);
        });
        updateData(typeChart);
        </script>
        </body>
        </html>
    """
}