$(document).ready(function() {
  'use strict';
  var user_id = Tomatoes.current_user_id;
  var $leaderboardUserItem = $('.leaderboard_list li[data-user-id="' + user_id + '"]');

  if (user_id && $leaderboardUserItem.length) {
    $leaderboardUserItem.addClass('you');
  }
});
