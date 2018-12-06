# frida-ios-dump集成的坑



按照http://www.alonemonkey.com/2018/01/30/frida-ios-dump/ 的文章集成frida-ios-dump发现过程并不是很顺利。

### 环境配置

首先上面也说了该工具基于frida，所以首先要在手机和mac电脑上面安装frida，安装方式参数官网的文档:<https://www.frida.re/docs/home/>

越狱手机的安装frida:

+ 打开cydia
+ 添加源：`http://build.frida.re`
+ 安装 [Frida](https://www.frida.re/docs/ios)



mac电脑

+ pip install frida-tools
+ sudo mkdir /opt/dump && cd /opt/dump && sudo git clone https://github.com/AloneMonkey/frida-ios-dum
+ open ~/.zrshrc    添加 alias dump.py="/opt/dump/frida-ios-dump/dump.py"这一行





到这里一切都很顺利



frida-ps -U也没问题,但dump.py  **却显示  纳闷~

```
Traceback (most recent call last):
  File "/opt/dump/frida-ios-dump/dump.py", line 10, in <module>
    import frida
  File "/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/frida/__init__.py", line 24, in <module>
    raise ex
ImportError: No module named _frida
```



原来是pip安装到frida到python3

而mac默认是python2启动的

解决办法

+ which python 查看python启动路径 我的是:/usr/local/bin/python 
+ which python3 查看python3启动路径 我的是:/usr/local/bin/python3
+  unlink /usr/local/bin/python
+ ln -s /usr/local/bin/python3 /usr/local/bin/python 

ok,现在可以dump.py  **了,但却出现python2语法错误,修复后就可以愉快的dump了。







