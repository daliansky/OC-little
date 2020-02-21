# 电池热补丁

## 前言

**教程概要** : 由于苹果使用的 ACPI 规范和 DSDT 解析器与常规 PC 不同，无法读写 ACPI EC 中超过 8 位的 `FieldUnit`（字段单元），导致与电池相关的 `Method`（函数方法）无法正常使用（其中 `_BIF` 获取电池信息，`_BST` 获取电池状态），这时候，我们就需要运用 Hotpatch 方式修补 ACPI 来使 SMC 电池驱动正确传递 ACPI EC 信息给 macOS 来识别电池信息和状态。

> 与传统 DSDT 直接修补不同，Hotpatch 可以做到精准修补，不影响到其它代码。相对来说，Hotpatch 反编译时问题比较单一（添加外部引用声明即可解决），而传统 DSDT 修补反编译过程中有许多未知情况，且极容易破坏原有结构。随着 OpenCore 的流行，Hotpatch 的作用越来越明显，它不仅能让我们的硬件正确地工作在 macOS 上，还能在使用 OpenCore引 导其它系统的情况下不破坏原有 ACPI 结构（通过 `If(_OSI("Darwin"))` 的方法判断并进行方法回调或者参数回调），使得多个操作系统在共用同一套 ACPI 的情况下互不影响。

**实现原理** : 利用 ACPI 二进制更名使原 ACPI EC 中的相关 `Method`（函数方法）失效，并在新建的电池补丁中重新定义并修改代码实现电池信息的正确传递。

**技术要求** : 理解本教程需要一定的 ACPI 基础（请参考 OC-Little 中的总述部分），如果你是完全的新手，请自行补习一些编程方面的基础知识（包括基本运算原理，流程控制等）。

**必备工具** : MaciASL、HEX Fiend、Hackintool（可选）。

## Step 1 搜索和记录

> 修改 ACPI 的第一步就是先提取原始文件，我们可以利用 CLOVER 选择界面的 `F4` 快捷键提取，文件保存在 `ACPI/origin` 里面，这里面除了 DSDT 以外还有许多 SSDT 和其它的一些 ACPI 文件，通常我们需要用的就是 `DSDT` 和少数 `SSDT` 文件。大部分笔记本的 EC 代码在 `DSDT` 下，但也存在例外，如联想拯救者 14ISK/15ISK 的 EC 代码就在 `SSDT-1-CB-01` 中，本教程所使用的案例就是属于这种情况。

本教程的示例除了个别特殊情况均基于 `Sample` 文件夹中的 `DSDT.aml` 和 `SSDT-1-CB-01.aml` 进行修改，请自行对照参考。

首选，我们用maciASL打开对应的ACPI文件，先来大致了解下 `OperationRegion`（操作区）和 `Field`（字段）的语法。

```Swift
OperationRegion (RegionName, RegionSpace, Offset, Length)
```

- RegionName : 操作区名称。
- RegionSpace : 操作区命名空间，EC 的当然是 `EmbeddedControl`。
- Offset : 操作区内所有 Field 起始偏移量，通常为 `Zero`。
- Length : 操作区内所有 Field 的最大长度。

```Swift
Field (RegionName, AccessType, LockRule, UpdateRule) {FieldUnitList}
```

- RegionName : 操作区名称。
- AccessType : 访问类型，以 `ByteAcc` 为主。
- LockRule : 锁定规则，在 EC 对应的 Field 中，具备 Lock 属性的字段一般只有 1个 ，而 NoLock 属性的可能有多个或者没有。
- UpdateRule : 更新规则，用来指定如何处理未修改的字段位，通常为 `Preserve`，即维持原值。

### 一、搜索EC和字段名称

- 搜索 `EmbeddedControl` 关键字确认对应的 `OperationRegion` 名称，此为 EC 操作区的名称，通常为 `ERAM`、`ECF2`、`ECF3`、`ECOR` 等，并且有的机器可能不止一个。
- 根据 EC 操作区的名称搜索对应的 `Field`（字段）。

### 二、筛选字段单元

- 在每一个 EC 操作区的 `Field`（字段）里面筛选超过8位的 `FieldUnit`（字段单元）。
- 将这些字段单元按照所属的 Field（字段）分开记录名称和长度，并计算它们的偏移量，如果是几个连续的字段单元，只需要计算第一个的偏移量，因为相邻的都是按顺序进行操作的，不需要额外计算。
- 对于超过 32 位的字段单元只需要记录它的偏移量以及它对应的长度值，因为我们不需要手动拆分。
- 每记录下一个字段单元的信息，同时也要在该 ACPI 文件里面搜索是否存在被调用的情况并记录下来，没有被调用过的应移出清单，减少工作量。
- 如果某个字段单元被全局定义过，例如在根路径（`\`）或者（`\_SB`）路径下的 `Field` 里面有相同名字的 `FieldUnit`，那么当你搜索该字段单元被调用情况时应注意区分此处的调用是不是 EC 下的这一个，如果不是，说明此处调用使用的是全局定义，对 EC 没有影响，不需要记录下来。

### 三、计算偏移量

基本原则 : 每 8 位进 1，以十六进制表达 `Offset` 偏移量。

```Swift
...
Offset (0x60),
B1CH,   32, // 0x64
B2CH,   32, // 0x68
B1MO,   16, // 0x6A
B2MO,   16, // 0x6C
B1SN,   16, // 0x6E
B2SN,   16, // 0x70
B1DT,   16, // 0x72
B2DT,   16, // 0x74
B1CY,   16, // 0x76
...
Offset (0xC2),
BARC,   16, // 0xC4
BADC,   16, // 0xC6
BADV,   16, // 0xC8
BDCW,   16, // 0xCA
BDCL,   16, // 0xCC
BAFC,   16, // 0xCE
BAPR,   16, // 0xD0
B1CR,   16, // 0xD2
B1AR,   16, // 0xD4
...
```

### 四、整理记录

**16位** : `B1DT`，`B1CY`，`RTEP`，`BET2`，`B1TM`，`BAPV`，`BARC`，`BADC`，`BADV`，`BAFC`，`B1CR`

**32位** : `B1CH`

**大于32位** : `SMD0, 256`，`B1MA, 64`，`B2MA, 64`

**拆分字段单元并计算偏移量** :

```Swift
Offset (0x60),
BC0H,   8,
BC1H,   8,
BC2H,   8,
BC3H,   8,
Offset (0x70),
BDT0,   8,
BDT1,   8,
Offset (0x74),
BCY0,   8,
BCY1,   8,
Offset (0xAA),
RTP0,   8,
RTP1,   8,
B0ET,   8,
B1ET,   8,
Offset (0xB6),
BTM0,   8,
BTM1,   8,
B0PV,   8,
B1PV,   8,
Offset (0xC2),
BAC0,   8,
BAC1,   8,
BDC0,   8,
BDC1,   8,
BDV0,   8,
BDV1,   8,
Offset (0xCC),
BFC0,   8,
BFC1,   8,
Offset (0xD0),
BCR0,   8,
BCR1,   8
```

**涉及的 Method** :

- `_SB.PCI0.LPCB.H_EC.BAT1._BIF`
- `_SB.PCI0.LPCB.H_EC.BAT1._BST`
- `_SB.PCI0.LPCB.H_EC.VPC0.MHPF`
- `_SB.PCI0.LPCB.H_EC.VPC0.SMTF`
- `_SB.PCI0.LPCB.H_EC.VPC0.GSBI`
- `_SB.PCI0.LPCB.H_EC.VPC0.GBID`

## Step 2  制作电池补丁

### 常用工具方法（Method）

- `B1B2` : 用于 `16` 位字段单元拆分读取。
- `W16B` : 用于 `16` 位字段单元拆分写入。
- `B1B4` : 用于 `32` 位字段单元拆分读取。
- `RECB` : 用于 `32` 位以上字段单元读取（Read Embedded Controller Buffer，即读取 EC 缓冲区）。
- `WECB` : 用于 `32` 位以上字段单元写入（Write Embedded Controller Buffer，即写入 EC 缓冲区）。
- `RE1B` 和 `WE1B` : 从属方法，用于临时储存字段单元的值，分别负责单个 8 位字段单元的读取和写入操作。
- `RECB` 和 `WECB` 中的 EC 缓冲区实际就是指处于 EC 操作区内的 Field。

### 一、利用模板编写补丁

所有工具方法和基础 EC 路径的 Scope 均已写到了模板文件中，见 Sample 文件夹中的 ***SSDT-BATT.dsl***。

**使用此模板请务必修改 EC 路径为你笔记本的 ACPI EC 路径!**

在 EC 路径的 `Scope` 下，创建 `OperationRegion` 和 `Field`，将已经拆分并计算好偏移量的字段单元填入代码中，示例如下。

```Swift
OperationRegion (XCF3, EmbeddedControl, Zero, 0xFF)
Field (XCF3, ByteAcc, NoLock, Preserve)
{
    Offset (0x60),
    BC0H,   8,
    BC1H,   8,
    BC2H,   8,
    BC3H,   8,
    Offset (0x70),
    BDT0,   8,
    BDT1,   8,
    Offset (0x74),
    BCY0,   8,
    BCY1,   8,
    Offset (0xAA),
    RTP0,   8,
    RTP1,   8,
    B0ET,   8,
    B1ET,   8,
    Offset (0xB6),
    BTM0,   8,
    BTM1,   8,
    B0PV,   8,
    B1PV,   8,
    Offset (0xC2),
    BAC0,   8,
    BAC1,   8,
    BDC0,   8,
    BDC1,   8,
    BDV0,   8,
    BDV1,   8,
    Offset (0xCC),
    BFC0,   8,
    BFC1,   8,
    Offset (0xD0),
    BCR0,   8,
    BCR1,   8
}
```

上述代码中，`XCF3` 是为了区别于原始 DSDT 中的 `ECF3`，这么做主要是为了避免与原始 DSDT 中的定义发生冲突，同样我们对字段单元的拆分也要注意避免重复，比如我把 `BADC` 拆分为 `ADC0` 和 `ADC1`，应该在原始 DSDT 中搜索是否存在同样名字的 `FieldUnit`（字段单元）。

然后，对应我们之前记录的路径将需要修改的 `Method` 代码完整复制过来，注意大括号千万别复制错了，不然后面排查错误会很麻烦。

下面，我们利用搜索命令定位需要拆分的地方，根据下面的方法分别处理不同类型的字段单元。

### 二、修改 16 位字段单元拆分读取

**目的** : 将拆分后的两个 8 位字段单元数据整合返回给目标。

**原理** : 运用或运算以及位移运算将拆分后的两个 8 位字段单元数据转化为 16 位长度的数据。

**语法** :

```Swift
B1B2 (ECB1, ECB2)
```

- `ECB1`、`ECB2` 为你拆分后的两个8位字段单元名字，注意顺序。

**示例** :

原始语句：

```Swift
If ((^^PCI0.LPCB.EC0.BADC < 0x0C80))
```

一个比较判断语句，属于读取操作，修改如下：

```Swift

If ((B1B2 (^^PCI0.LPCB.EC0.ADC0, ^^PCI0.LPCB.EC0.ADC1) < 0x0C80))
```

### 三、修改 16 位字段单元拆分写入

**目的** : 将接收的数据分别赋值给拆分后的两个 8 位字段单元。

**原理** : 利用位移运算分别取 Obj 中的低 8 位和高 8 位数据分别赋予给 `xxx1` 和 `xxx2`。

**语法** :

```Swift
W16B (ECB1, ECB2，Obj)
```

- `ECB1`、`ECB2` 为你拆分后的两个 8 位字段单元名字，注意顺序。
- Obj 为被写入的值或者字段单元对象。

**示例** :

原始语句：

```Swift
SMW0 = Arg3
```

普通的赋值语句，属于写入数据操作，修改如下：

```Swift
W16B (MW00, MW01, Arg3)
```

### 四、修改32位字段单元拆分读取

**目的** : 将拆分后的 4 个 8 位字段单元数据整合返回给目标。

**原理** : 运用或运算以及位移运算将拆分后的 4 个 8 位字段单元数据转化为 32 位长度的数据。

**语法** :

```Swift
B1B4 (ECB1, ECB2, ECB3, ECB4)
```

- ECB1、ECB2、ECB3和ECB4为你拆分后的4个8位字段单元名字，注意顺序。

**示例** :

原始语句：

```Swift
If ((B1CH == 0x0050694C))
```

修改结果：

```Swift
If ((B1B4 (BC0H, BC1H, BC2H, BC3H) == 0x0050694C))
```

### 五、修改32位字段单元拆分写入（几乎没有见过这种情况）

### 六、修改32位以上字段单元读取

**目的** : 在已知原字段单元对应的偏移量和长度的情况，通过 `RECB` 读取虚拟地址的数据。

**原理** : 通过长度参数确定需要按顺序从偏移量开始读取几次8位字段单元数据，并以 `Buffer` 数组形式传递。

**语法** :

```Swift
RECB (Offset, Length)
```

- Offset为原字段单元的偏移量
- Length为原字段单元的长度

**示例** :

原始定义：

```Swift
Offset (0x8F),
B1MA,   64,
```

调用语句：

```Swift
IFMN = B1MA
```

修改结果：

```Swift
IFMN = RECB (0x8F, 0x40)
```

### 七、修改32位以上字段单元写入

**目的** : 在已知原字段单元对应的偏移量和长度的情况，通过 `WECB` 向虚拟地址写入数据。

**原理** : 用 `Arg2` 填充 `Temp` 数组，通过长度参数确定需要按顺序从偏移量开始逐个读取 `Temp` 并写入到虚拟地址中。

**语法** :

```Swift
WECB (Offset, Length, Obj)
```

- Offset为原字段单元的偏移量
- Length为原字段单元的长度
- Obj为被写入的值或者字段单元对象

**示例** :

原始定义：

```Swift
Offset (0x18),
SMPR,   8,
SMST,   8,
SMAD,   8,
SMCM,   8,
SMD0,   256,
```

调用语句：

```Swift
SMD0 = FB4
```

修改结果：

```Swift
WECB (0x1C, 0x0100, FB4) // 0x1C=0x18+0x04
```

### 八、添加外部引用声明

在确认修改结束后，我们需要点击编译查看报错情况，一般来说，这些错误是由于我们复制过来的代码引用了原始 ACPI 中的一些定义，而我们未添加外部引用声明而造成的，在这里我们只需要在补丁文件头部添加上即可解决大多数编译错误。

> 常见的外部引用声明类型如下，虚线上方为原始定义，虚线下方为对应类型的声明代码。

**Device** :

```Swift
Scope (_SB.PCI0.LPCB)
{
    Device (H_EC)
    {
-----------------------
External (_SB_.PCI0.LPCB.H_EC, DeviceObj)
```

**Method** :

```Swift
Method (_STA, 0, NotSerialized)  /* _STA: Status */
----------------------
External (_SB_.BAT0._STA, MethodObj)
```

**Mutex** :

```Swift
Mutex (BATM, 0x07)
----------------------
External (_SB_.PCI0.LPCB.H_EC.BATM, MutexObj)
```

**FieldUnit** :

```Swift
Field(...)
{
...
BCNT,   8,
...
}
----------------------
External (_SB_.PCI0.LPCB.H_EC.BCNT, FieldUnitObj)
```

**Integer** :

```Swift
Name (ECA2, Zero)
---------------------
External (_SB_.PCI0.LPCB.H_EC.ECA2, IntObj)
```

**Package** :

```Swift
Name (PBIF, Package (0x0D)
{
    One,
    0xFFFFFFFF,
    0xFFFFFFFF,
    One,
    0xFFFFFFFF,
    0xFA,
    0x96,
    0x0A,
    0x19,
    "BAT0",
    " ",
    " ",
    " "
})
---------------------
External (_SB_.BAT0.PBIF, PkgObj)
```

> 注意！添加外部引用声明时应注意路径和类型应严格对应。

### 九、添加 `_OSI` 判断

> OpenCore 在引导时对于任何系统都是加载的同一套 ACPI，我们应确保我们的补丁只对 macOS 生效，此时我们需要通过添加`If(_OSI("Darwin")){}` 判断的方法使其在其他系统下不生效，避免 OC 在引导其它系统时出现不必要的 ACPI 错误。

在已经完成的补丁文件中，在每一个 `Method` 的开始部分加上 `_OSI` 系统判断并在结尾处回调原始方法，示例如下：

```Swift
Method (_BIF, 0, NotSerialized)  // _BIF: Battery Information
{
    If (_OSI ("Darwin"))
    {
    ...
        Return (...)
    ...
    }
    Else
    {
        Return (XBIF ())
    }
}
```

以上述代码为例 ，`Else` 后面的代码为回调原始方法，如果原始方法没有出现 `Return` 语句，则可直接以 `XBIF()` 的方式回调；如果原始方法的代码中出现了 `Return` 语句，则在回调时也需要以 `Return` 形式回调原方法。

如果原始方法带参数则应该在回调时将参数传递过去，如下代码：

```Swift
Method (SMTF, 1, NotSerialized)
{
    If (_OSI ("Darwin"))
    {
        If ((Arg0 == Zero))
        {
            Return (B1B2 (B0ET, B1ET))
        }

        If ((Arg0 == One))
        {
            Return (Zero)
        }

        Return (Zero)
    }
    Else
    {
        Return (XMTF (Arg0))
    }
}
```

注意：ASL 语言中方法的参数是从 `Arg0` 开始的。

最后，因为需要回调原始方法，所以这里也需要补充外部引用声明，具体操作不再赘述。

## Step 3 进行 ACPI 二进制更名

### 一、更名 Method 使其失效

> Hotpatch 的原理是通过 ACPI 二进制更名使原来 ACPI 中的  Method失效，并在新的 SSDT 补丁中重新定义它，以方便我们直接修改里面的代码。

1. 用 MaciASL 查看补丁中修改的 `Method`，确认它们的参数个数以及是否可序列化（`NotSerialized` 和 `Serialized`）。
1. 用 HEX Fiend 打开 `DSDT.aml`（本教程的示例是 `SSDT-1-CB-01.aml`）

   - 同时按住 `command` + `F` 调出搜索框，切换到 `Text` 模式，输入要更名的 Method 名字。
   - 切换到 `HEX` 模式，此时刚刚输入的名字已经变成了十六进制代码，接下来我们需要在后面加上方法规则代码（参数个数+是否可序列   化），对应关系如下：
     - `Method(xxxx,a,N)` --> `xxxx` 的十六进制代码 + `a` 的十六进制代码，最后两位范围为 `00` - `07`
     - `Method(xxxx,b,S)` --> `xxxx` 的十六进制代码 + (`b+8`) 的十六进制代码，最后两位范围为 `08` - `0F`
     - 示例：

       ```Swift
       Method (MHPF,1,N) --> `4D485046 01`
       Method (BTST,2,S) --> `42545354 0A`
       ```

   - 在输入上述方法定义的完整十六进制代码后，按 Next 或 Previous 进行全文搜索，一般只会出现一个结果，该结果就是我们在 MaciASL 编辑器里面看到的原始方法定义。
   - 我们需要该方法更名为一个未被利用的名称，通常习惯以 `X` 替换第一个字母，只要不出现重复定义即可。
   - 切换回 `Text` 模式，将第一位改为 `X`，并再次切换为 `HEX` 模式，可以发现 `X` 对应的十六进制代码为 `58`，以后我们可以凭经验直接在 `HEX` 模式下修改。再次搜索，如果没有结果，证明该方法名没有被利用过，可以用于更名。
   - 当然如果要更名的 `Method` 里面存着多个除了第一位不一样其它三位一样情况时，也很容易应对，分别更名为 `X` 开头的和 `Y` 开头的就行，只要不出现重名的情况都是可以的，也就是说除了要避免与现有 `Method` 重名以外，也要避免更名后出现重名的情况。

1. 例如 `BTST,2,S` 更名为 `XTST,2,S` 最终 config 的更名应填：

   ```text
   Comment      change BTST,2,S to XTST
   Find         42545354 0A
   Replace      58545354 0A
   ```

### 二、检查Mutex是否已经置0

引用Rehabman大神的原话：

> Some DSDTs use Mutex objects with non-zero a SyncLevel.  Evidently, OS X has some difficulty with this part of the ACPI spec, either that or the DSDTs are, in fact, codec incorrectly and Windows is ignoring it.
>
> The common result of a non-zero SyncLevel is failure of methods at the point of Acquire on the mutext in question.  This can result in strange behavior, failed battery status, or other issues.

结合ACPI规范，我的理解如下（若用语有误请指出）：

> 有些机器的 `Mutex`（互斥体，用于处理多线程同步）对象的 `SyncLevel`（同步等级）不为 `0` ，而这种情况下 macOS 无法正常执行多线程同步，造成的结果是电池状态等可能无法获取（如果电池相关的 Method 处于不同的同步等级，在 macOS 下会造成数据获取的异常，出现 0% 的情况），此时应打上 `Mutex` 置 `0` 补丁来解决
>
> 目前所知道的绝大多数笔记本 ACPI 的 `Mutex` 都是默认置 `0` 的，但是对于一些联想品牌的笔记本，它们往往有几个 `Mutex` 的 `SyncLevel` 并不是 `0`，我们在完成电池补丁后应检查 `Mutex` 是否属于这种情况。OpenCore 没有 CLOVER 那样方便的补丁选项能直接将所有 `Mutex` 对象的同步等级修改为 `0`，这里我们需要利用 ACPI 二进制更名的方法实现置 `0`。

**具体方法如下** :

- 在当前使用的 DSDT 文件里搜索 `Mutex`，看出现的几个对象的 `SyncLevel` 是否为 `0`
- 以 `Mutex (BATM, 0x07)` 为例，先转换BATM为十六进制代码，得到 `42 41 54 4D`
- 在前后加上完整定义的十六进制代码，最终得到 `01 42 41 54 4D 07`
- 其中 `01` 代表 `Mutex`; `07` 则代表 `SyncLevel` 的 `0x07`，
- 我们的目的是使 `Mutex` 对象置 `0`，所以 config 的更名应填

  ```text
  Comment       Set Mutex BATM, 0x07 to 0x0
  Find          01 42 41 54 4D 07
  Repalce       01 42 41 54 4D 00
  ```

其它 `Mutex` 对象按照同样的方法处理即可。

## 总结

### 一些经验

- 对于没有用到的工具方法，可以从补丁中移除，减少补丁代码，例如 `W16B` 和 `WECB(WE1B)` 这类写入操作有些机器的 ACPI 不需要。
- 大多数调用的情况都是属于读取操作，而写入操作很少。
- 根据经验，同一个超过 32 位的字段单元通常只会被调用一次，尽管有些机器存在2次调用的情况，但分析代码可知，通常这两种调用不会同时进行（常见情况为当既有读取又有写入时，两种操作被控制语句限制只执行其中一种）。
- 根据经验观察，并非所有涉及到字段单元拆分的 `Method` 都需要修改代码，事实上，有些 `Method` 和电池没有太大的关系，即使不对其调用的超过 8 位字段单元进行拆分也没有影响，但是为了保险起见我们还是选择了全部拆分修复，由于这方面研究还不够透彻，还没有具体的方法确认到底哪些 `Method` 是不需要修改的，相信随着对 ACPI 的不断深入研究，将逐步填补这方面的空白，以尽可能缩小电池补丁的体积。

### 如何排查错误

- 当我们完成了所有的电池补丁后如果发现电池还是未能正确显示怎么办呢？
  - 这种情况通常是由于我们在制作补丁没有充分考虑重名情况导致的。
  - 打开 Hackintool，切换到日志选项卡，选择系统，点击下方的刷新按钮生成，搜索 `ACPI Error`，看是否出现了和 `EC` 相关的错误，如果有，那么极有可能是出现了重复定义造成的，这时候我们需要修改我们电池补丁中相关对象的名称避免重名。
- 如果出现电池在拔下外置电源的情况下变红该怎么办？
  - 这种情况同样需要排查 `ACPI Error`，通常这是由于其它 SSDT 缺失或者冲突造成 AC 适配器代码部分发生了异常，利用终端的 `grep` 命令在整个 `origin` 目录进行搜索一般能准确定位到问题，具体方法这里不作介绍，相对来说还是比较简单的。

## 结语

- 使用 ACPI Hotpatch 的方式制作电池补丁是一个优秀的解决方案，特别是通过 OpenCore 引导时，它能在保证 macOS 电池的正确显示的同时不影响其它系统。
- 由于本教程涉及到许多 ACPI 层面的基础知识以及一些编程思维，存在一些难以理解的地方是在所难免的，如果你想学习钻研，可以去参考下 OC-Little 中关于 ACPI 的知识。
- 本教程可能存在一些表达上不清楚或者错误的地方，敬请谅解。
- 对于本教程中出现的明显错误，请务必指出，我们将尽快更改，你的意见或许能帮助更多人理解和学习本教程。
- 教程中的示例文件请前往`GitHub`查看，地址为https://github.com/daliansky/OC-little。

## Thanks 鸣谢

- Guide using clover to hotpatch acpi and battery status hotpatch [@Rehabman](github.com/rehabman)
- 资料来源 :  tonymacx86, 黑果小兵的部落格, PCBeta 黑苹果论坛
