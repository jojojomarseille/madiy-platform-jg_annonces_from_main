import { gsap, Back } from "gsap";

// Header animation

$(window).scroll(function()
{
  var winTop = $(window).scrollTop();
  if (winTop >= 138) $("header").addClass("sticky");
  else $("header").removeClass('sticky');
});

// JQuery animate

document.addEventListener("turbolinks:load", (e) => {
  $('.item-reseaux, .item-bounce').on('mouseover', function(e) { bounceIn(this) });
  $('.item-reseaux, .item-bounce').on('mouseleave', function(e) { bounceOut(this) });

  $('.btn-categorie').on('mouseover', function(e) {
    var item = $(this).find('.puce');
    gsap.to(item, {scale:1.3, duration:.2});
  });
  $('.btn-categorie').on('mouseleave', function(e) {
    var item = $(this).find('.puce');
    gsap.to(item, {scale:1, duration:.2});
  });
})

function bounceIn(item)
{
  gsap.to(item, {scale:1.3, duration:.4, ease:Back.easeOut.config(3)});
}
function bounceOut(item)
{
  gsap.to(item, {scale:1, duration:.4, ease:Back.easeOut.config(3)});
}
