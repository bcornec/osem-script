#!/usr/bin/perl -w
#
use strict;
use DBI;
use Template;
use Mail::Sendmail;
use MIME::Base64; ## content-transfer-encoding
use MIME::Words qw(encode_mimewords); ## handle UTF-8 in mail headers
use Data::Dumper;

#print "env: \n";
#system('printenv');
#print "found env var MSYQL: ***$ENV{'MYSQL_PASSWD'}***\n";
#
my $md = "$ENV{'HOME'}/Mail";
mkdir("$md",0750) if (not -d "$md");

open(RQT,'/request.sql') || die "Unable to read /request.sql";
my $rqt = <RQT>;
close(RQT);
my $dbh = DBI->connect("DBI:mysql:database=osem;host=$ENV{'MYSQL_SRV'}", "osem", $ENV{'MYSQL_PASSWD'}, {'RaiseError' => 1});
my $sth = $dbh->prepare($rqt) || die "Unable to prepare request $rqt";
$sth->execute() || die "Unable to execute request $rqt";

my $tt = Template->new({ENCODING => 'utf8', ABSOLUTE => 1}) || die "$Template::ERROR\n";

# Substitute variables
while (my $ref = $sth->fetchrow_hashref()) {
	# Transforming templates
	$tt->process("/subject",$ref,"/tmp/subject",{ binmode => ':encoding(utf8)' }) || die "Template process failed: ", $tt->error(), "\n";
	open(SUB,'/tmp/subject') || die "Unable to read /tmp/subject";
	my $sub = <SUB>;
	close(SUB);
	$tt->process("/body",$ref,"/tmp/body",{ binmode => ':encoding(utf8)' }) || die "Template process failed: ", $tt->error(), "\n";
	$/ = undef;
	open(BODY,'/tmp/body') || die "Unable to read /tmp/body";
	my $body = <BODY>;
	close(BODY);
	$/ = "";
	#
	print "Sending mail to $ref->{'email'} on $sub\n";
	# Preparation of headers 
	#
	my %mail = (
		To => "$ref->{'email'}",
		From => 'FLOSSCon 2019 <osem@flosscon.org>',
		Cc => 'FLOSSCon 2019 <flosscon@flossita.org>',
		Smtp => 'smtp.hyper-linux.org',
		Subject => "[FLOSSCon] ".$sub,
		"Content-type" => 'text/plain; charset="utf-8"',
		"Content-Transfer-Encoding" => 'base64'
	);
	#utf8::encode($body);
	$mail{'Body'} = encode_base64($body);
	# Envoi du mail
	#print "Dump mail: ".Dumper(%mail)."\n";
	sendmail(%mail) || die "Impossible d\'envoyer le mail ($Mail::Sendmail::error): $Mail::Sendmail::log";
	}
$sth->finish();
$dbh->disconnect();
