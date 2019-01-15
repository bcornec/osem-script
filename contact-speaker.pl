#!/usr/bin/perl -w
#
use strict;
use DBI;
use Template;
use Mail::Sendmail;

#print "found env var MSYQL: ***$ENV{'MYSQL_PASSWD'}***\n";
#
## Make mutt happy
my $md = "$ENV{'HOME'}/Mail";
mkdir("$md",0750) if (not -d "$md");

open(RQT,'/request.sql') || die "Unable to read /request.sql";
my $rqt = <RQT>;
close(RQT);
my $dbh = DBI->connect("DBI:mysql:database=osem;host=osem-database", "osem", $ENV{'MYSQL_PASSWD'}, {'RaiseError' => 1});
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
	open(BODY,'/tmp/body') || die "Unable to read /tmp/body";
	my $body = <BODY>;
	close(BODY);
	#
	print "Sending mail to $ref->{'email'} on $sub\n";
	#system("mutt $ref->{'email'} -s \"\[FLOSSCon\] $sub\" -i /tmp/body < /dev/null");
	# Preparation of headers 
	#
	my %mail = (
		To => $ref->{'email'} ,
		From => 'FLOSSCon 2019 <flosscon@flosscon.org>',
		Cc => 'FLOSSCon 2019 <flosscon@flosscon.org>',
		Smtp => 'mail',
		Body => $body,
		Subject => "[FLOSSCon]".$sub,
	);
	# Envoi du mail
	sendmail(%mail) || die "Impossible d\'envoyer le mail ($Mail::Sendmail::error): $Mail::Sendmail::log";
	}
$sth->finish();
$dbh->disconnect();
