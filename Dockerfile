# Version: 0.0.1
FROM ubuntu

MAINTAINER Xing Fu "bio.xfu@gmail.com"

RUN perl -p -i.orig -e 's/archive.ubuntu.com/mirrors.aliyun.com\/ubuntu/' /etc/apt/sources.list; \
    echo 'deb http://mirrors.ustc.edu.cn/CRAN/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9; \
    apt-get update; \
    apt-get install -y r-base r-base-dev gdebi-core libapparmor1 psmisc supervisor libedit2 wget; \
    apt-get clean; \
    apt-get autoremove

RUN wget http://download2.rstudio.org/rstudio-server-0.99.446-amd64.deb; \
    gdebi -n rstudio-server-0.99.446-amd64.deb; \
    rm /rstudio-server-0.99.446-amd64.deb

RUN adduser --disabled-password --gecos "" guest && echo "guest:guest"|chpasswd

RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN echo 'r-cran-repos=http://mirrors.ustc.edu.cn/CRAN/' >> /etc/rstudio/rsession.conf

ADD install_bioC.R /src/install_bioC.R

RUN Rscript /src/install_bioC.R && rm /src/install_bioC.R

EXPOSE 8787

CMD ["supervisord", "-n"]
