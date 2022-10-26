// JavaScript Document

let menuOpen = false;

document.addEventListener("turbolinks:load", function(e)
{
  /****************************************************************************/
  /* AFFICHAGE / MASQUAGE MENU MOBILE
  /****************************************************************************/

  $(".btn-menu-mobile").on("click", function(e)
  {
    e.preventDefault();
    if(menuOpen == true) closeMenu();
    else openMenu();
  });
  $(".btn-menu-close").on("click", function(e) { e.preventDefault(); closeMenu(); });

  $('.section-double-bouton .header .button').click(function(e)
  {
    var bloc = $("." + $(this).data('bloc'));

    $('.section-double-bouton .header .button').removeClass('selected');
    $(this).addClass('selected');

    $('.section-double-bouton .bloc.current').fadeOut(300, function()
    {
      $('.section-double-bouton .header .bloc').removeClass('current');
      bloc.addClass('current').fadeIn(300);
     });
  });

  function openMenu()
  {
    if(menuOpen == false)
    {
      TweenMax.to($("ul#navigation-principale"), 0.5, {autoAlpha:1, display:'flex'});
      TweenMax.to($(".btn-menu-close"), 0.5, {autoAlpha:1, display:'block'});
      TweenMax.to($(".pictos-mobile"), 0.5, {autoAlpha:1, display:'block'});
      TweenMax.to($(".btn-menu-mobile"), 0.5, {autoAlpha:0, display:'none'});
      setTimeout(function(){ menuOpen = true; }, 0.5);
    }
  }

  function closeMenu()
  {
    if(menuOpen == true)
    {
      TweenMax.to($("ul#navigation-principale"), 0.5, {autoAlpha:0, display:'none'});
      TweenMax.to($(".btn-menu-close"), 0.5, {autoAlpha:0, display:'none'});
      TweenMax.to($(".pictos-mobile"), 0.5, {autoAlpha:0, display:'none'});
      TweenMax.to($(".btn-menu-mobile"), 0.5, {autoAlpha:1, display:'block'});
      menuOpen = false;
    }
  }

  /****************************************************************************/
  /* GESTION BOUTON RESET DANS LES SELECTS
  /****************************************************************************/

  if($('.select-container').length)
  {
    $('.btn-reset-select').click(function(e)
    {
      var btn = $(this);
      var select = $(this).parent();
      var input = $(this).parent().find('input');

      if(input.length) input.val(select.data('default'));
      else
      {
        input = $(this).parent().find('.select-selected');
        input.html(select.data('default'));
      }
      btn.hide();
    });

    $('.select-container input, .select-container .select-selected').on('change', function(e)
    {
      var input = $(this);
      var value = input.val();
      if(value == '') value = input.html();
      var select = $(this).parent();
      var btn = $(this).parent().find('.btn-reset-select');

      if(select.data('default') == value) btn.hide();
      else if(btn.css('display') == 'none') btn.show();
    });

    setTimeout(function(e)
    {
      $('.select-container').each(function()
      {
        var select = $(this);
        var input = $(this).find('input');
        var btn = $(this).find('.btn-reset-select');

        if(input.length && input.val() != '' && input.val() != select.data('default')) btn.show();
        else
        {
          input = $(this).find('.select-selected');
          if(input.length && input.html() != select.data('default')) btn.show();
        }
      });
    },100);
  }

});
