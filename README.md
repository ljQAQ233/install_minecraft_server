# Install_Minecraft_Server

**By Maouai233(canyan233)**
**Blog : https://ljQAQ233.github.io/**

系统：ubuntu/debian/armbian/deeping/其他debian、ubuntu衍生系统
最新版本: **2.4-rebuild-20220807** -> 24
最新版本可不用root执行
创建gitee仓库以便ssh环境用户下载~~

# "技术"细节

## Java版本
### 实际需求
|McServer       |Java    |Class    |
| ------------  | ------ | ------- |
|1.19\*         |17      |61.0     |
|1.18\*         |16      |60.0     |
|1.17\*         |16      |60.0     |
|1.16\*         |8/11    |52/55    |
|1.15-          |8/11    |52/55    |

### 实际脚本安装
为适应实际情况（有部分Java没有在软件源中），对选择版本进行**微调**

|McServer      |Java  |Class  |
| ------------ | ---- | ----- |
|1.19\*        |17    |61.0   |
|1.18\*        |17    |60.0   |
|1.17\*        |17    |60.0   |
|1.16\*        |8/11  |52/55  |
|1.15-         |8/11  |52/55  |

将会根据实际用户的安装情况在**多个可用版本**中选择.详见脚本中函数 **NormalStart** & **JarStart**

## 通过读取Main.class获取需要的Java版本
Class文件中，第7-8个字节表示MajorVersion，通过解释MajorVersion获取Java版本.

## 启动脚本
提供小型可用的服务器管理工具.

## 流程

### 提供Jar包的安装：
1.全局检查[Checker]
2.检测Jar所需的Java版本
3.安装所需的Java版本
4.使用此版本检查Jar,如果运行错误，则有两种情况 a.Jar包损坏 b.版本不支持;此时，判断标准错误中是否有class与version字样即可.
5.进行第四步之后，Java版本可能会重新选择并安装
6.使用`update-alternatives --list java`获取已经安装了的Java可执行程序路径
7.同意协议
8.配置
9.生成启动脚本


### 在线下载安装:

## 世界生成(种子)
种子不能超过64位整型的范围，只能是在其范围内的整型数字，其余由Java的HashCode函数处理.
具体见**我的世界Wiki**

# v2.2-build-20220604

## 新特性
1.中英双语支持
2.可以自己设置Java参数-Xms & -Xmx
3.脚本退出时自动删除脚本的子脚本及缓存文件夹

## debug
1.减少不必要的输出
2.增加输入错误类型检测
3.初步完成Jar包损坏检测

# 2.3-debug-20220605

## 新特性
1.改良了脚本echo输出的分割线36betys
2.使用function定义函数，使用return + if
3.独立使用JarCheck函数和Check.sh脚本检测Jar包损坏
4.优化部分exit
5.%#&@

## debug
1.减少不必要的输出
2.完善Jar包损坏检测
3.%$#&

# 2.4-rebuild-20220807

本次版本更新的开发共持续10天（边打游戏边写作业边写代码）

## 新特性
1.在服务器配置之前先生成server.properties & eula.txt
2.针对不同服务端进行不同Java版本安装
3.加入Java编写
4.优化翻译
5.添加关于**在线下载**的MD5校验
6.使用**Axel**下载[ Default Args : `-n 32 ...` ]
7.为防止cat命令被替换为bat，使用**busybox**的cat命令
8.JarCheck中添加新情况：Jar包不支持此Java
9.提供小型可用的服务器管理工具
10.功能**模块化**优化
11.创建启动脚本时给予可执行权限
12.安装上颜色炮弹

## 移除
1.移除脚本开始运行时对于此版本不必要的端口检测
2.移除SoftwareInstall
3.取消使用wget(然而很好用)
4.移除Iptables使用

## 特殊的
1.减少sudo的使用以保障安全(原来整个脚本必须用root用户执行...)

## debug
1.修复JarCheck中的致命bug
2.移除了删进程时会把screen删掉的**特性**，此时screen正在进行下一步操作