FROM centos:centos7

MAINTAINER CSRG <camilo.valenzuela@alumnos.usm.cl>

#Installing dependencies
RUN yum install -y epel-release

RUN yum install -y make bzip2 unzip patch libX11-devel \ 
    git wget gcc gcc-c++ emacs antlr expat-devel cppunit cppunit-devel \
    swig log4cpp castor xerces-c xerces-c-devel xerces-j2 ksh subversion \
    autoconf doxygen blas-devel byacc vim subversion openssh time bc flex \
    gsl-devel openldap-devel procmail python-pip python-devel openssl-devel \
    libxslt-devel libxml2-devel sqlite-devel freetype-devel libpng-devel bzip2-devel

#Installing Java JDK
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.rpm" && \
    yum install -y jdk-8u121-linux-x64.rpm && \
    rm jdk-8u121-linux-x64.rpm

RUN pip install virtualenv

#Creating alma directory
RUN mkdir /alma 


#Download repo and configurate the enviroment

COPY acscb  root/acs-repo

RUN echo 'source $HOME/acs-repo/LGPL/acsBUILD/config/.acs/.bash_profile.acs' >> ~/.bashrc && \
    source ~/.bashrc 

RUN 	source ~/.bashrc && \
	cd ~/acs-repo/ExtProd/INSTALL && \
	./buildTools && \
	cd $ALMASW_INSTDIR && \
	find -name "*.o" | xargs rm -rf &&\
	git clean -fx ~/acs-repo/ExtProd/PRODUCTS	

ENV MAKE_NOSTATIC=yes
ENV MAKE_NOIFR_CHECK=on 
ENV MAKE_PARS=" -j 2 -l 2 "

#RUN source ~/.bashrc && cd ~/acs-repo/ && make
