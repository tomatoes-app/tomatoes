$(document).ready(function () {
  var red = "rgba(255, 0, 0, 1)",
      light_red = "rgba(255, 0, 0, 0.5)",
      tomatoes_by_day_chart_opts = {
        series: {
          color: red,
          lines: { show: true, fill: true, fillColor: light_red }
        },
        selection: { mode: "x" },
        xaxis: { mode: "time", ticks: 14, min: THIRTY_DAYS_AGO, max: TODAY },
        yaxis: { ticks: 14, tickFormatter: function(n) { return n.toFixed(0) } }
      };
  
  var tomatoes_by_day_chart = $.plot($("#tomatoes_by_day"), [tomatoes_by_day], tomatoes_by_day_chart_opts);
  
  var tomatoes_by_day_chart_overview = $.plot($("#tomatoes_by_day_overview"), [tomatoes_by_day], {
    series: {
      color: red,
      lines: { show: true, fill: true, lineWidth: 1, fillColor: light_red },
      shadowSize: 0
    },
    selection: { mode: "x" },
    xaxis: { mode: "time", ticks: [] },
    yaxis: { ticks: [], autoscaleMargin: 0.1, tickSize: 1 }
  });

  tomatoes_by_day_chart_overview.setSelection({xaxis: {from: THIRTY_DAYS_AGO, to: TODAY}}, true);
  
  // connect charts
  $("#tomatoes_by_day").bind("plotselected", function (event, ranges) {
    // do the zooming
    tomatoes_by_day_chart = $.plot($("#tomatoes_by_day"), [tomatoes_by_day], $.extend(true, {}, tomatoes_by_day_chart_opts, {
      xaxis: { min: ranges.xaxis.from, max: ranges.xaxis.to }
    }));

    // don't fire event on the overview to prevent eternal loop
    tomatoes_by_day_chart_overview.setSelection(ranges, true);
  });
  
  $("#tomatoes_by_day_overview").bind("plotselected", function (event, ranges) {
    tomatoes_by_day_chart.setSelection(ranges);
  });

  $.plot(
    $("#tomatoes_by_hour"), [tomatoes_by_hour],
    {
      series: {
        color: red,
        bars: { show: true, barWidth: 60*60*1000, fillColor: light_red }
      },
      xaxis: { mode: "time", tickSize: [1, "hour"] },
      yaxis: { ticks: 14, tickFormatter: function(n) { return n.toFixed(0) } }
    }
  );
});