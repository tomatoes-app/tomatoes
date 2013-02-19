var TTFavicon = function() {
  var canvas, ctx, img, link,
      settings = {};
  
  var init = function(options) {
    $.extend(settings, options);

    canvas = document.createElement('canvas');
    img    = document.createElement('img');
    link   = document.getElementById('favicon').cloneNode(true);

    if(canvas.getContext) {
      canvas.height = canvas.width = 16; // set the size
      ctx = canvas.getContext('2d');

      img.onload = function() {
        drawFavicon(1);
      };
    }

    $(document).bind('timer_start', function() {
      drawFavicon(0);
    }).bind('timer_tick', function(event, timer, duration) {
      drawFavicon(timer/duration);
    }).bind('timer_stop', function() {
      drawFavicon(1);
    });

    img.src = '/images/tomatoes_icon.png';
  }

  var drawFavicon = function(factor) {
    if(factor < 1) {
      // Reset canvas
      canvas.width = 16;

      // Save the state, so we can undo the clipping
      ctx.save();
   
      ctx.beginPath();
      ctx.moveTo(8, 8); // center of the pie
      ctx.arc(  // draw next arc
          8,
          8,
          8,
          Math.PI * (- 0.5), // -0.5 sets set the start to be top
          Math.PI * (- 0.5 + 2 * factor),
          false
      );

      ctx.lineTo(8, 8); // line back to the center
      ctx.closePath();
   
      // Clip to the current path
      ctx.clip();
   
      ctx.drawImage(img, 0, 0);
   
      // Undo the clipping
      ctx.restore();
    }
    else {
      ctx.drawImage(img, 0, 0);
    }

    updateFavicon();
  }

  var updateFavicon = function() {
    link.href = canvas.toDataURL('image/png');
    document.body.appendChild(link);
  }
  
  return {
    init: init,
    drawFavicon: drawFavicon
  };
}();