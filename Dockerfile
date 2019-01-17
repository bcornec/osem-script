FROM mageia:6

RUN urpmi.addmedia --distrib mga http://distrib-coffee.ipsl.jussieu.fr/pub/linux/Mageia/distrib/6/x86_64
RUN urpmi.update -a
RUN urpmi --auto --no-recommends perl-DBD-mysql perl-DBI perl-Template-Toolkit perl-Mail-Sendmail perl-MIME-tools perl-MIME-Base64
ARG MYSQL_PASSWD
ARG MYSQL_SRV
ENV MYSQL_PASSWD=$MYSQL_PASSWD
ENV MYSQL_SRV=$MYSQL_SRV
#RUN printenv
COPY contact-speaker.pl /
COPY request.sql /
COPY subject /
COPY body /
CMD /contact-speaker.pl
