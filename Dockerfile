FROM centos:centos7

MAINTAINER CSRG <camilo.valenzuela@alumnos.usm.cl>


#Installing dependencies
RUN yum update && yum install -y git wget gcc gcc-c++ emacs antlr expat expat-devel cppunit cppunit-devel swig loki-lib log4cpp shunit2 castor hibernate3 xerces-c xerces-c-devel xerces-j2 ksh subversion autoconf doxygen make

#Creating acs user
RUN adduser -U acs


#Creating alma directory
RUN mkdir /alma  && chown -R acs:acs /alma


#Changing to acs user
USER acs

#Download repo and configurate the enviroment
RUN git clone -b merges https://github.com/csrg-utfsm/acscb.git  ~/acs-repo &&\ 
    source ~/acs-repo/LGPL/acsBUILD/config/.acs/.bash_profile.acs &&\
    mkdir -p $ALMASW_INSTDIR

RUN cd ~/acs-repo/ExtProd/PRODUCTS &&\
		./download-products.sh &&\
		cd ../INSTALL &&\
		./buildTools &&\
		cd $ALMASW_INSTDIR &&\
		find -name "*.o" | xargs rm -rf

ENV MAKE_NOSTATIC=yes
ENV MAKE_NOIFR_CHECK=on 
ENV MAKE_PARS=" -j 2 -l 2 "

RUN cd ~/acs-repo/ && make

