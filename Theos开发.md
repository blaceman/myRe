# Theos开发

### 语法:

+ %hook:hook住一个classs,必须以%end结尾。例子:

  ```objective-c
  %hook MYView
  - (void)buttonAction:(id)sender{
  	%orig(@"我的button");
  }
   %end
  ```

+ %orig:执行原来的函数实现,此外，还可以利用`%orig`更改原始函数的参数。例子如上:

+ %log:打印

+ %ground:将`%hook`分组,不属于某个自定义group的`%hook`都会被隐式归类到`%group_ungrouped`中。例子:

  ```go
  group iOS1Hook 
  %hook iOS1Class 
  - (id)iOS1Method {
      id result = %orig;
      NSLog(@"This class & method only exist in iOS 1.");
      return result;
  }
  - (id)iOS2Method {
      id result = %orig;
      NSLog(@"This class & method only exist in iOS 1.");
      return result;
  }
  %end
  %end // iOS1Hook 
  
  %hook SpringBoard 
  -(void)powerDown {
      %orig; 
  }
  %end //%group_ungrouped
  ```

+ %init:该指令用于初始化某个`%group`，必须在`%hook`或`%ctor`内调用,参数为%group名,默认是group_ungrouped。例子:

  ```go
  - (void)applicationDidFinishLaunching:(id)application {
      %orig;
      %init; // Equals to %init(_ungrouped) 
      if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0 &&
          kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_8_0) 
          %init(iOS7Hook);
          
      if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0) 
          %init(iOS8Hook); 
  }
  %end
  ```

+ %ctor:tweak的constructor，完成初始化工作；如果不显示定义，Theos会自动生成一个`%ctor`，并在其中调用`%init(_ungrouped)`,如果需要默认调用其他%group或者MSHookFunction就要显示调用:

  ```go
  #ifndef kCFCoreFoundationVersionNumber_iOS_8_0
  #define kCFCoreFoundationVersionNumber_iOS_8_0 1140.10 
  #endif
  %ctor
  {
      %init;
      if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0 && 
          kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_8_0) 
          %init(iOS7Hook);
      if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0) 
          %init(iOS8Hook); 
      
      MSHookFunction((void *)&AudioServicesPlaySystemSound, 
                     (void *)&replaced_AudioServicesPlaySystemSound, 
                     (void **)&original_AudioServicesPlaySystemSound); 
  }
  ```


 + %c :生成一个对象。例子:

   ```go
   MYView  *myView = [[%c(MYView) alloc]init];
   ```

 + %new:给一个类增加方法。 其中v@:@代表v:void @:调用者	(:):SEL @:参数类型。例子:

   ```go
   %new(v@:@) 
   - (void)printMessage:(NSString )message{
       
   };	
   
   ```

+ 如果需要用到源代码的属性或者方法,可以自己新建一个类的.h文件,把属性和方法申明到.h文件,就可以愉快的用啦。

+ 其他的参考[wifi](http://iphonedevwiki.net/index.php/Logos)

### 安装:[iOS逆向工程之Theos](https://www.cnblogs.com/ludashi/p/5714095.html)



