$.validator.setDefaults({
    highlight: function(element) {
        $(element).closest('.form-control').addClass('has-error');
    },
    unhighlight: function(element) {
        $(element).closest('.form-control').removeClass('has-error');
    },
    errorElement: 'div',
    errorClass: 'alert alert-danger',
    errorPlacement: function(error, element) {
        if(element.parent('.input-group').length) {
            error.insertAfter(element.parent());
        } else {
            error.insertAfter(element);
        }
    }
});
