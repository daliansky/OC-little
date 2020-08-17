# ASL 语言基础

> 本教程转载自远景论坛，发布于 2011-11-21 11:16:20，作者为：suhetao。
>
> 由 Bat.bat(williambj1) 于 2020-2-14 重新排版为 Markdown，并对部分内容进行了添加及修正。
>
> <http://bbs.pcbeta.com/forum.php?mod=viewthread&tid=944566&archive=2&extra=page%3D1&page=1>

## 写在前面的话

鄙人不是一个主板 BIOS 开发工作者，以下对 ASL 的理解仅仅来源于 ~~<http://www.acpi.info/>~~ [注: 已失效, 文档已转移至 <https://uefi.org>] 上的 ACPI Specification 文档。因此难免会出现不少错误的理解，以及错误的观点，希望大家谅解以及纠正。

## 简述

首先，不得不说一下 DSDT (Differentiated System Description Table Fields) 和 SSDT (Secondary System Description Table Fields) 什么是 DSDT 和 SSDT 呢？其实它们都属于 ACPI 其中的一个表格，而 ACPI 是 Advanced Configuration & Power Interface 的缩写，高级配置和电源接口，从文字上就可以理解 ACPI 是一系列的接口，这个接口包含了很多表格，所以 DSDT 和 SSDT 既是其中的表格同时也是一些接口。所以不难想象 ACPI 主要的功能就是提供操作系统一些服务以及提供一些讯息给操作系统使用。DSDT 和 SSDT 自然也不例外。ACPI 的一个特色就是专有一门语言来编写 ACPI 的那些表格。它就是 ASL (ACPI Source Language) 也就是这盘文章的主角，ASL 经过编译器编译后，就变成了 AML (ACPI Machine Language)，然后由操作系统来执行。既然 ASL 是一门语言，那就有它的准则。

## ASL 准则

1. 变量命名不超过 4 个字符，且不能以数字开头。联想一下看到过的 DSDT 代码看看，绝对不会超过。

1. Scope 形成作用域，概念类似于数学中的集合 `{}`。有且仅有一个根作用域，所以 DSDT 都以

   ```swift
   DefinitionBlock ("xxxx", "DSDT", 0x02, "xxxx", "xxxx", xxxx)
   {
   ```

   开始，同时以

   ```swift
   }
   ```

   结束。这个就是根作用域.

   `xxxx` 参数依次表示输出 `文件名`、`OEMID`、`表ID`、`OEM版本`。第三个参数根据第二个参数指定，如上面所示。如果是 **`DSDT`** 就一定是 `0x02`，其他参数都可以自由修改。

1. 以 `_` 字符开头的函数和变量都是系统保留的，这就是为什么反编译某些AML以后得到的 ASL 出现 `_T_X`，重新编译的时候会出现警告。

1. `Method` 定义函数，函数可以定义在 `Device` 下或者 `Scope` 下，但是不能脱离 `Scope` 定义单独的函数，所以**不会有** 以下这种情况出现。

   ```swift
   Method (xxxx, 0, NotSerialized)
   {
       ...
   }
   DefinitionBlock ("xxxx", "DSDT", 0x02, "xxxx", "xxxx", xxxx)
   {
       ...
   }
   ```

1. 根作用域 `\` 下有 `\_GPE`，`\_PR`，`\_SB`，`\_SI`，`\_TZ` 五个作用域。

   - `\_GPE`--- ACPI 事件处理
   - `\_PR` --- 处理器
   - `\_SB` --- 所有的设备和总线
   - `\_SI` --- 系统指示灯
   - `\_TZ` --- 热区，用于读取某些温度

   > **不同属性的东西放在对应的作用域下。例如:**

   - 设备 `Device (PCI0)` 放在 `Scope (\_SB)` 里面

     ```swift
     Scope (\_SB)
     {
         Device (PCI0)
         {
             ...
         }
         ...
     }
     ```

   - CPU 相关的信息放在 `Scope (_PR)`

     > 不同的 CPU 所在的域会不同，常见的有 `_PR`，`_SB`，`SCK0` 等

     ```swift
     Scope (_PR)
     {
         Processor (CPU0, 0x00, 0x00000410, 0x06)
         {
             ...
         }
         ...
     }
     ```

   - `Scope (_GPE)` 放着相关的事件处理

      ```swift
      Scope (_GPE)
      {
          Method (_L0D, 0, NotSerialized)
          {
              ...
          }
          ...
      }
      ```

      乍一看不是函数吗？当然函数也可以放在这里。但是请注意函数名 **`_`** 开头的是系统保留的函数。

1. `Device (xxxx)` 也可看做是一个作用域，里面包含对设备的各种描述，例如 `_ADR`、`_CID`、`_UID`、`_DSM`、`_STA` 等对设备的说明和状态控制

1. 符号 `\` 引用根作用域，`^` 引用上级作用域，同理 `^^` 为 `^` 的上级作用域

1. 符号 `_` 本身没有任何意义，在 ASL 中只用于补齐位置，如 `_OSI` 的 `_` 用于补齐 `Method` 名称所需的四个字符

1. ACPI 为了更好理解，规范后来使用了新的 ASL 语法 ASL 2.0 (也叫做 ASL+), 新语法引入了与 C 语言等同的 `+-*/=`, `<<`, `>>` 和逻辑判断 `==`, `!=` 等等

1. 函数最多可以传递 7 个参数，在函数里用 `Arg0`~`Arg6` 表示，不可以自定义。

1. 函数最多可以用 8 个局部变量，用 `Local0`~`Local7`，不用定义，但是需要初始化才能使用，也就是一定要有一次赋值操作。

## ASL 常用的数据类型

|    ASL    |   中文   |
| :-------: | :------: |
| `Integer` |   整数   |
| `String`  |  字符串  |
|  `Event`  |   事件   |
| `Buffer`  |   数组   |
| `Package` | 对象集合 |

## ASL 定义变量

- 定义整数

  ```swift
  Name (TEST, 0)
  ```

- 定义字符串
  
  ```swift
  Name (MSTR,"ASL")
  ```

- 定义 Package

  ```swift
  Name (_PRW, Package (0x02)
  {
      0x0D,
      0x03
  })
  ```

- 定义 Buffer Field

  > Buffer Field 一共有 6 种，分别是

|     创建语句     |   大小   |
| :--------------: | :------: |
|  CreateBitField  |  1-Bit   |
| CreateByteField  |  8-Bit   |
| CreateWordField  |  16-Bit  |
| CreateDWordField |  32-Bit  |
| CreateQWordField |  64-Bit  |
|   CreateField    | 任意大小 |

  ```swift
  CreateBitField (AAAA, Zero, CCCC)
  CreateByteField (DDDD, 0x01, EEEE)
  CreateWordField (FFFF, 0x05, GGGG)
  CreateDWordField (HHHH, 0x06, IIII)
  CreateQWordField (JJJJ, 0x14, KKKK)
  CreateField (LLLL, Local0, 0x38, MMMM)
  ```

可以发现定义变量的时候不需要显式声明其类型

## ASL 赋值方法

赋值方法有且仅有一个

```swift
Store (a,b) /* 传统 ASL */
b = a      /*   ASL+  */
```

例子:

```swift
Store (0, Local0)
Local0 = 0

Store (Local0, Local1)
Local1 = Local0
```

## ASL 运算函数

|  ASL+  |  传统 ASL  |  中文含义  | 举例                                                         |
| :----: | :--------: | :--------: | :----------------------------------------------------------- |
|   +    |    Add     |  整数相加  | `Local0 = 1 + 2`<br/>`Add (1, 2, Local0)`                    |
|   -    |  Subtract  |  整数减法  | `Local0 = 2 - 1`<br/>`Subtract (2, 1, Local0)`               |
|   *    |  Multiply  |  整数相乘  | `Local0 = 1 * 2`<br/>`Multiply (1, 2, Local0)`               |
|   /    |   Divide   |  整数除法  | `Local0 = 10 / 9`<br/>`Divide (10, 9, Local1(余数), Local0(结果))` |
|   %    |    Mod     |  整数求余  | `Local0 = 10 % 9`<br/>`Mod (10, 9, Local0)`                  |
|   <<   | ShiftLeft  |    左移    | `Local0 = 1 << 20`<br/>`ShiftLeft (1, 20, Local0)`           |
|   >>   | ShiftRight |    右移    | `Local0 = 0x10000 >> 4`<br/>`ShiftRight (0x10000, 4, Local0)` |
|   --   | Decrement  | 整数自减 1 | `Local0--`<br/>`Decrement (Local0)`                          |
|   ++   | Increment  | 整数自增 1 | `Local0++`<br/>`Increment (Local0)`                          |
|   &    |    And     |   整数于   | `Local0 = 0x11 & 0x22`<br/>`And (0x11, 0x22, Local0)`        |
| &#124; |     Or     |     或     | `Local0 = 0x01`&#124;`0x02`<br/>`Or (0x01, 0x02, Local0)`  |
|   ~    |    Not     |    取反    | `Local0 = ~(0x00)`<br/>`Not (0x00,Local0)`                   |
|   无   |    Nor     |    异或    | `Nor (0x11, 0x22, Local0)`                                   |

等等，具体请查阅 ACPI Specification

## ASL 逻辑运算

|  ASL+  |   传统 ASL    |   中文含义   | 举例                                                         |
| :----: | :-----------: | :----------: | :----------------------------------------------------------- |
|   &&   |     LAnd      |    逻辑与    | `If (BOL1 && BOL2)`<br/>`If (LAnd(BOL1, BOL2))`              |
|   !    |     LNot      |    逻辑反    | `Local0 = !0`<br/>`Store (LNot(0), Local0)`                  |
| &#124; |      LOr      |    逻辑或    | `Local0 = (0`&#124;`1)`<br/>`Store (LOR(0, 1), Local0)`    |
|   <    |     LLess     |   逻辑小于   | `Local0 = (1 < 2)`<br/>`Store (LLess(1, 2), Local0)`         |
|   <=   |  LLessEqual   | 逻辑小于等于 | `Local0 = (1 <= 2)`<br/>`Store (LLessEqual(1, 2), Local0)`   |
|   >    |   LGreater    |   逻辑大于   | `Local0 = (1 > 2)`<br/>`Store (LGreater(1, 2), Local0)`      |
|   >=   | LGreaterEqual | 逻辑大于等于 | `Local0 = (1 >= 2)`<br/>`Store (LGreaterEqual(1, 2), Local0)` |
|   ==   |    LEqual     |   逻辑相等   | `Local0 = (Local0 == Local1)`<br/>`If (LEqual(Local0, Local1))` |
|   !=   |   LNotEqual   |  逻辑不等于  | `Local0 = (0 != 1)`<br/>`Store (LNotEqual(0, 1), Local0)`    |

不难发现逻辑运算只会有两种结果 `0` 或者 `1`

## ASL 函数的定义

1. 定义函数

   ```swift
   Method (TEST)
   {
       ...
   }
   ```

1. 定义有两个输入参数的函数，以及使用局部变量 `Local0`~`Local7`

   参数个数如果不定义默认是 `0`

   ```swift
   Method (MADD, 2)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1
   }
   ```

   实现了两个参数的加法运算，因此传入的参数一定要隐式整形数。

1. 定义带返回值的函数
  
   ```swift
   Method (MADD, 2)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1

       Return (Local0) /* 在此处返回 */
   }
   ```

   例子为自定义加法的实现。函数实现的是如同系统函数 Add 一样的相加

   ```swift
   Local0 = 1 + 2            /* ASL+ */
   Store (MADD (1, 2), Local0)  /* 传统 ASL */
   ```

1. 定义可序列化的函数

   如果不定义 `Serialized` 或者 `NotSerialized` 默认为 `NotSerialized`

   ```swift
   Method (MADD, 2, Serialized)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1
       Return (Local0)
   }
   ```

   这个有点类似于多线程同步的概念，也就是说，当函数声明为 `Serialized`，内存中仅能存在一个实例。一般应用在函数中创建一个对象。应用举例说明：

   ```swift
   Method (TEST, Serialized)
   {
       Name (MSTR,"I will sucess")
   }
   ```

   如果这样子声明 `TEST` 这个函数，那么在两个地方同时调用这个函数

   ```swift
   Device (Dev1)
   {
        TEST ()
   }
   Device (Dev2)
   {
        TEST ()
   }
   ```

   如果先执行 `Dev1` 的 `TEST`, `Dev2` 中的 `TEST` 将等待 `Dev1` 中的 `TEST` 函数执行完毕再执行。如果声明为

   ```swift
   Method (TEST, NotSerialized)
   {
       Name (MSTR, "I will sucess")
   }
   ```

   那么将在其中一个 `Devx` 调用 `TEST` 的时候，另外一个调用试图创建相同的字符串 `MSTR` 就会失败。

## ACPI 预定义函数

### `_OSI`  (Operating System Interfaces 操作系统接口)

通过调用 `_OSI` 函数，我们可以不费吹灰之力知道当前系统运行的是什么系统，轻而易举地区分 Windows 和 macOS，从而为某个系统创建单独的补丁。

`_OSI` 函数需要输入一个参数，这个参数必须是一个操作系统定义的用于识别的字符串

|                 操作系统                  |      字符串      |
| :---------------------------------------: | :--------------: |
|                   macOS                   |    `"Darwin"`    |
| Linux<br/>(包括基于 Linux 内核的操作系统) |    `"Linux"`     |
|                  FreeBSD                  |   `"FreeBSD"`    |
|                  Windows                  | `"Windows 20XX"` |

> 与其它操作系统不同的是，每个 Windows 版本都有不同的字符串，参阅：
>
> <https://docs.microsoft.com/en-us/windows-hardware/drivers/acpi/winacpi-osi>

当 `_OSI` 内的参数对应了当前操作系统时，`_OSI` 就会返回 `1`，`If` 条件语句判断成立

```swift
If (_OSI ("Darwin")) /* 判断当前的系统是不是 macOS */
```

### `_STA` (Status 状态)

**注意⚠️: `_STA` 分为两种，请勿与 `PowerResource` 的 `_STA` 混淆！！！**

`_STA` 方法的返回值最多包含 5 个 Bit，每个 Bit 的含义如下

| Bit 位  | 含义                           |
| :-----: | :----------------------------- |
| Bit [0] | 设备是否存在                   |
| Bit [1] | 设备是否被启用且可以解码其资源 |
| Bit [2] | 设备是否在 UI 中显示           |
| Bit [3] | 设备是否正常工作               |
| Bit [4] | 设备是否存在电池               |

看完上面的表可能就有人要问了，“我们平时见到的 `_STA` 都是 `0x0F`，`Zero`”，和这些 Bit 有啥关系？其实只要把 16进制 值转换成 2 进制自然就一目了然了。`0x0F` 的意思是前四个 Bit 都为 `1`，等于是完全启用，反之 `Zero` 就是完全禁用。

那么有时候遇到的 `0x0B`，`0x1F` 又是什么呢？**`SSDT-PNLF`** 里面的 `0x0B` 转成 2 进制 是 `1011`，也就是说设备处于一个半开的状态，不允许解码其中的资源。`0x1F` 只会在笔记本的电池设备中出现，多出的那一个 Bit 用于通知 电池控制设备 (Control Method Battery Device `PNP0C0A`) 设备存在电池。

> 这里再啰嗦一句 `PowerResource` 的 `_STA`
>
> `PowerResource` 的 `_STA` 只有两个返回值 `One` 和 `Zero`，有兴趣可以查阅 ACPI 规范，作用不再赘述

### `_CRS` (Current Resource Settings 当前资源设置)

`_CRS` 函数返回的是一个 `Buffer`，在触摸设备中会返回触摸设备所需的 `GPIO Pin`，`APIC Pin` 等等，可以控制设备的中断模式。

## ASL 流程控制

和常见的高级编程语言一样，ASL 也有与之对应的控制流程语句。

- Switch
  - Case
  - Default
  - BreakPoint
- While
  - Break
  - Continue
- If
  - Else
  - ElseIf
- Stall

### 分支控制 `If` 和 `Switch`

#### `If`

   例如下面的语句判断一下当前系统的接口是不是 `Darwin`，如果是把 `OSYS = 0x2710`

   ```swift
   If (_OSI ("Darwin"))
   {
       OSYS = 0x2710
   }
   ```

#### `ElseIf`, `Else`

   下面的例子中如果系统结构不是 `Darwin`，另外如果系统不是 `Linux`，那么 `OSYS = 0x07D0`

   ```swift
   If (_OSI ("Darwin"))
   {
       OSYS = 0x2710
   }
   ElseIf (_OSI ("Linux"))
   {
       OSYS = 0x03E8
   }
   Else
   {
       OSYS = 0x07D0
   }
   ```

#### `Switch`, `Case`, `Default`, `BreakPoint`

   ```swift
   Switch (Arg2)
   {
       Case (1) /* 条件 1 */
       {
           If (Arg1 == 1)
           {
               Return (1)
           }
           BreakPoint /* 条件判断不符合，退出 */
       }
       Case (2) /* 条件 2 */
       {
           ...
           Return (2)
       }
       Default /* 如果都不符合，则 */
       {
           BreakPoint
       }
   }
   ```

   `Switch` 可以看做是一系列 `If...Else` 的集合。`BreakPoint` 相当于断点，意味着退出当前 `Swtich`

### 循环控制

#### `While` 以及暂停 `Stall`

```swift
Local0 = 10
While (Local0 >= 0x00)
{
    Local0--
    Stall (32)
}
```

`Local0` 等于 `10`,如果 `Local0` 逻辑不等于 `0` 不为真，`Local0` 自减 `1`,暂停 `32μs`, 所以这段代码延时 `10 * 32 = 320 μs`。

#### `For`

ASL 中的 For 循环和 `C`, `Java` 中的如出一辙

```swift
for (local0 = 0, local0 < 8, local0++)
{
    ...
}
```

上面的 `For` 循环和下面的 `While` 是等效的

```swift
Local0 = 0
While (Local0 < 8)
{
    Local0++
}
```

## 外部引用 `External`

|    引用类型    | 中文(仅供参考) | 外部 SSDT 引用                                | 被引用                                                                  |
| :------------: | :------------: | :-------------------------------------------- | :---------------------------------------------------------------------- |
|   UnknownObj   |      未知      | `External (\_SB.EROR, UnknownObj`             | (只有 iasl 无法判断类型时才会出现，请避免使用)                          |
|     IntObj     |      整数      | `External (TEST, IntObj`                      | `Name (TEST, 0)`                                                        |
|     StrObj     |     字符串     | `External (\_PR.MSTR, StrObj`                 | `Name (MSTR,"ASL")`                                                     |
|    BuffObj     |      缓冲      | `External (\_SB.PCI0.I2C0.TPD0.SBFB, BuffObj` | `Name (SBFB, ResourceTemplate ()`<br/>`Name (BUF0, Buffer() {"abcde"})` |
|     PkgObj     |       包       | `External (_SB.PCI0.RP01._PRW, PkgObj`        | `Name (_PRW, Package (0x02) { 0x0D, 0x03 })`                            |
|  FieldUnitObj  |    字段单元    | `External (OSYS, FieldUnitObj`                | `OSYS,   16,`                                                           |
|   DeviceObj    |      设备      | `External (\_SB.PCI0.I2C1.ETPD, DeviceObj`    | `Device (ETPD)`                                                         |
|    EventObj    |      事件      | `External (XXXX, EventObj`                    | `Event (XXXX)`                                                          |
|   MethodObj    |      函数      | `External (\_SB.PCI0.GPI0._STA, MethodObj`    | `Method (_STA, 0, NotSerialized)`                                       |
|    MutexObj    |     互斥体     | `External (_SB.PCI0.LPCB.EC0.BATM, MutexObj`  | `Mutex (BATM, 0x07)`                                                    |
|  OpRegionObj   |     操作区     | `External (GNVS, OpRegionObj`                 | `OperationRegion (GNVS, SystemMemory, 0x7A4E7000, 0x0866)`              |
|  PowerResObj   |    电源资源    | `External (\_SB.PCI0.XDCI, PowerResObj`       | `PowerResource (USBC, 0, 0)`                                            |
|  ProcessorObj  |     处理器     | `External (\_SB.PR00, ProcessorObj`           | `Processor (PR00, 0x01, 0x00001810, 0x06)`                              |
| ThermalZoneObj |     温控区     | `External (\_TZ.THRM, ThermalZoneObj`         | `ThermalZone (THRM)`                                                    |
|  BuffFieldObj  |     缓冲区     | `External (\_SB.PCI0._CRS.BBBB, BuffFieldObj` | `CreateField (AAAA, Zero, BBBB)`                                        |

> DDBHandleObj 几乎不可能遇到因此这里不讨论

在 SSDT 中外部引用时，使用 `External (` + `路径和名称` + `,` + `引用类型)`，把光标定位到被引用 Object 里之后 MaciASL 会在左下角显示路径

## ASL 存在性判断语句 CondRefOf

`CondRefOf` 是 ASL 中一个非常实用的函数，可以用来判断所有类型 Object 的存在与否

```swift
Method (SSCN, 0, NotSerialized)
{
    If (_OSI ("Darwin"))
    {
        ...
    }
    ElseIf (CondRefOf (\_SB.PCI0.I2C0.XSCN))
    {
        If (USTP)
        {
            Return (\_SB.PCI0.I2C0.XSCN ())
        }
    }

    Return (Zero)
}
```

上面的代码节选自 **`SSDT-I2CxConf`**，在启动非 macOS 的系统时，如果 `I2C0` 下面存在 `XSCN` (原为 `SSCN`，已被被重命名成 `XSCN`，创建一个新的函数并使用原来的名称 `SSCN`)，则返回原来函数返回的值

## 结语

累了，今天就写到这里，有了这些基础，鄙人觉得现在大家对着 DSDT，SSDT 的时候就不会是发呆又发呆，至少可以明白些少语句了。
