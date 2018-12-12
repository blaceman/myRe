# CaptainHook用法



### 基础设置

+ ## #import <CaptainHook/CaptainHook.h> 就可以用啦,很方便



### 用法

+ 声明一个类:在你使用CaptainHook之前必须先声明一个类。例子:

  ```objc
  #import <CaptainHook/CaptainHook.h> //导入头文件
  CHDeclareClass(NSString); //声明NSString类
  CHConstructor { //CHConstructor 表示在二进制被加载后,立即执行CHConstructor代码块的内容
    CHLoadLateClass(NSString);//加载NSString 类
  }
  ```



### 方法挂钩:

+ 先使用**CHMethod**声明一个函数,然后再用**CHHook**钩挂。例子:

  ```objective-c
  //标准方法挂钩
  #import <CaptainHook/CaptainHook.h> //导入头文件
  CHDeclareClass(NSString); //声明类
  CHMethod(2, void, NSString, writeToFile, NSString *, path, atomically, BOOL, flag)//声明一个方法来挂钩。参数1:代表两个参数相当于于CHMethod2(),参数2:为返回类型,参数3:为哪个类的方法,参数4:方法名,参数5:参数的类型,参数6:参数类型名字,参数7:第2个参数的方法名,参数7:参数类型,参数8:参数类型的名字
  {
      NSLog(@"Writing string to %@: %@", path, self);
      CHSuper(2, NSString, writeToFile, path, atomically, flag);//调用原来的实现
  }
  
  CHConstructor //
  {
      CHLoadClass(NSString);
      CHHook(2, NSString, writeToFile, atomically);//挂钩方法。
  }
  
  
  ```


+ CHDeclareMethod挂钩

  ```objective-c
  //覆盖,简单挂钩,无法控制挂钩的时机,也可以作为增加方法使用
  #import <CaptainHook/CaptainHook.h>
  CHDeclareClass(NSString);
  CHDeclareMethod(2, void, NSString, writeToFile, NSString *, path, atomically, BOOL, flag)
  {
      NSLog(@"Writing string to %@: %@", path, self);
      CHSuper(2, NSString, writeToFile, path, atomically, flag);
  }
  ```


+ 运行时注入新类:

   ```objc
  //可以使用CHRegisterClass宏在运行时创建新类：
  #import <CaptainHook/CaptainHook.h>
  CHDeclareClass(NSObject);
  CHDeclareClass(MyNewClass);
  CHMethod(0, id, MyNewClass, init)
  {
      if ((self = CHSuper(0, MyNewClass, init))) {
          NSLog(@"Initted MyNewClass");
      }
      return self;
  }
  
  CHConstructor
  {
      CHAutoreleasePoolForScope();
      CHLoadClass(NSObject);
      CHRegisterClass(MyNewClass, NSObject) {
          CHHook(0, MyNewClass, init);
      }//创建新类
      [CHAlloc(MyNewClass) autorelease];
  }
   ```

+ 其他

  + CHOptimizedMethod():挂钩实例方法

  + CHOptimizedClassMethod():挂钩类方法

  + CHPropertyRetainNonatomic()增加属性

     ```objective-c
    //增加属性
    @interface ViewController : NSObject
        @property (nonatomic,retain)NSString *newProperty;
    @end
        CHDeclareClass(ViewController)
        CHPropertyRetainNonatomic(ViewCOntroller,NSString*,newProperty,setNewProperty);
    
    CHConstructor{
        CHLoadLateClass(ViewController);
        CHHook0(ViewController,newProperty);
        CHHook1(ViewController,setNewProperty);
    }
        
     ```


### 简单用法总结:

+ 1.导入#import <CaptainHook/CaptainHook.h>头文件
+ 2.声明使用的类:CHDeclareClass() 
+ 3.CHConstructor{}来写加载的类(CHLoadLateClass())

+ 4.CHMethod()、CHOptimizedMethod()、CHOptimizedClassMethod()声明新函数
+ 5.CHConstructor{}下挂钩子(CHHook(),)
+ 6.CHSuper():调用原方法实现。