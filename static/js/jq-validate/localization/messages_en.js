(function( factory ) {
	if ( typeof define === "function" && define.amd ) {
		define( ["jquery", "../jquery.validate"], factory );
	} else {
		factory( jQuery );
	}
}(function( $ ) {

/*
 * Translated default messages for the jQuery validation plugin.
 * Locale: EN (english; English)
 */
$.extend($.validator.messages, {
	required: "This is a required field.",
	remote: "Please, fill this field.",
	email: "Please, write a valid e-mail address.",
	url: "Please, write a valid URL.",
	date: "Please, write a valid date.",
	dateISO: "Please, write a valid (ISO) date.",
	number: "Please, write a valid number.",
	digits: "Please, write only digits.",
	creditcard: "Please, write a valid credit card number.",
	equalTo: "Please, write the same value again.",
	extension: "Please, write a valid extension.",
	maxlength: $.validator.format("Please do not write more than {0} characters."),
	minlength: $.validator.format("Please, do not write less than {0} characters."),
	rangelength: $.validator.format("Please, write a value between {0} and {1} characters."),
	range: $.validator.format("Please, write a value between {0} and {1}."),
	max: $.validator.format("Please, write a value less or equal to {0}."),
	min: $.validator.format("Please, write a value greater or equal to {0}."),
	nifES: "Please, write a valid NIF.",
	nieES: "Please, write a valid NIE.",
	cifES: "Please, write a valid CIF."
});

}));
