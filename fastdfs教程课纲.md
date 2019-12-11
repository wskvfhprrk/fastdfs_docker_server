# fastdfs教程课纲

## 安装虚拟机和linux系统

#### 安装vm虚拟机

#### 安装centos7 系统

[阿里镜像地址]: https://developer.aliyun.com/mirror
[centos7下载路径]: https://mirrors.aliyun.com/centos/?spm=a2c6h.13651104.0.0.585e7fbfcBH7A6

## 安装fastdfs前准备

#### 查看虚拟机地址

```linux
ip add
```

#### 使用xshell连接虚拟机

#### 使用阿里镜像地址

- yum安装wget

```linux
yum install wget -y
```

- 备份`CentOS-Base.repo`

```linux
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
```

- 下载阿里镜像源

```linux
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

- 运行 `yum makecache `生成缓存

```linux
yum makecache
```

#### 更新centos7

```linux
yum update -y
```

#### 关闭虚拟机进行克隆

#### 调整一下拟机内容大小和cpu个数——加快运行速度

#### 去git下找到余青`fdstdfs`

[git地址]: https://github.com/happyfish100
[fastdfs地址]: https://github.com/happyfish100/fastdfs

#### 安装fdstdfs

进入余青github，进入`fastdfs`项目的`wiki`

https://github.com/happyfish100/fastdfs/wiki

#### github免密操作

linux开启免密

```linux
ssh-keygen -t rsa -C "email@address"
```

- 密码


```linux
cat /root/.ssh/id_rsa.pub 
```

- 把密码放入github ssh里

按照wiki上一步步进行安装，安装遇到两个坑：

1. 安装FastDFS那一步中配置准备文件，`/usr/etc/fdfs/`路径是不存在的，应该使用这个命令

   ```
   cp /usr/local/nginx/conf/* /etc/fdfs #把/usr/local/nginx/conf下的所有文件拷入/etc/fdfs下
   ```

   

2. 安装`nginx`前应该先执行`配置nginx访问`中修改`/etc/fdfs/mod_fastdfs.conf`,然后再 `安装nginx`，否则安装nginx之后访问不到上传的资源文件。

## 重新整理安装步骤（原文作者余青）

## 使用的系统软件

| 名称                 | 说明                          |
| -------------------- | ----------------------------- |
| centos               | 7.x                           |
| libfatscommon        | FastDFS分离出的一些公用函数包 |
| FastDFS              | FastDFS本体                   |
| fastdfs-nginx-module | FastDFS和nginx的关联模块      |
| nginx                | nginx1.15.4                   |

## 编译环境

```
yum install git gcc gcc-c++ make automake autoconf libtool pcre pcre-devel zlib zlib-devel openssl-devel wget vim -y
```

## 磁盘目录

| 说明                                   | 位置           |
| -------------------------------------- | -------------- |
| 所有安装包                             | /usr/local/src |
| 数据存储位置                           | /home/dfs/     |
| #这里我为了方便把日志什么的都放到了dfs |                |

```
mkdir /home/dfs #创建数据存储目录
cd /usr/local/src #切换到安装目录准备下载安装包
```

## 安装libfatscommon

```
git clone https://github.com/happyfish100/libfastcommon.git --depth 1
cd libfastcommon/
./make.sh && ./make.sh install #编译安装
```

## 安装FastDFS

```linux
cd ../ #返回上一级目录
git clone https://github.com/happyfish100/fastdfs.git --depth 1
cd fastdfs/
./make.sh && ./make.sh install #编译安装
#配置文件准备
cp /usr/local/nginx/conf/* /etc/fdfs #把/usr/local/nginx/conf下的所有文件拷入/etc/fdfs下
```

**在这里可以配置并启动tracker和storage,然后进行测试**



## 安装fastdfs-nginx-module

```
cd ../ #返回上一级目录
git clone https://github.com/happyfish100/fastdfs-nginx-module.git --depth 1
cp /usr/local/src/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs
```

## 安装nginx

**安装nginx前一定要配置好`fastdfs-nginx-module`文件后再进行安装**

#### 配置`fastdfs-nginx-module`

```linux
vim /etc/fdfs/mod_fastdfs.conf
#需要修改的内容如下
tracker_server=192.168.52.1:22122  #tracker服务器IP和端口
url_have_group_name=true
store_path0=/home/dfs
```

#### 安装nginx

```
wget http://nginx.org/download/nginx-1.15.4.tar.gz #下载nginx压缩包
tar -zxvf nginx-1.15.4.tar.gz #解压
cd nginx-1.15.4/
#添加fastdfs-nginx-module模块
./configure --add-module=/usr/local/src/fastdfs-nginx-module/src/ 
make && make install #编译安装
```

# 单机部署

## tracker配置

```
#服务器ip为 192.168.52.1
#我建议用ftp下载下来这些文件 本地修改
vim /etc/fdfs/tracker.conf
#需要修改的内容如下
port=22122  # tracker服务器端口（默认22122,一般不修改）
base_path=/home/dfs  # 存储日志和数据的根目录
```

## storage配置

```
vim /etc/fdfs/storage.conf
#需要修改的内容如下
port=23000  # storage服务端口（默认23000,一般不修改）
base_path=/home/dfs  # 数据和日志文件存储根目录
store_path0=/home/dfs  # 第一个存储目录
tracker_server=192.168.52.1:22122  # tracker服务器IP和端口
http.server_port=8888  # http访问文件的端口(默认8888,看情况修改,和nginx中保持一致)
```

## client测试

```linux
vim /etc/fdfs/client.conf
#需要修改的内容如下
base_path=/home/dfs
tracker_server=192.168.52.1:22122    #tracker服务器IP和端口
#保存后测试,返回ID表示成功 如：group1/M00/00/00/xx.jpg
 fdfs_upload_file /etc/fdfs/client.conf /etc/fdfs/anti-steal.jpg
```

## 配置nginx访问

```linux
#配置nginx.config
vim /usr/local/nginx/conf/nginx.conf
#添加如下配置
server {
    listen       8888;    ## 该端口为storage.conf中的http.server_port相同
    server_name  localhost;
    location ~/group[0-9]/ {
        ngx_fastdfs_module;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
    root   html;
    }
}
#测试下载，用外部浏览器访问刚才已传过的nginx安装包,引用返回的ID
http://192.168.52.1:8888/group1/M00/00/00/wKgAQ1pysxmAaqhAAA76tz-dVgg.tar.gz
#弹出下载单机部署全部跑通
```

# 启动

## 防火墙

```
#不关闭防火墙的话无法使用
systemctl stop firewalld.service #关闭
systemctl restart firewalld.service #重启
```

## tracker

```
/etc/init.d/fdfs_trackerd start #启动tracker服务
/etc/init.d/fdfs_trackerd restart #重启动tracker服务
/etc/init.d/fdfs_trackerd stop #停止tracker服务
chkconfig fdfs_trackerd on #自启动tracker服务
```

## storage

```
/etc/init.d/fdfs_storaged start #启动storage服务
/etc/init.d/fdfs_storaged restart #重动storage服务
/etc/init.d/fdfs_storaged stop #停止动storage服务
chkconfig fdfs_storaged on #自启动storage服务
```

## nginx

```
/usr/local/nginx/sbin/nginx #启动nginx
/usr/local/nginx/sbin/nginx -s reload #重启nginx
/usr/local/nginx/sbin/nginx -s stop #停止nginx
```

## 安装过程中遇到的问题：

1. conf配置文件配置错误——不小心；
2. 系统防火墙没有关闭；

## 解决方案

1. 在配置conf文件时要小心配置；
2. 使用ping和telent命令查看ip和端口是否通；
3. 查看日志，一般情况错误都有日志。