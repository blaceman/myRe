---
	勿管世间纷闹,勿管处境。静心做人,静心做事。感谢师傅alonemonkey,感谢同行之人的无私奉献。
---

# lldb动态调试学习



### 准备工作(越狱)

+ 越狱真机调试后在/Developer/usr/bin下找到debugserver

+ 复制debugserver到mac上

+ x新建entitlements.plist文件,签名权限:codesign -s - --entiltilements.plist -f debugserver

   ```plist
   
   ```
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
          <key>com.apple.springboard.debugapplications</key>
          <true/>
          <key>get-task-allow</key>
          <true/>
          <key>task_for_pid-allow</key>
          <true/>
          <key>run-unsigned-code</key>
          <true/>
  </dict>
  </plist>
   ```

+ 将debugserver复制回手机 /usr/bin/debugserver
+ 打开应用 ps -aux找到进程;
+ 附加:根据进程名或id:debugserver  *:1234 -a Snapchat(731)  
+ 然后mac终端输入lldb进去lldb界面
+ 然后(iproxy 1234 1234)process connect connect://localhost:1234或process connect connect:手机ip地址:1234  进行连接就ok



+ 启动:debugserver -x backboard *:1234 /Applications/MobileSMS.app/MobileSMS  



### lldb常用命令

+ image list -o -f:      [序列号] + 模块基地址 +  路径(真正加载的地址)  
   + 这里说明一下:  内存的真实地址 =  模块的基地址 + ida或hopper查看的地址
+ b 内存地址: 或  br s -a 内存地址: (符号还原后: b 方法名):      下断点
+ "Control + C" 暂停,终端支持。
+ c: 继续
+ po :打印对象
+ x/s \$x1:将寄存器x1以字符串的方式打印出来
+   \$x0 - \$x7: 为寄存器调用的参数, 如果是OC对象\$x0为调用对象,$x1为调用方法。
+ memory read -force -f  \$sp  $fp: 栈参数
+ bt: 查看堆栈信息
+ register read:  读取寄存器的所有值
+ register read \$x0:读取某个寄存器的值
+ register write \$x4: 修改寄存器的值
+ si:跳到当前指令内部
+ ni:跳到当前指令
+ finish:返回上层调用栈
+ thread return:不用执行下面的代码,之前从当前调用栈返回一个值
+ br list: 查看当前列表断点
+ br del:删除当前的所有断点
+ br del 1.1.1:删除指定编码的断点
+ br dis 2.1 使断点2.1失效
+ br enable 2.1: 使断点2.1生效
+ thread info:输出线程当前信息
+ b ptrace -c xxx 满足某个条件后才会中断

+ help "命令名" : 查看命令的详细用法
+ apropos "相关命令信息": 搜索相关的命令信息

### 高级调试技巧

+ 断点添加命令:在打完断点后,可以添加:br com add  "断点编号" ,添加断点触发时执行的命令,以DONE结束。

  + Xcode也可以在以下界面设置

    ![image-20181210112150668](https://ws1.sinaimg.cn/large/006tNbRwly1fy1hgwazbxj307h0je3zm.jpg)

    ![image-20181210111851191](https://ws1.sinaimg.cn/large/006tNbRwly1fy1hdud6uzj30dh08f0u5.jpg)

+ 使用Python脚本:

  + [chisel](https://github.com/facebook/chisel):Facebook的开源的LLDB命令工具,支持pviews,pvc等等命令。[wifi](https://github.com/facebook/chisel/wiki)
  + [LLDB](https://github.com/DerekSelander/LLDB):Derek Selander开源工具。
  + 脚本使用参考官方:http://lldb.llvm.org/python_reference/index.html

+ Xcode的Debug View Hierarchy:找到所在视图或者视图控制器的Address,再结合 chisel 的 methods "Adderss" 命令找到所要的方法Adress,就可以用br s -a Adress对方法下断点了。省略了,pviews、pvc 、presponder、hide、show等命令,是不是简单了许多~

  ​	![image-20181210155034059](https://ws3.sinaimg.cn/large/006tNbRwly1fy1p8hwgivj30jh06jaai.jpg)							

![image-20181210152911162](https://ws3.sinaimg.cn/large/006tNbRwly1fy1om8sr1qj30770agjs4.jpg)



+ Xcode 的Debug Memory Graph:查看对象的内存引用信息

  ![image-20181210164004837](https://ws3.sinaimg.cn/large/006tNbRwly1fy1qo09ixqj30jj06kjrr.jpg)

  + 可以查看对象的内存分配对象,需要在Xcode的Edit Scheme Diagnostics Malloc stack 上打勾。

    ![image-20181210165401439](https://ws1.sinaimg.cn/large/006tNbRwly1fy1r2jcu7ij30780c30tp.jpg)

  + 可以得到内存的实例对象

  + 可以得到内存地址所有被引用的地方,黑色线就是被引用的地方啦(理解程序的逻辑就一目了然呀)

       	![image-20181210165243902](https://ws4.sinaimg.cn/large/006tNbRwly1fy1r16a2fjj30jg0bajsi.jpg)



+ 像Cycript一样调用函数,但前面得加e , 例如: e [(MYView \*)0x103d05be0 setHidden:YES],输入c继续,然后就会看到MYView被隐藏掉啦。
+ 其他:
  + 查看当前模块:Debug - Debug Workflow - Shared Libraries选项
  + 查看地址的内存信息:Debug - Debug Workflow - View Momery选项
  + 动态调试中,要查看某个函数给别的函数调用的位置,可以先hook住这个函数,然后断言。就可以看到奔溃位置的函数调用啦,很方便~


### lldb使用思路

+ 用Cycript等工具找到方法内存地址,打断点,确认内存地址是否是正确的。
+ 找到想要的方法内存地址,也可以使用Cycript等工具。由[chisel](https://github.com/facebook/chisel)提供的脚本支持
+ 查看参数传递,或者引用关系,调用堆栈等执行流程。