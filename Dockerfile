# centos 7
FROM centos:7
# 添加配置文件
# add profiles
ADD conf/client.conf /etc/fdfs/
ADD conf/http.conf /etc/fdfs/
ADD conf/mime.types /etc/fdfs/
ADD conf/storage.conf /etc/fdfs/
ADD conf/tracker.conf /etc/fdfs/
ADD fastdfs.sh /home
ADD conf/nginx.conf /etc/fdfs/
ADD conf/mod_fastdfs.conf /etc/fdfs

# 添加源文件
# add source code
ADD source/* /usr/local/src/
#ADD source/fastdfs.tar.gz /usr/local/src/
#ADD source/fastdfs-nginx-module.tar.gz /usr/local/src/
#ADD source/nginx-1.15.4.tar.gz /usr/local/src/

# Run
#加入--nogpgcheck centos避免其报错
RUN yum install --nogpgcheck  git gcc gcc-c++ make automake autoconf libtool pcre pcre-devel zlib zlib-devel openssl-devel wget vim -y \
  &&  mkdir /home/dfs   \
  &&  cd /usr/local/src/  \
  && mv fastdfs-6.04 fastdfs  \
  && mv fastdfs-nginx-module-1.22 fastdfs-nginx-module  \
  && mv libfastcommon-1.0.42 libfastcommon \
  &&  cd libfastcommon/   \
  &&  ./make.sh && ./make.sh install  \
  &&  cd ../  \
  &&  cd fastdfs/   \
  &&  ./make.sh && ./make.sh install  \
  &&  cd ../  \
  &&  cd nginx-1.15.4/  \
  &&  ./configure --add-module=/usr/local/src/fastdfs-nginx-module/src/   \
  &&  make && make install  \
  &&  chmod +x /home/fastdfs.sh


# export config
VOLUME /etc/fdfs


EXPOSE 22122 23000 8888 80
ENTRYPOINT ["/home/fastdfs.sh"]
