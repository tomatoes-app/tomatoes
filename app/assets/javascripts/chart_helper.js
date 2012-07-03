var red = "rgba(255, 0, 0, 1)",
    light_red = "rgba(255, 0, 0, 0.5)",
    lines_chart_opts = {
      series: {
        color: red,
        lines: { show: true, fill: true, fillColor: light_red }
      },
      selection: { mode: "x" },
      xaxis: { mode: "time", ticks: 14, min: THIRTY_DAYS_AGO, max: TODAY },
      yaxis: { ticks: 14, tickFormatter: function(n) { return n.toFixed(0) } }
    },
    lines_overview_chart_opts = {
      series: {
        color: red,
        lines: { show: true, fill: true, lineWidth: 1, fillColor: light_red },
        shadowSize: 0
      },
      selection: { mode: "x" },
      xaxis: { mode: "time", ticks: [] },
      yaxis: { ticks: [], autoscaleMargin: 0.1, tickSize: 1 }
    },
    bars_chart_opts = {
      series: {
        color: red,
        bars: { show: true, barWidth: 60*60*1000, fillColor: light_red }
      },
      xaxis: { mode: "time", tickSize: [1, "hour"] },
      yaxis: { ticks: 14, tickFormatter: function(n) { return n.toFixed(0) } }
    };


function lines_chart(collection_url, chart_id, chart_overview_id) {
  $.getJSON(collection_url, function(collection) {
    var collection_chart =          $.plot($(chart_id),          [collection], lines_chart_opts);
    var collection_chart_overview = $.plot($(chart_overview_id), [collection], lines_overview_chart_opts);

    collection_chart_overview.setSelection({xaxis: {from: THIRTY_DAYS_AGO, to: TODAY}}, true);
    
    // connect charts
    $(chart_id).bind("plotselected", function (event, ranges) {
      // do the zooming
      collection_chart = $.plot($(chart_id), [collection], $.extend(true, {}, lines_chart_opts, {
        xaxis: { min: ranges.xaxis.from, max: ranges.xaxis.to }
      }));

      // don't fire event on the overview to prevent eternal loop
      collection_chart_overview.setSelection(ranges, true);
    });
    
    $(chart_overview_id).bind("plotselected", function (event, ranges) {
      collection_chart.setSelection(ranges);
    });
  });
}

function bars_chart(collection_url, chart_id) {
  $.getJSON(collection_url, function(collection) {
    $.plot($(chart_id), [collection], bars_chart_opts);
  });
}