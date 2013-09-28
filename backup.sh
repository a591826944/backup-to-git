#!/bin/bash
#Date 2013-9-28
#author wwpeng
#email 591826944@qq.com
#该脚本用于将 项目变化的文件 以及 项目数据库 备份到 git上 ！！！PS：git 注意是git私有库 否则会都暴露掉不该暴露的东东哦～～
##########配置参数##########
#数据库地址
db_host=localhost
#数据库用户名
db_username=root
#数据库密码
db_password=wwpeng
#数据库名
db_dbname=a_o
#项目根目录路径
project_path=/var/www/a_o/
#备份下来的数据库 存放位置
db_dump_path=${project_path}"sql/"
##########检测配置路径##########
#检测项目路径是否正确
if [ ! -d "$project_path" ]; 
then 
	echo "Warning!! "${project_path}" not exist!"
	exit 0
elif [ ! -w "$project_path" ];
then
	echo "Warning!! "${project_path}" can not write!"
	exit 0
fi
#检测备份数据库的存放文件夹 
if [ ! -d "$db_dump_path" ]; 
then 
	mkdir ${db_dump_path}
elif [ ! -w "$db_dump_path" ];
then
	echo "Warning!! "${db_dump_path}" can not write!"
	exit 0
fi
##########生成sql备份##########
#生成备份文件文件名
file_name=${db_dbname}"_"$(date +%Y%m%d%H%M%S)
#备份生成sql文件
mysqldump -h $db_host -u $db_username -p$db_password $db_dbname > ${db_dump_path}${file_name}".sql"
tar -zcPf ${db_dump_path}${file_name}".tar.gz" ${db_dump_path}${file_name}".sql"
#删除生成的sql文件
rm -if ${db_dump_path}${file_name}".sql"
##########git提交操作##########
cd $project_path
git add .
git commit -m "backup database to git"
git push
