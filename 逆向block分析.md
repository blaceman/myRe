# 逆向block分析

### block的结构

```objc
struct __block_impl{
      /**
  block在内存中也是类NSObject的结构体，
  结构体开始位置是一个isa指针
  */
    
  Class isa;
      /** 这两个变量暂时不关心 */
  int flags;
  int reserved;
      /**
  真正的函数指针！！
  */
  void (*invoke)(...);
  ...
}
```

+ 说明下block中的isa指针，根据实际情况会有三种不同的取值，来表示不同类型的block。其中第2种block在运行时才会出现，我们只关注1、3两种，下面就分析这两种isa指针和block符号地址之间的关联

  + _NSConcreteStackBlock:栈上的block，一般block创建时是在栈上分配了一个block结构体的空间，然后对其中的isa等变量赋值

  + _NSConcreteMallocBlock:堆上的block，当block被加入到GCD或者被对象持有时，将栈上的block复制到堆上，此时复制得到的block类型变为了_NSConcreteMallocBlock

  + _NSConcreteGlobalBlock:全局静态的block，当block不依赖于上下文环境，比如不持有block外的变量、只使用block内部的变量的时候，block的内存分配可以在编译期就完成，分配在全局的静态常量区。
