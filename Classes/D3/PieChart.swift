//
//  PieChart.swift
//  chata
//
//  Created by Vicente Rincon on 04/10/20.
//

import Foundation

func getPieChart() {
    let wvStr = """
        <!DOCTYPE html>
        <meta charset="utf-8">


        <!-- Load d3.js -->
        <script src="https://d3js.org/d3.v4.js"></script>

        <!-- Create a div where the graph will take place -->
        <div id="my_dataviz"></div>

        <script>

        // set the dimensions and margins of the graph
        var width = 750
            height = 450
            margin = 40

        // The radius of the pieplot is half the width or half the height (smallest one). I subtract a bit of margin.
        var radius = Math.min(width, height) / 2 - margin

        // append the svg object to the div called 'my_dataviz'
        var svg = d3.select("#my_dataviz")
          .append("svg")
            .attr("width", width)
            .attr("height", height)
          .append("g")
            .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
        // Create dummy data
        var data = {a: 3, b: 20, c:30, d:8, e:12}

        // set the color scale
        var color = d3.scaleOrdinal()
          .domain(data)
          .range(["#000", "#8a89a6", "#7b6888", "#6b486b", "#a05d56"])
          console.log(color.range())
          var starCx = 50;
          var arrData = Object.keys(data )
        for (var i = 0; i < color.range().length; i++) {
            var fColor = color.range()[i]
            var fLabel = arrData[i]
            console.log(color.domain())
          svg.append("circle").attr("cx",200).attr("cy",starCx).attr("r", 6).style("fill", fColor)
          svg.append("text").attr("x", 220).attr("y", starCx).text(fLabel).style("font-size", "15px").attr("alignment-baseline","middle")
          starCx += 30
        }

        // Compute the position of each group on the pie:
        var pie = d3.pie()
          .value(function(d) {return d.value; })
        var data_ready = pie(d3.entries(data))

        // Build the pie chart: Basically, each part of the pie is a path that we build using the arc function.
        svg
          .selectAll('whatever')
          .data(data_ready)
          .enter()
          .append('path')
          .attr('d', d3.arc()
            .innerRadius(100)         // This is the size of the donut hole
            .outerRadius(radius)
          )
          .attr('fill', function(d){ return(color(d.data.key)) })
          .style("opacity", 0.7)
          .on('click', function(d) {
              console.log(d)
                svg
                .selectAll('path.slice')
                .each(function(data_ready) {
                    data_ready._expanded = false
                })
                .transition()
                .duration(500)
                .attr('transform', function(d){
                    return 'translate(0,0)';
                });

                select(this)
                .transition()
                .duration(500)
                .attr('transform', function(d) {
                    if (!d._expanded) {
                        d._expanded = true
                        const a =
                        d.startAngle + (d.endAngle - d.startAngle) / 2 - Math.PI / 2
                        const x = Math.cos(a) * 10
                        const y = Math.sin(a) * 10
                        return 'translate(' + x + ',' + y + ')'
                    } else {
                        d._expanded = false
                        return 'translate(0,0)'
                    }
                })
            })


        </script>
    """
}
