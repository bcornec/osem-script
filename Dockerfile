FROM mageia:6

RUN urpmi.addmedia --distrib mga http://distrib-coffee.ipsl.jussieu.fr/pub/linux/Mageia/distrib/6/x86_64
RUN urpmi.update -a
RUN urpmi --auto --no-recommends perl-DBD-mysql perl-DBI mutt
RUN env
COPY contact-speakers.pl /
COPY msg /
CMD contact-speakers.pl
