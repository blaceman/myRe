# cycript 用法大全

### Cycript的介绍、原理

+ Cycript是由Cydia创始人[Saurik](:https://git.saurik.com/cycript.git)推出的一款脚本语言，Cycript 混合了Objective-C与javascript语法的解释器，这意味着我们能够在一个命令中用Objective-C或者javascript，或者两者兼用。

+ 利用Libffi、JavaScriptCore实现native代码和解释代码的桥接




### Cycript使用

+ 根据new Instance根据地址获取对象，和直接使用#号获取对象

  ```javascript
  cy# var btn = #0x10102e630
  #"<UIButton: 0x10102e630; frame = (30 30; 100 100); opaque = NO; layer = <CALayer: 0x170225b00>>"
  cy# var bt1 = new Instance(0x10102e630)
  #"<UIButton: 0x10102e630; frame = (30 30; 100 100); opaque = NO; layer = <CALayer: 0x170225b00>>"
  ```


+ choose传递一个类，可以在内存中找出属于这个类的对象

  ```javascript
  cy# choose(UIButton)
  [#"<UIButton: 0x10102e630; frame = (30 30; 100 100); opaque = NO; layer = <CALayer: 0x170225b00>>"]
  ```



+ 使用NSLog

  ```javascript
  NSLog_ = dlsym(RTLD_DEFAULT, "NSLog")
  NSLog = function() { 
     var types = 'v', args = [], count = arguments.length;
     for (var i = 0; i != count; ++i) {
        types += '@';
        args.push(arguments[i]);
    } 
    new Functor(NSLog_, types).apply(null, args);
  }
  ```


+ 还有许多集成等等集成到一个[文件](https://raw.githubusercontent.com/blaceman/myRe/master/cy/myMd.cy)

  ```javascript
  (function(utils) {
  
      utils.constants = {
          APPID:  	 NSBundle.mainBundle.bundleIdentifier, //id
          APPPATH:     NSBundle.mainBundle.bundlePath,  //资源路径
          APPHOME:	 NSHomeDirectory(), //沙盒
          APPDOC:      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],
          APPLIBRARY:  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0],
          APPCACHE:    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
      };
  
      utils.pviews = function(){
          return UIApp.keyWindow.recursiveDescription().toString(); //打印视图层次
      };
  
      utils.pvcs = function(){ //打印当前控制器
          return UIWindow.keyWindow().rootViewController._printHierarchy().toString();
      };
  
      utils.rp = function(target){//打印响应者 nextResponder
          var result = "" + target.toString();
          while(target.nextResponder){
              result += "\n" + target.nextResponder.toString();
              target = target.nextResponder;
          }
          return result;
      };
  
        utils.pactions = function(target){ //打印actionsForTarget;
          var result = '';
          var objs = target.allTargets.allObjects();
          for(var i = 0; i < objs.length; i++){
              var actions = [target actionsForTarget:objs[i] forControlEvent:0];
              result += objs[i] + " " + [actions componentsJoinedByString:@","];
          }
          return result;
      }
  
  
      utils.loadFramework = function (target) { //加载资源路径
          var h="/System/Library/",t="Frameworks/"+target+".framework";
          return [[NSBundle bundleWithPath:h+t]||
          [NSBundle bundleWithPath:h+"Private"+t] load];
      }
  
  
      utils.tryPrintIvars = function tryPrintIvars(a){ //打印属性 或者*实例对象
          var x={}; 
          for(i in *a)
              { 
                  try{ x[i] = (*a)[i]; } catch(e){} 
              } 
          return x; 
          } 
  
  
      utils.printMethods = function printMethods(className, isa) { //打印方法,第一个传类对象字符串,第二个可不传。
          var count = new new Type("I");
          var classObj = (isa != undefined) ? objc_getClass(className)->isa :     
          objc_getClass(className); 
          var methods = class_copyMethodList(classObj, count); 
          var methodsArray = [];
          for(var i = 0; i < *count; i++) { 
              var method = methods[i]; 
              methodsArray.push({selector:method_getName(method),     
              implementation:method_getImplementation(method)});
      }
          free(methods); 
          return methodsArray;
  }
  
  
    
  
      for(var k in utils.constants) { //引入时打印对象变量
          Cycript.all[k] = utils.constants[k];
      }
  
      for(var k in utils) {//引入时打印对象方法
          if(utils.hasOwnProperty(k)) {
              var f = utils[k];
              if(typeof f === 'function') {
                  Cycript.all[k] = f;
              }
          }
      }
  })(exports);
  ```

+ 越狱手机cycript挂钩进程:

  ```javascript
  cycript -p 进程id(ps ax | grep Cycript 查看进程id)
  ```

+ cycript支持加载自己的脚本,把cy文件放进/var/root/下

  + cycript -p 进程id(名) /var/root/utils.cy
  + cycript -p 进程id(名)

+ monkeyDev Cycript挂钩,monkeyDev运行成功后会打印挂钩信息。

  + **./cycript -r 192.168.1.105(手机IP):6666(端口)**  

+ monkeyDev 网络加载cy文件

  + ![image-20181207174155909](https://ws2.sinaimg.cn/large/006tNbRwly1fxybmh7wpjj30yb0llgsm.jpg)
    + LoadAtLaunch:是否默认加载到cycript坏境中,对于monkeyDev的ms、md文件起作用,自己的的网络cy文件没有效果,要自己@import myMD(key名)导入。
    + priority:优先级
    + url:网络的cy文件
    + content:cy脚本

+ cycript逆向思路(本地验证):

  + pviews()查看视图层次
  + (#0x10102e630(内存地址)).hidden = YES 确定按钮位置
  + pactions(#0x10102e630)  打印targetAction
  + 手动调用targetAction查看效果
  + ....
  + rp(#0x10102e630)打印响应者 nextResponder
  + 然后printMethods(@"类名")查找方法名
  + 找到可疑的方法,调用,查看是否是想要的效果(要猜)