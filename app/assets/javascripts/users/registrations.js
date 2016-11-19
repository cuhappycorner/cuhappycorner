//= require shared/form

(function($) {

  'use strict';

  $(document).ready(function() {

    $("#new_user").validate(
      { 
        ignore: ":hidden",
        rules: {
          "user[password_confirmation]": {
            equalTo: "#user_password"
          },
          "cuid_confirmation": {
            equalTo: "#user_cuid"
          },
          "user[email]": {
            required: true, 
            email: true, 
            remote:"/users/check_email"
          },
          "user[cuid]": {
            required: true,
            remote:"/users/check_cuid"
          }
        },
        messages: {
          "user[email]": {
            remote: "User already exists.",
          },
          "user[cuid]": {
            remote: "User already exists.",
          }
        }
      }
    );

    $('#rootwizard_new_member').bootstrapWizard({
      onTabShow: function(tab, navigation, index) {
        var $total = navigation.find('li').length;
        var $current = index + 1;

        // If it's the last tab then hide the last button and show the finish instead
        if ($current >= $total) {
          $('#rootwizard').find('.pager .next').hide();
          $('#rootwizard').find('.pager .finish').show().removeClass('disabled hidden');
        } else {
          $('#rootwizard').find('.pager .next').show();
          $('#rootwizard').find('.pager .finish').hide();
        }

        var li = navigation.find('li.active');

        var btnNext = $('#rootwizard').find('.pager .next').find('button');
        var btnPrev = $('#rootwizard').find('.pager .previous').find('button');

        // remove fontAwesome icon classes
        function removeIcons(btn) {
          btn.removeClass(function(index, css) {
            return (css.match(/(^|\s)fa-\S+/g) || []).join(' ');
          });
        }

        if ($current > 1 && $current < $total) {

          var nextIcon = li.next().find('.fa');
          var nextIconClass = nextIcon.attr('class').match(/fa-[\w-]*/).join();

          removeIcons(btnNext);
          btnNext.addClass(nextIconClass + ' btn-animated from-left fa');

          var prevIcon = li.prev().find('.fa');
          var prevIconClass = prevIcon.attr('class').match(/fa-[\w-]*/).join();

          removeIcons(btnPrev);
          btnPrev.addClass(prevIconClass + ' btn-animated from-left fa');
        } else if ($current == 1) {
          // remove classes needed for button animations from previous button
          btnPrev.removeClass('btn-animated from-left fa');
          removeIcons(btnPrev);
        } else {
          // remove classes needed for button animations from next button
          btnNext.removeClass('btn-animated from-left fa');
          removeIcons(btnNext);
        }
      },
      onNext: function(tab, navigation, index) {
        console.log("Showing next tab");
        var $valid = $("#new_user").valid();
        if(!$valid) {
          $('body').pgNotification({
            style: 'flip',
            message: 'Please check the form again!',
            position: 'top-right',
            timeout: 8000,
            type: 'danger'
          }).show();
          return false;
        }
      },
      onPrevious: function(tab, navigation, index) {
        console.log("Showing previous tab");
        var $valid = $("#new_user").valid();
        if(!$valid) {
          $('body').pgNotification({
            style: 'flip',
            message: 'Please check the form again!',
            position: 'top-right',
            timeout: 8000,
            type: 'danger'
          }).show();
          return false;
        }
      },
      onInit: function() {
        $('#rootwizard ul').removeClass('nav-pills');
      }

    });

    $('#rootwizard').bootstrapWizard({
      onTabShow: function(tab, navigation, index) {
        var $total = navigation.find('li').length;
        var $current = index + 1;

        // If it's the last tab then hide the last button and show the finish instead
        if ($current >= $total) {
          $('#rootwizard').find('.pager .next').hide();
          $('#rootwizard').find('.pager .finish').show().removeClass('disabled hidden');
        } else {
          $('#rootwizard').find('.pager .next').show();
          $('#rootwizard').find('.pager .finish').hide();
        }

        var li = navigation.find('li.active');

        var btnNext = $('#rootwizard').find('.pager .next').find('button');
        var btnPrev = $('#rootwizard').find('.pager .previous').find('button');

        // remove fontAwesome icon classes
        function removeIcons(btn) {
          btn.removeClass(function(index, css) {
            return (css.match(/(^|\s)fa-\S+/g) || []).join(' ');
          });
        }

        if ($current > 1 && $current < $total) {

          var nextIcon = li.next().find('.fa');
          var nextIconClass = nextIcon.attr('class').match(/fa-[\w-]*/).join();

          removeIcons(btnNext);
          btnNext.addClass(nextIconClass + ' btn-animated from-left fa');

          var prevIcon = li.prev().find('.fa');
          var prevIconClass = prevIcon.attr('class').match(/fa-[\w-]*/).join();

          removeIcons(btnPrev);
          btnPrev.addClass(prevIconClass + ' btn-animated from-left fa');
        } else if ($current == 1) {
          // remove classes needed for button animations from previous button
          btnPrev.removeClass('btn-animated from-left fa');
          removeIcons(btnPrev);
        } else {
          // remove classes needed for button animations from next button
          btnNext.removeClass('btn-animated from-left fa');
          removeIcons(btnNext);
        }
      },
      onNext: function(tab, navigation, index) {
        console.log("Showing next tab");
        // var $valid = $("#new_user").valid();
        // if(!$valid) {
        //     $('body').pgNotification({
        //       style: 'flip',
        //       message: 'Please check the form again!',
        //       position: 'top-right',
        //       timeout: 8000,
        //       type: 'danger'
        //     }).show();
        //     return false;
        // }
      },
      onPrevious: function(tab, navigation, index) {
        console.log("Showing previous tab");
        // var $valid = $("#new_user").valid();
        // if(!$valid) {
        //     $('body').pgNotification({
        //       style: 'flip',
        //       message: 'Please check the form again!',
        //       position: 'top-right',
        //       timeout: 8000,
        //       type: 'danger'
        //     }).show();
        //     return false;
        // }
      },
      onInit: function() {
        $('#rootwizard ul').removeClass('nav-pills');
      }

    });

    $('.remove-item').click(function() {
      $(this).parents('tr').fadeOut(function() {
        $(this).remove();
      });
    });

  });

})(window.jQuery);