# 原则

## 为读者去优化，而不是为了作者

代码库的生存期通常会延长，读代码的时间要比写代码的时间长。明确地选择为我们的普通软件工程师在代码库中阅读、维护和调试代码的体验而优化，而不是为编写代码而优化。例如，当代码片段中发生令人惊讶或不寻常的事情时，为读者留下注释提示是有价值的。

## 风格统一

我们的代码风格需要统一，不要一个工程里面出现多种代码风格。

## 样式规则必须发挥作用

样式规则的好处必须大到足以让工程师记住它。

------

# Example

这里举一个例子，作为全局参考。

下面是一个示例头文件，演示了@interface声明的正确注释和间距。

```
// GOOD:

#import <Foundation/Foundation.h>

@class Bar;

/**
 * A sample class demonstrating good Objective-C style. All interfaces,
 * categories, and protocols (read: all non-trivial top-level declarations
 * in a header) MUST be commented. Comments must also be adjacent to the
 * object they're documenting.
 */
@interface Foo : NSObject

/** The retained Bar. */
@property(nonatomic) Bar *bar;

/** The current drawing attributes. */
@property(nonatomic, copy) NSDictionary<NSString *, NSNumber *> *attributes;

/**
 * Convenience creation method.
 * See -initWithBar: for details about @c bar.
 *
 * @param bar The string for fooing.
 * @return An instance of Foo.
 */
+ (instancetype)fooWithBar:(Bar *)bar;

/**
 * Initializes and returns a Foo object using the provided Bar instance.
 *
 * @param bar A string that represents a thing that does a thing.
 */
- (instancetype)initWithBar:(Bar *)bar NS_DESIGNATED_INITIALIZER;

/**
 * Does some work with @c blah.
 *
 * @param blah
 * @return YES if the work was completed; NO otherwise.
 */
- (BOOL)doWorkWithBlah:(NSString *)blah;

@end
```

@implementation的正确注释和间距。

```
// GOOD:

#import "Shared/Util/Foo.h"

@implementation Foo {
  /** The string used for displaying "hi". */
  NSString *_string;
}

+ (instancetype)fooWithBar:(Bar *)bar {
  return [[self alloc] initWithBar:bar];
}

- (instancetype)init {
  // Classes with a custom designated initializer should always override
  // the superclass's designated initializer.
  return [self initWithBar:nil];
}

- (instancetype)initWithBar:(Bar *)bar {
  self = [super init];
  if (self) {
    _bar = [bar copy];
    _string = [[NSString alloc] initWithFormat:@"hi %d", 3];
    _attributes = @{
      @"color" : [UIColor blueColor],
      @"hidden" : @NO
    };
  }
  return self;
}

- (BOOL)doWorkWithBlah:(NSString *)blah {
  // Work should be done here.
  return NO;
}

@end
```

------

# 命名

名称应该在合理范围内尽可能具有描述性。遵循标准的 [Objective-C naming rules](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html).。

避免使用非标准缩写(包括非标准首字母缩写和首字母缩写)。不要担心节省水平空间，让新读者能够立即理解您的代码更为重要。例如:

```
// GOOD:

// Good names.
int numberOfErrors = 0;
int completedConnectionsCount = 0;
tickets = [[NSMutableArray alloc] init];
userInfo = [someObject object];
port = [network port];
NSDate *gAppLaunchDate;
// AVOID:

// Names to avoid.
int w;
int nerr;
int nCompConns;
tix = [[NSMutableArray alloc] init];
obj = [someObject object];
p = [network port];
```

## 分类

SDK 中会添加很多分类，分类的命名应该

1. 简明地划分功能，并应命名以描述该功能
2. 应该带有Growing前缀，以防和客户重复。
3. 不应该带有下划线，且满足驼峰命名法

正确写法✔️

```
@implementation UILabel (GrowingNode)  //说明是node相关的
@implementation UIView (GrowingXPath)
```

错误写法❌

```
@implementation UILabel (Node) 
@implementation UIView (Growing_xPath)
```

如果是我们自己的类，所创建的分类，则不用使用Growing前缀，因为类已经是带有前缀的了。

```
// GOOD:

/** This category extends a class that is not shared with other projects. */
@interface GrowingDataObject (Storage)
- (NSString *)storageIdentifier;
@end
```

## 前缀

前缀在Objective-C中通常需要避免全局命名空间中的命名冲突。类、协议、全局函数和全局常量通常应该使用前缀来命名，我们使用Growing。

```
// GOOD:

/** An example error domain. */
extern NSString *GrowingExampleErrorDomain;

/** Gets the default time zone. */
extern NSTimeZone *GrowingGetDefaultTimeZone(void);

/** An example delegate. */
@protocol GrowingExampleDelegate <NSObject>
@end

/** An example class. */
@interface GrowingExample : NSObject
@end
```

## 类名

类名(以及类别和协议名)应该以大写开始，并使用混合大小写来分隔单词。

我们同样使用 Growing 开头，例如：GrowingPushExManager

## 属性变量

- 格式

参考如下格式：

```
@property (nonatomic, copy) NSString *tutorialName; 
```

- 命名规范

应该尽可能的详细描述变量的用途，使人一眼看上去能够理解其作用

正确写法✔️

```
@property (nonatomic, copy) NSString *tutorialName;
```

错误写法❌

```
@property (nonatomic, strong) NSString *tutName;
@property (nonatomic, strong) NSString *tutorial;
```

- NSString使用copy修饰

对于属性NSString的声明，使用copy修饰，不要使用strong，为什么?即使你声明一个属性为NSString有人可能会传入一个NSMutableString的实例然后在你不注意的情况下改变它

正确写法✔️

```
@property (nonatomic, copy) NSString *tutorialName;
```

错误写法❌

```
@property (nonatomic, strong) NSString *tutorialName;
```

更多基本使用请参考 [Coding Guidelines for Cocoa](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CodingGuidelines/Articles/NamingIvarsAndTypes.html#//apple_ref/doc/uid/20001284-BAJGIIJE)

## 类构造方法

在使用类构造函数方法的地方，这些方法应该总是返回类型为 instancetype 而从不返回 id。这可以确保编译器正确推断出结果类型。

```
// GOOD:
@interface Airplane
+ (instancetype)airplaneWithType:(RWTAirplaneType)type;
@end
// AVOID:
@interface Airplane
+ (id)airplaneWithType:(RWTAirplaneType)type;
@end
```

## Objective-C方法名

方法和参数名通常以小写开始，然后使用混合大小写。

正确的大写应该被尊重，包括在名字的开头。例如 URL

```
// GOOD:

+ (NSURL *)URLWithString:(NSString *)URLString;
```

如果可能的话，方法名读起来应该像一个句子，这意味着您应该选择与方法名相关联的参数名。Objective-C方法名往往很长，但这样做的好处是，一段代码读起来就像散文，从而使许多实现注释变得不必要。

在第二个和后面的参数名中使用介词和连词，如“with”、“from”和“to”，仅在需要阐明方法的含义或行为时才使用。

```
// GOOD:

- (void)addTarget:(id)target action:(SEL)action;                          // GOOD; no conjunction needed
- (CGPoint)convertPoint:(CGPoint)point fromView:(UIView *)view;           // GOOD; conjunction clarifies parameter
- (void)replaceCharactersInRange:(NSRange)aRange
            withAttributedString:(NSAttributedString *)attributedString;  // GOOD.
```

返回一个对象的方法应该有一个以名词开头的名称来标识返回的对象:

```
// GOOD:

- (Sandwich *)sandwich;      // GOOD.

// AVOID:

- (Sandwich *)makeSandwich;  // AVOID.
```

访问器方法的名称应该与它正在获取的对象相同，但不应该以单词get作为前缀。例如:

```
// GOOD:

- (id)delegate;     // GOOD.

// AVOID:

- (id)getDelegate;  // AVOID.
```

当一个属性为BOOL型时，可以省略is前缀，其getter方法应该以is开头。

同时，点语法只应在访问属性时使用，调用方法时不要使用。

```
// GOOD:

@property(nonatomic, getter=isGlorious) BOOL glorious;
- (BOOL)isGlorious;

BOOL isGood = object.glorious;      // GOOD.
BOOL isGood = [object isGlorious];  // GOOD.

// AVOID:

BOOL isGood = object.isGlorious;    // AVOID.

// GOOD:

NSArray<Frog *> *frogs = [NSArray<Frog *> arrayWithObject:frog];
NSEnumerator *enumerator = [frogs reverseObjectEnumerator];  // GOOD.

// AVOID:

NSEnumerator *enumerator = frogs.reverseObjectEnumerator;    // AVOID.
```

有关Objective-C命名的更多细节，请参阅 [Apple’s Guide to Naming Methods](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CodingGuidelines/Articles/NamingMethods.html#//apple_ref/doc/uid/20001282-BCIGIJJF)。

这些指导原则仅适用于Objective-C方法。c++方法名继续遵循c++风格指南中设置的规则。

## 函数名


函数名应该以一个大写字母开头，并且每个新单词都有一个大写字母(即“驼峰大小写”或“帕斯卡大小写”)。

```
// GOOD:

static void AddTableEntry(NSString *tableEntry);
static BOOL DeleteFile(const char *filename);
```

因为Objective-C没有提供命名空间，所以非静态函数应该有一个前缀来最小化名称冲突的机会。

```
// GOOD:

extern NSTimeZone *GrowingGetDefaultTimeZone(void);
extern NSString *GrowingGetURLScheme(NSURL *URL);
```

## 变量名

变量名通常以小写字母开头，并使用混合大小写分隔单词。

实例变量有前导下划线。

```
_myInstanceVariable
_usernameTextField
```

## Static常量和Extern常量

对于static修饰的常量，我们应该 以k开头，并附带Growing字段，并附加该常量说明，尽可能简洁详细，不应该带下划线

正确写法✔️

```
static NSString * const kGrowingNormalEventPath = @"/v2/%@/ios/events?stm=%llu";
```

错误写法❌

```
static NSString *const growingSpecialCharactersString = @"_!@#$%^&*()-=+|\[]{},.<>/?";
static NSString *const GIO_UPLOAD_TEST_DOMAIN = @"<https://messages.growingio.com";>
static NSString *const OLD_APP_USER_ID = @"GIO_TOUCH_old_app_user_id";
static NSString *const SCHEME = @"growing.internal://";
```

------

# 类型和声明

## 方法声明

如示例所示，@interface声明中推荐的声明顺序是:属性、类方法、初始化器，最后是实例方法。类方法部分应该从任何方便的构造函数开始。

## 局部变量

在最窄的实际范围内声明变量，并接近它们的用途。初始化变量的声明。

```
// GOOD:

CLLocation *location = [self lastKnownLocation];
for (int meters = 1; meters < 10; meters++) {
  reportFrogsWithinRadius(location, meters);
}
```

有时，为了提高效率，在变量的使用范围之外声明它更合适。这个例子在for循环初始化外声明了meters，并且在每次循环中不必要地发送lastKnownLocation消息:

```
// AVOID:

int meters;                                         // AVOID.
for (meters = 1; meters < 10; meters++) {
  CLLocation *location = [self lastKnownLocation];  // AVOID.
  reportFrogsWithinRadius(location, meters);
}
```

## 无符号整数 NSUInteger 

除非匹配系统接口使用的类型，否则避免使用无符号整数。

当进行数学运算或使用无符号整数倒数到0时，会出现一些微妙的错误。在数学表达式中只依赖有符号整数，除非在系统接口中匹配NSUInteger。

```
// GOOD:

NSUInteger numberOfObjects = array.count;
for (NSInteger counter = numberOfObjects - 1; counter > 0; --counter)

// AVOID:

for (NSUInteger counter = numberOfObjects - 1; counter > 0; --counter)  // AVOID.
```

无符号整数可以用于标记和位掩码，不过通常NS_OPTIONS或NS_ENUM更合适。



## 大小不一致的类型

由于32位和64位构建的大小不同，避免使用long、NSInteger、NSUInteger和CGFloat类型，除非匹配系统接口。

类型long、NSInteger、NSUInteger和CGFloat的大小在32位和64位构建之间有所不同。在处理由系统接口公开的值时，使用这些类型是合适的，但是在大多数其他计算中应该避免使用它们。

```
// GOOD:

int32_t scalar1 = proto.intValue;

int64_t scalar2 = proto.longValue;

NSUInteger numberOfObjects = array.count;

CGFloat offset = view.bounds.origin.x;
// AVOID:

NSInteger scalar2 = proto.longValue;  // AVOID.
```

文件和缓冲区的大小通常超过32位限制，所以应该使用int64_t来声明它们，而不是使用long、NSInteger或NSUInteger。

## BOOL类型的规则判断

Objective-C使用YES和NO。因此true和false只能用于CoreFoundation、C或c++代码。因为nil解析为NO，所以没有必要在条件下对它进行比较。永远不要直接将某个值与YES进行比较，因为YES被定义为1，一个BOOL最多可以是8位。

正确写法✔️

```
// GOOD:
if (someObject) {}
if (![anotherObject boolValue]) {}
```

错误写法❌

```
// AVOID:
if (someObject == nil) {}
if ([anotherObject boolValue] == NO) {}
if (isAwesome == YES) {} // Never do this.
if (isAwesome == true) {} // Never do this.
```

## 枚举 Enum

在使用枚举时，建议使用新的类型规范，因为它具有更强的类型检查和代码完成功能。SDK现在包含一个宏来促进和鼓励使用固定的底层类型:NS_ENUM()

正确写法✔️

```
typedef NS_ENUM(NSInteger, GrowingCircleType) {
    GrowingCircleTypeNone       = 0,
    GrowingCircleTypeEventList  = 1 << 0,
    GrowingCircleTypeDragView   = 1 << 1,
    GrowingCircleTypeWeb        = 1 << 2,
    GrowingCircleTypeReplay     = 1 << 3,
    GrowingCircleTypeHeatMap    = 1 << 4,
};
```

错误写法❌

- 枚举名应该与枚举值前缀一致

```
typedef NS_ENUM(NSInteger, GrowingSentryError) {
    kGrowingSentryErrorUnknownError = -1,
    kGrowingSentryErrorInvalidDsnError = 100,
    kGrowingSentryErrorGrowingSentryCrashNotInstalledError = 101,
    kGrowingSentryErrorInvalidCrashReportError = 102,
    kGrowingSentryErrorCompressionError = 103,
    kGrowingSentryErrorJsonConversionError = 104,
    kGrowingSentryErrorCouldNotFindDirectory = 105,
    kGrowingSentryErrorRequestError = 106,
    kGrowingSentryErrorEventNotSent = 107,
};
```

GrowingSentryError 枚举不应该以 kGrowingSentryError 开头，应该就以 GrowingSentryError 作为前缀

- 左括号应该紧跟在 NS_ENUM(NSInteger, GrowingCircleType) 之后

```
typedef NS_ENUM(NSInteger, GrowingCircleType)
{//此处左括号应该紧跟 typedef NS_ENUM(NSInteger, GrowingCircleType) {
    GrowingCircleTypeNone       = 0,
    GrowingCircleTypeEventList  = 1 << 0,
    GrowingCircleTypeDragView   = 1 << 1,
    GrowingCircleTypeWeb        = 1 << 2,
    GrowingCircleTypeReplay     = 1 << 3,
    GrowingCircleTypeHeatMap    = 1 << 4,
};
```

- 旧的方式应该避免例如

```
// AVOID:
typedef enum {
    SDCycleScrollViewPageContolAlimentRight,
    SDCycleScrollViewPageContolAlimentCenter
} SDCycleScrollViewPageContolAliment;
```

------

# 注释

注释对于保持代码的可读性至关重要。下面的规则描述了应该注释什么以及注释的位置。但是请记住:虽然注释很重要，但最好的代码是自我文档化的。给类型和变量赋予合理的名称要比使用模糊的名称然后试图通过注释来解释要好得多。

------

## 文件注释

文件可以选择从其内容的描述开始。每个档案可包含下列项目，其顺序如下:

- 必要时使用许可证样板。为项目使用的许可证选择适当的样板。
- 必要时对文件内容的基本描述。

如果您对带有作者行的文件进行了重大更改，请考虑删除作者行，因为修订历史已经提供了更详细和准确的作者记录。

## 接口声明

每个重要的接口，无论是公共的还是私有的，都应该附带注释来描述其用途以及如何融入更大的框架。

注释应该用来记录类、属性、ivars、函数、类别、协议声明和枚举。

```
// GOOD:

/**
 * A delegate for NSApplication to handle notifications about app
 * launch and shutdown. Owned by the main app controller.
 */
@interface MyAppDelegate : NSObject {
  /**
   * The background task in progress, if any. This is initialized
   * to the value UIBackgroundTaskInvalid.
   */
  UIBackgroundTaskIdentifier _backgroundTaskID;
}

/** The factory that creates and manages fetchers for the app. */
@property(nonatomic) GTMSessionFetcherService *fetcherService;

@end
```

鼓励对接口使用 doxygen风格 的注释，因为Xcode会解析接口以显示格式化的文档。有各种各样的Doxygen命令;在项目中始终如一地使用它们。

如果您已经在文件顶部的注释中详细描述了接口，那么您可以简单地声明，“查看文件顶部的注释以获得完整的描述”，但是一定要有一些注释。

## 实现注释

提供注释来解释复杂的、微妙的或复杂的代码部分。

```
// GOOD:

// Set the property to nil before invoking the completion handler to
// avoid the risk of reentrancy leading to the callback being
// invoked again.
CompletionHandler handler = self.completionHandler;
self.completionHandler = nil;
handler();
```

有用时，还提供关于已考虑或已放弃的实现方法的注释。

行尾注释与代码之间应该至少间隔2个空格。如果在后面的行中有几个注释，将它们排列起来通常会更容易读懂。

```
// GOOD:

[self doSomethingWithALongName];  // Two spaces before the comment.
[self doSomethingShort];          // More spacing to align the comment.
```

## 二义性消除符号


为了避免歧义，在注释中使用反引号或竖条引用变量名和符号，而不是使用引号或内联命名符号。

在doxygen风格的注释中，最好使用monospace文本命令来划分符号，比如@c。

当一个符号是一个可能使句子读起来像结构不佳的普通单词时，区分有助于提供清晰性。一个常见的例子是count:

```
// GOOD:

// Sometimes `count` will be less than zero.
```

或者引用一些已经包含引号的东西

```
// GOOD:

// Remember to call `StringWithoutSpaces("foo bar baz")`
```

Doxygen格式也适用于标识符号。

```
// GOOD:

/** @param maximum The highest value for @c count. */
```

------

# C语言特征

## 宏

避免使用宏，特别是使用常量变量、枚举、XCode片段或C函数时。

宏使您看到的代码与编译器看到的代码不同。现代C语言不再需要对常量和实用函数使用宏。只有在没有其他解决方案时才应该使用宏。

如果需要宏，请使用唯一名称以避免编译单元中的符号冲突。如果可行的话，在使用宏后通过#undefined来限制范围。 

宏名称应该使用 SHOUTY_SNAKE_CASE -全大写字母，单词之间有下划线。

类函数宏可以使用C函数命名实践。不要定义看起来像C或Objective-C关键字的宏。

```
// GOOD:

#define GTM_EXPERIMENTAL_BUILD ...      // GOOD

// Assert unless X > Y
#define GTM_ASSERT_GT(X, Y) ...         // GOOD, macro style.

// Assert unless X > Y
#define GTMAssertGreaterThan(X, Y) ...  // GOOD, function style.
// AVOID:

#define kIsExperimentalBuild ...        // AVOID  像OC中的常量关键字

#define unless(X) if(!(X))              // AVOID  没有首字母大写，而且无法判断其含义
```

避免生成方法实现的宏，或生成日后在宏外部使用的变量声明的宏。宏不应该隐藏变量的声明位置和方式，从而使代码难以理解。

```
// AVOID:

#define ARRAY_ADDER(CLASS) \
  -(void)add ## CLASS ## :(CLASS *)obj toArray:(NSMutableArray *)array

ARRAY_ADDER(NSString) {
  if (array.count > 5) {              // AVOID -- where is 'array' defined?
    ...
  }
}
```

可接受的宏使用示例包括基于构建设置有条件地编译的断言 Assert 和调试日志宏 DEBUG ——它们通常不会编译为发布版本。

## 非标准扩展

除非另有说明，否则不能使用C/Objective-C的非标准扩展。

编译器支持各种不属于标准c的扩展，例如复合语句表达式(e.g. foo = ({ int x; Bar(&x); x })).

__attribute__ 是一个被批准的例外，因为它在Objective-C API规范中使用。

条件运算符的二进制形式 A ?: B 是一个被批准的例外。

------

# Cocoa和Objective-C特性

## Designated Initializer 标识

清楚地标识指定的 初始化方法 Designated Initializer 。

对于那些可能继承你的类的人来说，标识指定的 初始化方法 是很重要的。这样，它们只需要覆盖单个初始化方法(可能有多个)，以确保调用其子类的初始化方法。它还可以帮助将来调试类的人员在需要单步执行时理解初始化代码流。使用注释或NS_DESIGNATED_INITIALIZER宏来标识指定的初始化器。如果使用NS_DESIGNATED_INITIALIZER，请用NS_UNAVAILABLE标记不受支持的初始化器。

如何使用 [NS_UNAVAILABLE 与 NS_DESIGNATED_INITIALIZER](https://www.jianshu.com/p/5654942cd8f7)

## 覆盖 Designated Initializer

当编写一个子类，并需要一些 init… 方法时，请确保覆盖了父类的 init 方法。

如果未能覆盖父类的 init 方法，可能不会在所有情况下调用初始化器，从而导致难以发现的bug。

## 覆盖NSObject方法的放置

将覆盖对象的方法放在@implementation的顶部。

这通常适用于(但不限于)init…、copyWithZone:和dealloc方法。init… 一类的方法应该组合在一起，然后是其他典型的NSObject方法，如description、isEqual:和hash。

用于创建实例的便利类工厂方法可能位于NSObject方法之前。

## 初始化方法

不要在init方法中将实例变量初始化为0或nil;这样做是多余的。

新分配对象的所有实例变量都被初始化为0 (isa除外)，所以不要在init方法中，将变量重新初始化为0或nil。

## 头文件中的实例变量应该是@protected或@private

实例变量通常应该在实现文件中声明，或者通过属性自动合成。当在头文件中声明ivars时，它们应该标记为@protected或@private。

```
// GOOD:

@interface MyClass : NSObject {
 @protected
  id _myInstanceVariable;
}
@end
```

## 不要使用+new


不要调用NSObject类的new方法，也不要在子类中重写它。相反，使用+alloc和-init方法实例化保留的对象。

## 保持公共API简单

保持类简洁;避免 “kitchen-sink” 的API接口设计。如果一个方法不需要是公共的，请将它放在公共接口之外。

Kitchen-sink 的意思就是”无所不包，一应俱全”

与c++不同，Objective-C不区分公共方法和私有方法;任何消息都可以发送给一个对象。因此，要避免将方法放置在公共API中，除非它们实际上应该由类的使用者使用。这有助于减少他们在你没有预料到的情况下被调用的可能性。这包括从父类重写的方法。



## #import 和 #include

\#import Objective-C and Objective-C++ headers, and #include C/C++ headers.

C/C++ 头文件使用 #include导入其他 C/C++ 头文件，当在OC文件中导入 C/C++ 头文件时，可以使用 #import 防止重复导入。 C/C++ 头文件应该通过 #define 为自己添加保护措施。

## 对系统框架使用Umbrella Headers

为系统框架和系统库导入Umbrella Headers，而不是包含单个文件。

例如 <Foundation/Foundation.h> 就是一个 Umbrella Header ，而不是导入其子文件，例如<Foundation/NSArray.h>

虽然包含来自框架(如 Cocoa 或 Foundation )的单个系统头看起来很诱人，但实际上，如果包含顶级根框架，编译器的工作量会更少。根框架通常是预编译的，可以更快地加载。另外，记住对于Objective-C框架使用@import或#import而不是#include。



```
// GOOD:

@import UIKit;     // GOOD.
#import <Foundation/Foundation.h>     // GOOD.
// AVOID:

#import <Foundation/NSArray.h>        // AVOID.
#import <Foundation/NSString.h>
...
```

## 导入的排序

头文件导入的标准顺序是：

1. 项目中关联的头文件
2. 系统库头文件
3. 语言库头文件
4. 最后是其依赖的类头文件

使用空行来区分不同头文件的组，且每一组中，应该以字母顺序来排序。

```
// GOOD:

#import "ProjectX/BazViewController.h"

#import <Foundation/Foundation.h>

#include <unistd.h>
#include <vector>

#include "base/basictypes.h"
#include "base/integral_types.h"
#include "util/math/mathutil.h"

#import "ProjectX/BazModel.h"
#import "Shared/Util/Foo.h"
```

## 避免在初始化方法以及dealloc方法中对self进行操作

父类 初始化在 子类 初始化之前完成。在所有类都有机会初始化它们的实例状态之前调用self上的任何方法，调用都可能导致子类操作未初始化的实例状态。

类似的问题也出现在 dealloc 中，方法调用可能导致类对已释放的或者正在释放的对象进行操作。

直接访问其属性的实例变量，而不使用点语法，例如：

```
// GOOD:

- (instancetype)init {
  self = [super init];
  if (self) {
    _bar = 23;  // GOOD.
  }
  return self;
}
```

注意不要将 init 方法分解为 helper method:

因为hepler method可以在子类中被重写，可能是不小心，也可能是故意重写，当你编辑这个 helper method时，你可能并不知道它会从init中调用。

```
// AVOID:

- (instancetype)init {
  self = [super init];
  if (self) {
    self.bar = 23;  // AVOID.
    [self sharedMethod];  // AVOID. Fragile to subclassing or future extension.
  }
  return self;
}
// GOOD:

- (void)dealloc {
  [_notifier removeObserver:self];  // GOOD.
}

// AVOID:

- (void)dealloc {
  [self removeNotifications];  // AVOID.
}
```

## 为NSString的setter方法使用copy

NSString的setter应该总是复制它所接受的字符串。这通常也适用于像NSArray和NSDictionary这样的集合。

永远不要只retain一个NSString，因为它可能是一个NSMutableString。这样可以避免调用者在你不知情的情况下更改它。

对于集合类型，要考虑其可能可变，将其从原始副本copy一份是最安全的。

```
// GOOD:

@property(nonatomic, copy) NSString *name;

- (void)setZigfoos:(NSArray<Zigfoo *> *)zigfoos {
  // Ensure that we're holding an immutable collection.
  _zigfoos = [zigfoos copy];
}
```

## 使用轻量级泛型来记录包含的类型

所有在Xcode 7或更新版本上编译的项目都应该使用Objective-C轻量级泛型符号来类型包含的对象。

每个NSArray、NSDictionary或NSSet引用都应该使用轻量级泛型声明，以提高类型安全性并显式记录使用情况。

```
// GOOD:

@property(nonatomic, copy) NSArray<Location *> *locations;
@property(nonatomic, copy, readonly) NSSet<NSString *> *identifiers;

NSMutableArray<MyLocation *> *mutableLocations = [otherObject.locations mutableCopy];
```

如果完全加上后的类型变得复杂而冗长，可以考虑使用typedef来保持可读性。

```
// GOOD:

typedef NSSet<NSDictionary<NSString *, NSDate *> *> TimeZoneMappingSet;
TimeZoneMappingSet *timeZoneMappings = [TimeZoneMappingSet setWithObjects:...];
```

使用可用的最具描述性的通用父类或协议。在最常见的情况下，当不知道其他情况时，使用id将集合声明为显式异构。

```
// GOOD:

@property(nonatomic, copy) NSArray<id> *unknowns;
```

## 避免Throw Exceptions

不要@throw Objective-C异常，但是你应该准备好从第三方或OS调用捕获它们。

这遵循了 [Apple’s Introduction to Exception Programming Topics for Cocoa](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Exceptions/Exceptions.html) 中建议使用错误对象来传递错误的建议。

我们确实使用-fobjc-exception进行编译(主要是为了得到@synchronized)，但是我们没有使用@throw。当需要正确使用第三方代码或库时，可以使用@try、@catch和@finally。如果您确实使用了它们，请准确地记录您希望抛出的方法。

Objective-C提供了对于异常处理和线程同步的支持。在GNU编译器（GCC）3.3或以上版本上使用-fobjc-exceptions指令，可以支持以上特性。

异常处理机制是由这个四个关键字支持的：@try，@catch，@thorw，@finally

线程同步是：@synchronized

## 对nil发送消息的检查

避免这种对 nil 发送消息的检查。对一个 nil 对象发送消息是安全的，更应该关注是否越界等问题。

向nil发送消息将返回nil作为指针，你可以参考 [这篇文章](http://www.sealiesoftware.com/blog/archive/2012/2/29/objc_explain_return_value_of_message_to_nil.html) 查看，对nil发送消息时的返回值类型。

```
// AVOID:

if (dataSource) {  // AVOID.
  [dataSource moveItemAtIndex:1 toIndex:0];
}
// GOOD:

[dataSource moveItemAtIndex:1 toIndex:0];  // GOOD.
```

这仅仅适用于对nil发送消息检查，对于参数是否为nil，则还是需要进行判断。

还要注意，这和 C/ C++指针和block指针是否为NULL是不同的，如果运行时不处理这些指针，将导致应用程序崩溃。你仍然需要确保没有引用空指针。



## Nullability

接口可以使用nullability注释来修饰，以描述应该如何使用接口及其行为。可以使用nullability区域(例如NS_ASSUME_NONNULL_BEGIN和NS_ASSUME_NONNULL_END)和显式的nullability注释。最好使用_Nullable和_Nonnull关键字，而不是 __nullable 和 __nonnull。对于Objective-C方法和属性，更喜欢使用上下文敏感的、非下划线的关键字，例如nonnull和nullable

```
// GOOD:

/** A class representing an owned book. */
@interface GTMBook : NSObject

/** The title of the book. */
@property(readonly, copy, nonnull) NSString *title;

/** The author of the book, if one exists. */
@property(readonly, copy, nullable) NSString *author;

/** The owner of the book. Setting nil resets to the default owner. */
@property(copy, null_resettable) NSString *owner;

/** Initializes a book with a title and an optional author. */
- (nonnull instancetype)initWithTitle:(nonnull NSString *)title
                               author:(nullable NSString *)author
    NS_DESIGNATED_INITIALIZER;

/** Returns nil because a book is expected to have a title. */
- (nullable instancetype)init;

@end

/** Loads books from the file specified by the given path. */
NSArray<GTMBook *> *_Nullable GTMLoadBooksFromFile(NSString *_Nonnull path);
// AVOID:

NSArray<GTMBook *> *__nullable GTMLoadBooksFromTitle(NSString *__nonnull path);
```

## BOOL陷阱

在将一般整数值转换为BOOL时要小心。避免直接与YES进行比较。

BOOL在OS X和32-bit iOS中被定义为带符号的char 类型，所以它的值可能不是YES(1)和NO(0).不要直接转换或转换一般整数值到BOOL。

常见的错误包括将数组的大小、指针值或按位逻辑操作的结果强制转换为BOOL，根据整数值最后一个字节的值，BOOL仍然可能导致无值。在将一般整数值转换为BOOL时，使用三元运算符返回YES或NO值。

您可以安全地交换和转换BOOL、_Bool和bool (see C++ Std 4.7.4, 4.12 and C99 Std 6.3.1.2)。在Objective-C方法签名中使用BOOL。

将逻辑运算符(&&，||和!)与BOOL一起使用也是有效的，并且将返回可以安全地转换为BOOL的值，而不需要三元运算符。

```
// AVOID:

- (BOOL)isBold {
  return [self fontTraits] & NSFontBoldTrait;  // AVOID.
}
- (BOOL)isValid {
  return [self stringValue];  // AVOID.
}
// GOOD:

- (BOOL)isBold {
  return ([self fontTraits] & NSFontBoldTrait) ? YES : NO;
}
- (BOOL)isValid {
  return [self stringValue] != nil;
}
- (BOOL)isEnabled {
  return [self isValid] && [self isBold];
}
```

另外，不要直接将BOOL变量与YES进行比较。不仅对于精通C语言的人来说，它更难阅读，而且上面的第一点说明了返回值可能并不总是您所期望的。

```
// AVOID:

BOOL great = [foo isGreat];
if (great == YES) {  // AVOID.
  // ...be great!
}
// GOOD:

BOOL great = [foo isGreat];
if (great) {         // GOOD.
  // ...be great!
}
```

------

# 间距和格式

## 空格和制表符

只使用空格，一次缩进2个空格。我们使用空格来缩进。不要在代码中使用制表符。

您应该将编辑器设置为在按tab键时发出空格，并修剪行尾的空格。

对于Xcode，默认就设置tab为4个空格

## 单位行长度

Objective-C文件的最大行长度是100列。

通过Xcode设置：Preferences > Text Editing > Page guide at column: 100 in Xcode.

## 方法声明和定义

在-或+和返回类型之间使用一个空格，参数列表中除了参数之间不使用空格。

```
// GOOD:

- (void)doSomethingWithString:(NSString *)theString {
  ...
}
```

如果方法声明不能放在一行中，请将每个参数放在它自己的一行中。

除第一行外，所有行至少缩进四个空格。参数前的冒号应该在所有行上对齐。如果方法声明的第一行参数前的冒号的位置使得冒号对齐会导致后面一行的缩进少于4个空格，那么冒号对齐只对除第一行之外的所有行对齐。

```
// GOOD:

- (void)doSomethingWithFoo:(GTMFoo *)theFoo
                      rect:(NSRect)theRect
                  interval:(float)theInterval {
  ...
}

- (void)shortKeyword:(GTMFoo *)theFoo
            longerKeyword:(NSRect)theRect
    someEvenLongerKeyword:(float)theInterval
                    error:(NSError **)theError {
  ...
}

- (id<UIAdaptivePresentationControllerDelegate>)
    adaptivePresentationControllerDelegateForViewController:(UIViewController *)viewController;

- (void)presentWithAdaptivePresentationControllerDelegate:
    (id<UIAdaptivePresentationControllerDelegate>)delegate;
```

## 函数声明和定义

最好将返回类型与函数名放在同一行，并将所有参数附加在同一行中(如果合适的话)。

包装不适合一行的参数列表，就像在函数调用中包装参数一样。

```
// GOOD:

NSString *GTMVersionString(int majorVersion, minorVersion) {
  ...
}

void GTMSerializeDictionaryToFileOnDispatchQueue(
    NSDictionary<NSString *, NSString *> *dictionary,
    NSString *filename,
    dispatch_queue_t queue) {
  ...
}
```

函数的声明和定义还应满足以下条件:

- 开括号”(”必须始终与函数名在同一行上。
- 如果不能在一行中显示返回类型和函数名，请在它们之间换行，不要缩进函数名。
- 开括号”(”前不能有空格。
- 函数括号”(””)”和参数之间不应该有空格。
- 左大括号”{“总是在函数声明的最后一行的末尾，而不是下一行的开始。
- 右大括号”}“要么在最后一行上，要么在同一行上。
- 左大括号”{“和右括号”)”之间应该有空格。
- 如果可能的话，应该对齐所有参数。
- 函数的代码内容”...“应该缩进2个空格。
- 包装参数应该有4个空格的缩进。



## 条件语句

在if、while、for、switch和比较运算符（例如”><=“）之后包含空格。

```
// GOOD:

for (int i = 0; i < 5; ++i) {
}

while (test) {};
```

当条件语句或者循环体可以和条件一起单条显示时，可以省略大括号。

```
// GOOD:

if (hasSillyName) LaughOutLoud();

for (int i = 0; i < 10; i++) {
  BlowTheHorn();
}

// AVOID:

if (hasSillyName)
  LaughOutLoud();               // AVOID.

for (int i = 0; i < 10; i++)
  BlowTheHorn();                // AVOID.
```

如果If子句有else子句，两个子句都应该使用大括号。

```
// GOOD:

if (hasBaz) {
  foo();
} else {  // The else goes on the same line as the closing brace.
  bar();
}
// AVOID:

if (hasBaz) foo();
else bar();        // AVOID.

if (hasBaz) {
  foo();
} else bar();      // AVOID.
```

## Switch语句

case语句不需要大括号，但当内容行数>=2行时，需要使用大括号

```
switch (condition) {
  case 1:
    // ...
    break;
  case 2: {
    // ...
    // Multi-line example using braces
    break;
  }
  case 3:
    // ...
    break;
  default: 
    // ...
    break;
}
```

当使用枚举类型进行switch时，不需要break语句

```
// AVOID:
RWTLeftMenuTopItemType menuType = RWTLeftMenuTopItemMain;

switch (menuType) {
  case RWTLeftMenuTopItemMain:
    // ...
    break;
  case RWTLeftMenuTopItemShows:
    // ...
    break;
  case RWTLeftMenuTopItemSchedule:
    // ...
    break;
}
```

如果是fall-through，透传到下个条件判断，则需要加上注释内容，表明这是一个有意的行为。

```
// GOOD:

switch (i) {
  case 1:
    ...
    break;
  case 2:
    j++;
    // Falls through.
  case 3: {
    int k;
    ...
    break;
  }
  case 4:
  case 5:
  case 6: break;
}
```

## 表达式


在二元运算符和赋值周围使用空格。省略一元运算符的空格。不要在括号内添加空格。

一元运算符有1个操作数，例如：++、--、

二元运算符有2个操作数，例如：+、-、*、/

```
// GOOD:

x = 0;
v = w * x + y / z;
v = -y * (x + z);
```

表达式中的因子也可以省略空格

```
// GOOD:

v = w*x + y/z;
```

## 方法调用

方法调用的格式应该类似于方法声明。

当需要选择格式化样式时，请遵循在给定源文件中已经使用的约定。调用应该将所有参数放在一行上:

```
// GOOD:

[myObject doFooWith:arg1 name:arg2 error:arg3];
```

或者每行有一个参数，冒号对齐:

```
// GOOD:

[myObject doFooWith:arg1
               name:arg2
              error:arg3];
```

不要出现以下这些风格:

```
// AVOID:

[myObject doFooWith:arg1 name:arg2  // some lines with >1 arg
              error:arg3];

[myObject doFooWith:arg1
               name:arg2 error:arg3];

[myObject doFooWith:arg1
          name:arg2  // aligning keywords instead of colons
          error:arg3];
```

与声明和定义一样，当第一个关键字比其他的短时，后面的行缩进至少4个空格，保持冒号对齐:

```
// GOOD:

[myObj short:arg1
          longKeyword:arg2
    evenLongerKeyword:arg3
                error:arg4];
```

## 函数调用

函数调用应该包含尽可能多的参数，除非需要更短的行以保持清晰或记录参数。

函数参数的连续行可以缩进以与开括号对齐，也可以使用四空格缩进。

```
// GOOD:

CFArrayRef array = CFArrayCreate(kCFAllocatorDefault, objects, numberOfObjects,
                                 &kCFTypeArrayCallBacks);

NSString *string = NSLocalizedStringWithDefaultValue(@"FEET", @"DistanceTable",
    resourceBundle,  @"%@ feet", @"Distance for multiple feet");

UpdateTally(scores[x] * y + bases[x],  // Score heuristic.
            x, y, z);

TransformImage(image,
               x1, x2, x3,
               y1, y2, y3,
               z1, z2, z3);
```

使用具有描述性名称的局部变量来缩短函数调用并减少调用嵌套。

```
// GOOD:

double scoreHeuristic = scores[x] * y + bases[x];
UpdateTally(scoreHeuristic, x, y, z);
```

## 异常 Exceptions

Exceptions 格式化，@catch和@finally标签与前面的“}”相同的一行。在”@”标签和左括号”{“之间以及在@catch和caught对象声明之间添加空格。如果必须使用Objective-C异常，请按照以下格式对其进行格式化。

```
// GOOD:

@try {
  foo();
} @catch (NSException *ex) {
  bar(ex);
} @finally {
  baz();
}
```

## 函数长度

偏向于精简的函数。

长函数和方法有时是合适的，因此对函数长度没有硬性限制。如果一个函数超过40行，请考虑是否可以在不损害程序结构的情况下将其分解。

即使您的长函数现在工作得很好，但有人在几个月后修改它可能会添加新的行为。这可能会导致难以发现的bug。保持函数简短可以使其他人更容易阅读和修改代码。

在更新遗留代码时，还应考虑将长函数分解为更小、更易于管理的片段。

# 单例写法

单例对象应该使用线程安全的模式来创建它们的共享实例。

```
+ (instancetype)sharedInstance {
    static id sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });

    return sharedInstance;
}
```