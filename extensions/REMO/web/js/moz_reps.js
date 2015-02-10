/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * This Source Code Form is "Incompatible With Secondary Licenses", as
 * defined by the Mozilla Public License, v. 2.0. */
/*global $ */

$(document).ready(function() {
    'use strict';

    var first_time = $("#first_time");
    first_time.prop("checked", true);
    first_time.change(function(evt) {
        if (!this.checked) {
            $("#prior_bug").show();
            $("#prior_bug label").addClass("required");
        }
        else {
            $("#prior_bug").hide();
            $("#prior_bug label").removeClass("required");
        }
    });

    $("#underage").change(function(evt) {
        if (this.checked) {
            $('#underage_warning').show();
            $('#submit').prop("disabled", true);
        }
        else {
            $('#underage_warning').hide();
            $('#submit').prop("disabled", false);
        }
    });

    $('#tmRequestForm').submit(function (event) {
        var mozillian_re = /https?:\/\/mozillians.org\/([^\/]+\/)?u\/[^\/]+/i;
        var errors = [];
        var missing = false;

        $('label.required').each(function (index) {
            var id = $(this).attr("for");
            var input = $("#" + id);

            if (id == 'mozillian') {
                if (!input.val().match(mozillian_re)) {
                    input.addClass("missing");
                    errors.push("The Mozillian Account URL is invalid");
                    event.preventDefault();
                }
                else {
                    input.removeClass("missing");
                }
            }
            else {
                if (input.val() == "") {
                    input.addClass("missing");
                    missing = true;
                    event.preventDefault();
                }
                else {
                    input.removeClass("missing");
                }
            }
        });

        if (missing) {
            errors.push("There are missing required fields");
        }

        if (errors.length) {
            alert(errors.join("\n"));
        }

        $('#short_desc').val(
            "Application Form: " + $('#first_name').val() + ' ' + $('#last_name').val()
        );
    });
});
