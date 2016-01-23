'use strict'

let _ = require('lodash')
let d3 = require('d3')
let doc = require('jsdom').jsdom()
let Svgo = require('svgo')
let svgo = new Svgo()

/* Process data for better results */
function processData (data) {
  // Make sure there is at least 56 days of data
  if (data.length < 56) data = _.map(new Array(56 - data.length), () => 0).concat(data)

  return _(data)
    .takeRight(364) // Take latest 6 months of data (preferably, choose a multiple of 7)
    .reverse() // Reverse to make sure possible chunk with <7 elements is at the start
    .chunk(7).map((a) => _.sum(a)) // Group daily data per week
    .reverse()
    .value()
}

/* Based on http://bl.ocks.org/benjchristensen/1133472 */
function sparkline (data) {
  let container = doc.createElement('div')

  // Create an SVG element inside the div
  let graph = d3.select(container)
    .append('svg:svg')
    .attr('xmlns', 'http://www.w3.org/2000/svg')
    .attr('viewBox', '0 0 100 100')
    .attr('preserveAspectRatio', 'none')

  // To make the `fill` look always right
  data.unshift(0)
  data.push(0)

  let totalValues = data.length - 2
  let yMax = Math.max.apply(null, data)

  // To prevent new packages from looking like they have lots of downloads,
  // set a minimum of 300
  yMax = Math.max(yMax, 300)

  // X scale to fit values within 0 to 500 pixels
  let x = d3.scale.linear().domain([0, totalValues - 1]).range([0, 100])
  // Y scale to fit values within 0 to 100 pixels
  let y = d3.scale.linear().domain([0, yMax]).range([0, 100])

  // Create a line object that represents the SVN line we're creating
  let line = d3.svg.line()
    // Rounded edges
    .interpolate('cardinal')
    // Assign the X function to plot our line as we wish
    .x(function (d, i) {
      // The X coordinate is the index in the array
      let pos = i - 1
      // The 1st point was added by us, in order to have `fill`, so display it
      // right below the real first value
      if (i === -1) pos = 0
      // Same thing for last one
      if (i === data.length - 1) pos = i - 2
      // Round to make the SVG output smaller
      return x(pos)
    })
    .y(function (d) {
      return y(yMax - d)
    })

  graph.append('svg:path')
    // Display the line by appending an svg:path element with the data line we created above
    .attr('d', line(data))
    // Add styles
    .attr('fill', '#f7f7f7')

  return graph.node().outerHTML
}

function minify (svg, callback) {
  svgo.optimize(svg, function (optimizedSvg) {
    callback(optimizedSvg.data)
  })
}

module.exports = sparkline

// If being executed from the command-line
if (!module.parent) {
  let fs = require('fs')

  let filename = process.argv[2]
  if (filename) {
    let data = JSON.parse(fs.readFileSync(filename))
    let svg = sparkline(processData(data))

    minify(svg, function (optimizedSvg) {
      process.stdout.write(optimizedSvg)
    })
  }
}

/*
 * TODO Move this to a proper JavaScript unit test suite.
 * Run with: `TEST=1 node scripts/sparkline.js`
 */
if (process.env.TEST) {
  let expect = require('expect')

  // Given an empty array, it will return 4 weeks of 0 data
  let input = []
  expect(processData(input)).toEqual([0, 0, 0, 0, 0, 0, 0, 0])

  // It adds leading zeros if there isn't enough data
  input = '111111122222223333333'.split('')
  expect(processData(input)).toEqual([0, 0, 0, 0, 0, 7, 14, 21])

  // Given 10 weeks of daily data, returns 10 sums
  input = _.map(new Array(56), () => 1).concat('22222223333333'.split(''))
  expect(processData(input)).toEqual([7, 7, 7, 7, 7, 7, 7, 7, 14, 21])

  // It keeps at most one year of data
  input = _.map(new Array(400), () => 1)
  expect(processData(input).length).toEqual(52)

  console.log('Tests completed successfully.')
}
