# FastDFS Dockerfile local (本地版本)

## 声明
其实并没什么区别 教程是在fastdfs编写人余青的原github中docker的基础上进行了一些修改，本质上还是余青上的作者写的教程

##使用版本

fastdfs-6.04
fastdfs-nginx-module-1.22
libfastcommon-1.0.42


## 目录介绍
### conf 
Dockerfile 所需要的一些配置文件
当然你也可以对这些文件进行一些修改  比如 storage.conf 里面的 bast_path 等相关

### source 
FastDFS 所需要的一些需要从网上下载的包(包括 FastDFS 本身) ,因为天朝网络原因 导致 build 镜像的时候各种出错
所以干脆提前下载下来了 . 


## 使用方法
需要注意的是 你需要在运行容器的时候制定宿主机的ip 用参数 FASTDFS_IPADDR 来指定
下面有一条docker run 的示例指令

```
docker run -d -e FASTDFS_IPADDR=192.168.1.234 --network=host --name test-fast 镜像id/镜像名称
```
这条启动命令是容器映射本机ip和端口，解决上传图片`无法获取服务端连接资源：can't create connection to 172.17.0.1:23000`的问题。

## 后记
本质上 local 版本与  network 版本无区别


## Statement
In fact, there is no difference between the tutorials written by Huayan Yu and Wiki on the basis of their previous authors. In essence, they are also tutorials written by the authors of Huayan Yu and Wiki.

## Catalogue introduction
### conf 
Dockerfile Some configuration files needed
Of course, you can also make some modifications to these files, such as bast_path in storage. conf, etc.

### source 
FastDFS Some of the packages that need to be downloaded from the Internet (including FastDFS itself) are due to various errors in building mirrors due to the Tianchao network
So I downloaded it in advance. 

## Usage method
Note that you need to specify the host IP when running the container with the parameter FASTDFS_IPADDR
Here's a sample docker run instruction
```
docker run -d -e FASTDFS_IPADDR=192.168.1.234 -p 8888:8888 -p 22122:22122 -p 23000:23000 -p 8011:80 --name test-fast 镜像id/镜像名称
```

## Epilogue
Essentially, there is no difference between the local version and the network version.
