# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

package Bugzilla::MFA::TOTP;
use strict;
use parent 'Bugzilla::MFA';

use Auth::GoogleAuth;
use Bugzilla::Error;
use Bugzilla::Token qw( issue_session_token );
use Bugzilla::Util qw( template_var generate_random_password );
use GD::Barcode::QRcode;
use MIME::Base64 qw( encode_base64 );

sub _auth {
    my ($self) = @_;
    return Auth::GoogleAuth->new({
        secret => $self->property_get('secret') // $self->property_get('secret.temp'),
        issuer => template_var('terms')->{BugzillaTitle},
        key_id => $self->{user}->login,
    });
}

sub enroll {
    my ($self) = @_;

    # create a new secret for the user
    # store it in secret.temp to avoid overwriting a valid secret
    $self->property_set('secret.temp', generate_random_password(16));

    # build the qr code
    my $auth = $self->_auth();
    my $otpauth = $auth->qr_code(undef, undef, undef, 1);
    my $png = GD::Barcode::QRcode->new($otpauth, { Version => 10, ModuleSize => 3 })->plot()->png();
    return { png => encode_base64($png), secret32 => $auth->secret32 };
}

sub enrolled {
    my ($self) = @_;

    # make the temporary secret permanent
    $self->property_set('secret', $self->property_get('secret.temp'));
    $self->property_delete('secret.temp');
}

sub prompt {
    my ($self, $params) = @_;
    my $template = Bugzilla->template;

    my $vars = {
        user  => $params->{user},
        token => scalar issue_session_token('mfa', $params->{user}),
        type  => $params->{type},
    };

    print Bugzilla->cgi->header();
    $template->process('mfa/totp/verify.html.tmpl', $vars)
        || ThrowTemplateError($template->error());
}

sub check {
    my ($self, $code) = @_;
    $self->_auth()->verify($code, 1)
        || ThrowUserError('mfa_totp_bad_code');
}

sub check_login {
    my ($self, $user) = @_;
    my $cgi = Bugzilla->cgi;

    $self->check($cgi->param('code') // '');
    $user->authorizer->mfa_verified($user, $cgi->param('type'));
}

1;
