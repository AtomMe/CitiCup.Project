jQuery(document).ready(
		function() {

			// /// TRANSFORM CHECKBOX /////
			jQuery('input:checkbox').uniform();

			// /// LOGIN FORM SUBMIT /////
			jQuery('#login').submit(
					function() {
						if (jQuery('#username').val() == 'admin'
								&& jQuery('#password').val() == '123') {
							jQuery('.nousername').fadeIn();
							jQuery('.nopassword').hide();
							return true;
						} else {
							jQuery('.nopassword').fadeIn();
							jQuery('.nousername,.username').hide();
							return false;
						}
					});

			// /// ADD PLACEHOLDER /////
			jQuery('#username').attr('placeholder', 'Username');
			jQuery('#password').attr('placeholder', 'Password');
		});
