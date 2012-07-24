var TODAY           = (new Date()).getTime(),
    THIRTY_DAYS_AGO = (new Date()).getTime() - 1000*60*60*24*30, // today - 30 days
    RED       = "rgba(255, 0, 0, 1)",
    LIGHT_RED = "rgba(255, 0, 0, 0.5)",
    LINES_CHART_OPTS = {
      series: {
        color: RED,
        lines: { show: true, fill: true, fillColor: LIGHT_RED }
      },
      selection: { mode: "x" },
      xaxis: { mode: "time", ticks: 14 },
      yaxis: { ticks: 14, tickFormatter: function(n) { return n.toFixed(0) } }
    },
    LINES_CHART_WITH_MULTIPLE_AXIS_OPTS = {
      xaxes: [ { mode: "time", ticks: 14 } ],
      yaxes: [
        { ticks: 14, tickFormatter: function(n) { return n.toFixed(0) } },
        { ticks: 14, tickFormatter: function(n) { return n.toFixed(0) }, position: 'right' }
      ],
      legend: false
    },
    LINES_OVERVIEW_CHART_OPTS = $.extend(true, {}, LINES_CHART_OPTS, {
      series: {
        lines: { lineWidth: 1 },
        shadowSize: 0
      },
      xaxis: { mode: "time", ticks: [], min: null, max: null },
      yaxis: { ticks: [], autoscaleMargin: 0.1, tickSize: 1 }
    }),
    BARS_CHART_OPTS = {
      series: {
        color: RED,
        bars: { show: true }
      }
    },
    HOURS_BARS_CHART_OPTS = $.extend(true, {}, BARS_CHART_OPTS, {
      series: {
        bars: { barWidth: 60*60*1000, fillColor: LIGHT_RED }
      },
      xaxis: { mode: "time", tickSize: [1, "hour"] },
      yaxis: { ticks: 14, tickFormatter: function(n) { return n.toFixed(0) } }
    });


function lines_chart_with_overview(collection, chart_id, chart_overview_id) {
  var collection_chart = lines_chart(collection, chart_id, {xaxis: { min: THIRTY_DAYS_AGO, max: TODAY }});
  var collection_chart_overview = $.plot($(chart_overview_id), [collection], LINES_OVERVIEW_CHART_OPTS);

  collection_chart_overview.setSelection({xaxis: {from: THIRTY_DAYS_AGO, to: TODAY}}, true);
  
  // connect charts
  $(chart_id).bind("plotselected", function (event, ranges) {
    // do the zooming
    collection_chart = $.plot($(chart_id), [collection], $.extend(true, {}, LINES_CHART_OPTS, {
      xaxis: { min: ranges.xaxis.from, max: ranges.xaxis.to }
    }));

    // don't fire event on the overview to prevent eternal loop
    collection_chart_overview.setSelection(ranges, true);
  });
  
  $(chart_overview_id).bind("plotselected", function (event, ranges) {
    collection_chart.setSelection(ranges);
  });

  return [collection_chart, collection_chart_overview];
}

function lines_chart(collection, chart_id, opts) {
  return $.plot($(chart_id), [collection], $.extend(true, {}, LINES_CHART_OPTS, opts));
}

function lines_chart_with_multiple_axis(collections, chart_id, opts) {
  return $.plot($(chart_id), collections, $.extend(true, {}, LINES_CHART_WITH_MULTIPLE_AXIS_OPTS, opts));
}

function bars_chart(collection, chart_id, opts) {
  return $.plot($(chart_id), [collection], $.extend(true, {}, BARS_CHART_OPTS, opts));
}

function hours_bars_chart(collection, chart_id) {
  return bars_chart(collection, chart_id, HOURS_BARS_CHART_OPTS);
}