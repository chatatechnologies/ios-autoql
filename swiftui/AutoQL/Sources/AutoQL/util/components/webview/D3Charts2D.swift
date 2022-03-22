//
//  File.swift
//  
//
//  Created by Vicente Rincon on 21/03/22.
//

import Foundation
class D3Charts2D{
    static let bar = """
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
    """
    static let column = """
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
    """
    static let line = """
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
    """
    static let donut = """
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
    """
    
}
