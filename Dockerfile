# 拉取镜像
FROM ubuntu:18.04
 
# 更新源
RUN apt-get -y update &&\
    apt-get -y upgrade &&\
    apt -y install software-properties-common &&\
    add-apt-repository ppa:ondrej/php

# 防止Apache安装过程中地区的设置出错
ENV DEBIAN_FRONTEND noninteractive
# 安装apache2
RUN apt-get -y install apache2
# 安装php
RUN apt-get -y install php5.6 php5.6-gd php5.6-cgi php5.6-mysql php5.6-xml php5.6-json php5.6-mcrypt php5.6-common php5.6-dev
# 使Apache2可以解析php,关闭目录浏览,解析.htaccess
RUN apt-get -y install libapache2-mod-php5.6 &&\
    sed -i "171 s/Indexes//" /etc/apache2/apache2.conf &&\
    sed -i '172 s/None/all/' /etc/apache2/apache2.conf 

# 把源码放入容器
COPY ./src /var/www/html
# 删除Apache默认页面
RUN rm /var/www/html/index.html

# 选择构建第几题的镜像，这里举例第11题
RUN mv /var/www/html/Pass-11 /var/www/html/PassTemp
RUN rm -rf /var/www/html/Pass-*
RUN mv /var/www/html/PassTemp /var/www/html/Pass-11
RUN sed -i '11 a <script type="text/javascript">window.location.href="./Pass-11";</script>' /var/www/html/index.php
# 你可以选择隐藏题目的提示信息
# RUN rm -rf /var/www/html/menu.php &&\
#     sed -i '11a <!--' /var/www/html/head.php &&\
#     sed -i '17a -->' /var/www/html/head.php

# 赋予权限
RUN chown -R www-data:www-data /var/www/
# 因为docker是单个进程的，如果一个进程退出docker就退出，所以需要一个永远不退出的进程，将日志输入到1.txt
RUN touch /var/log/1.txt
RUN chmod +x /var/log/1.txt

# 把启动脚本和flag放入目录下赋予权限
COPY ./flag /
COPY ./start.sh /root/
RUN  chmod +x /root/start.sh

# 重启Apache
RUN service apache2 start
# 暴露80端口
EXPOSE 80
 
# 在容器生成时候，启动start.sh脚本
ENTRYPOINT ["/root/start.sh"]
