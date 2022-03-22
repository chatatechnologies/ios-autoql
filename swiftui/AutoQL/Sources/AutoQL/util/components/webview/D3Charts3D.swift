//
//  File.swift
//  
//
//  Created by Vicente Rincon on 21/03/22.
//

import Foundation
class D3Charts3D{
    static let stackedBar = """
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
    """
    static let stackedColumn = """
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
    """
    static let bubble = """
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
    """
    static let heatMap = """
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
    """
    static let multiBar = """
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
    """
    static let multiColumn = """
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
    """
    static let multiLine = """
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
    """
}
