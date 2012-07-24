// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery.flot
//= require jquery.flot.selection
//= require chart_helper

$(document).ready(function () {
  $.getJSON(USERS_BY_DAY_STATISTICS_URL, function(users_by_day) {
    $.getJSON(TOTAL_USERS_BY_DAY_STATISTICS_URL, function(total_users_by_day) {
      lines_chart_with_multiple_axis([
        {
          data: total_users_by_day,
          label: "Total users",
          color: RED,
          lines: { show: true, fill: true, fillColor: LIGHT_RED }
        },
        {
          data: users_by_day,
          label: "Sign ups",
          yaxis: 2,
          color: RED,
          bars: { show: true, barWidth: -60*60*1000, fillColor: LIGHT_RED }
        },
      ], "#users_by_day");
    });
  });
  // FIX: this action is too slow!
  // $.getJSON(USERS_BY_TOMATOES_STATISTICS_URL, function(users_by_tomatoes) {
  //   bars_chart(users_by_tomatoes, "#users_by_tomatoes");
  // });
  $.getJSON(TOMATOES_BY_DAY_STATISTICS_URL, function(tomatoes_by_day) {
    lines_chart(tomatoes_by_day, "#tomatoes_by_day");
  });
});