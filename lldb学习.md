# lldb动态调试学习



### 准备工作(越狱)

+ 越狱真机调试后在/Developer/usr/bin下找到debugserver

+ 复制debugserver到mac上

+ x新建entitlements.plist文件,签名权限:codesign -s - --entiltilements.plist -f debugserver

   ```plist
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
+ 根据进程名或id:debugserver  *:1234 -a Snapchat(731)  
+ 然后mac终端输入lldb进去lldb界面
+ 然后(iproxy 1234 1234)process connect connect://localhost:1234或process connect connect:手机ip地址:1234  进行连接就ok



### lldb常用命令

+ image list -o -f:      [序列号] + 模块基地址 +  路径(真正加载的地址)  
   + 这里说明一下:  内存的真实地址 =  模块的基地址 + ida或hopper
+ b 内存地址: 或  br s -a 内存地址:      下断点
+ c: 继续
+ po :打印对象
+   \$x0 - \$x7: 为寄存器调用的参数, 如果是OC对象$x0为调用对象,$x1为调用方法。
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

