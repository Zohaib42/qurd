var Quadio = Quadio || {};

Quadio.Utility = {
    showFormError: function (form_selector, model_name, errors) {
        var error_label = $(form_selector + ' .error');
        if (error_label.length) {
            error_label.remove();
        }
        $('form').find('input.is-invalid').removeClass('is-invalid');
        var field_names = Object.keys(errors);
        $.each(field_names, function (key, field) {
            var error_msg = errors[field][0];
            var selector = $(form_selector + ' #' + model_name + '_' + field.replace('.', '-'));
            selector.addClass('is-invalid');
            if (selector.find('div').length) {
                selector = selector.find('div').first();
            }
            selector.parent('div').append('<label class="error">' + error_msg + '</label>');
        });
    },

    initToastMessage: function () {
        toastr.options = {
            "positionClass": "toast-top-right",
            "timeOut": "1000",
            "extendedTimeOut": "1000",
        };
        var error = $(".error-mg").text();
        if (error.length) {
            Quadio.Utility.toastError(error);
        }

        var alert = $(".alert-mg").text();
        if (alert.length) {
            Quadio.Utility.toastWarning(alert);
        }

        var notice = $(".notice-mg").text();
        if (notice.length) {
            Quadio.Utility.toastSuccess(notice);
        }
    },

    toastSuccess: function (message) {
        if (message) {
            toastr.success(message);
        }
    },

    toastError: function (message) {
        if (message) {
            toastr.error(message);
        }
    },

    toastWarning: function (message) {
        if (message) {
            toastr.warning(message);
        }
    },

    initToolTips: function () {
        $('[data-toggle="tooltip"]').tooltip();
    },
};

$(function () {
    Quadio.Utility.initToastMessage();
    Quadio.Utility.initToolTips();
});