//
//  File.swift
//  
//
//  Created by Vicente Rincon on 21/03/22.
//

import Foundation
class D3Static{
    static let functionsD3 = """
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
                          \(switchCaseD3)
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
    """
    static let switchCaseD3 = """
                      switch (tmpChart) {
                        case TypeEnum.TABLE:
                        case TypeEnum.PIVOT:
                          $("svg").hide(0);
                          var aID = tmpChart == TypeEnum.TABLE ? ["table", "idTableDataPivot"] : ["idTableDataPivot", "table"];
                          $(`#${aID[0]}`).show(0);
                          $(`#${aID[1]}`).hide(0);
                          break;
                        default:
                          $("#table").hide(0);
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
    """
    static let typeD3 = """
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
    """
    static let forD3 = """
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
    """
    static let initialConfigD3 = """
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
    """
    static let footerD3 = """
                    $('#table tfoot th').each(function () {
                        var indexInput = $(this).index();
                        var title = $(this).text();
                        var idInput = title.replace(' ', '_').replace('(', '_').replace(')', '_').replace('&', '_') + '_Basic';
                        $(this).html(
                            '<input id=' + idInput +
                            ' type="text" placeholder="filter column..."/>');

                        $("#" + idInput).on('input', function () {
                            var filter = $(this).val().toUpperCase();
                            var table = document.getElementById("table");
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
