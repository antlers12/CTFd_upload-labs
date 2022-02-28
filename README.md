# 适用于CTFd的upload-labs动态Flag镜像生成

本项目以upload-labs的Pass-11题为例，容器内其他题目无法使用，你可以通过修改Dockerfile文件自行修改为其他题目。但要注意，靶场内有些题目需要用到Windows特性，造成无法在Linux下复现。



## 特点

支持CTFd动态Flag，其中Flag被放置在根目录下`/flag`中。



## 使用方法

### 1.自由部署

git项目到本地

```
sudo git clone https://github.com/antlers12/CTFd_upload-labs.git
```

下载后可以自由更改对应的配置，可以修改`Dockerfile`、`docker-compose.yml`、`start.sh`、`flag`文件。

其中的`Antlers12`字符是用来替换动态Flag的，如果要进行修改，需要手动将全部的字符替换。

手动配置完成后，就可以生成docker镜像并启动，默认外部8023端口映射容器80端口

```
sudo docker-compose up -d
```

查看docker生成的镜像

```
sudo docker images
```



### 2.直接部署

如果嫌麻烦的话，可以直接用我在dockerhub已经打包好的镜像进行题目构建，只需要编写`Dockerfile`和`docker-compose.yml`就好了

**Dockerfile**

```Dockerfile
# 拉取镜像
FROM antlers12/base_ctfd_upload-labs

ENV LANG C.UTF-8

# 选择构建第几题的镜像，这里举例第11题，因为有需要，我对题目的提示信息进行了隐藏
RUN mv /var/www/html/Pass-11 /var/www/html/PassTemp
RUN rm -rf /var/www/html/Pass-*
# 除第14~17、19是需要先上传图片马再利用include.php包含利用,其它的题目都需要去除include.php文件
RUN rm /var/www/html/include.php
RUN sed -i '11 a <script type="text/javascript">window.location.href="./PassTemp";</script>' /var/www/html/index.php
# 隐藏提示信息
RUN rm -rf /var/www/html/menu.php &&\
    sed -i '11a <!--' /var/www/html/head.php &&\
    sed -i '17a -->' /var/www/html/head.php


# 暴露80端口
EXPOSE 80
```

直接生成题目镜像

```
docker build . -t upload_11
```

**docker-compose.yml**

```
version: '2'
services:
 web:
# 设置生成的镜像名
  image: upload-labs-11
  build: .
# 设置环境变量，用于生成动态flag
  environment:
   - FLAG=Antlers12
# 设置映射端口
  ports: 
   - "8023:80"
# 设置容器总是重新启动
  restart: always
```

当前文件夹下输入以下命令启动

```
sudo docker-compose up -d
```

查看docker生成的镜像

```
sudo docker images
```

