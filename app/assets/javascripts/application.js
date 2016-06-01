// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


(function( root, $, undefined ) {
	"use strict";

	$(function () {
    // DOM ready, take it away
    $('.form-init-reset').submit(function(e) {
      e.preventDefault();

      $.ajax({
        url: document.location.origin + "/api/v1/register/reset",
        data: serializeToJson($(this).serializeArray())
      }).done(function(response) {
        if (!response) return $(".error-container").html("Désolé ! Aucun utilisateur n'est inscrit avec cet email.");
        if (response.status === 200) {
          $('.form-init-reset, .error-container').remove();
          $('.response').removeClass("hide")
          $('.response')
            .html("Vérifiez votre boîte mail pour changer votre mot de passe. Si vous n'avez pas reçu d'email et qu'il n'est pas dans vos spams, contactez nous.")
        }
      }).fail(function(error) {
        $(".error-container").html("Attention ! Veillez a bien remplir votre email.");
      });
    });

    $('.form-reset-password').submit(function(e) {
      e.preventDefault();

      var params = serializeToJson($(this).serializeArray());

      if (!params.password || !params.password_confirmation) {
        $(".error-container").html("Attention ! Vous devez renseigner votre nouveau mot de passe");
        return false
      };
      if (params.password != params.password_confirmation) {
        $(".error-container").html("Attention ! Votre mot de passe et sa confirmation sont différents");
        return false
      };

      $.ajax({
        url: document.location.origin + "/api/v1/register/reset",
        method: "post",
        data: serializeToJson($(this).serializeArray())
      }).done(function(response) {
        console.log(response)
        if (response.status === 201) {
          // $('.form-reset-password, .error-container').remove();
          // $('.response').removeClass("hide")
          // $('.response')
          //   .html("Félicitations ! Votre mot de passe à bien été changé. Rendez vous sur Metropolis.watch");
					location.replace("http://metropolis-front.herokuapp.com");
        }
      }).fail(function(error) {
          $(".error-container").html("Attention ! Votre mot de passe est invalide");
      });
    });

    $('#password, #password_confirmation, #email').on('focus', function() {
      $(this).parent().css({
        border: "1px solid #673AB7"
      });
    });

    $('#password, #password_confirmation, #email').on('focusout', function() {
      $(this).parent().css({
        border: "1px solid white"
      });
    });
	});

  function serializeToJson(obj) {
    return obj
      .reduce(function(obj, item) {
        obj[item.name] = item.value;
        return obj;
      }, {});
  }

} ( this, jQuery ));
