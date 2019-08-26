# 操作系统更名补丁(`谨慎使用`)

## `特别说明`

- 正常情况下，无需使用操作系统更名补丁。
- 受操作系统限制无法正常工作的一些设备（如 I2C 设备），尽可能根据其 ACPI 自身特点施加定制补丁。
- 使用操作系统补丁是不得已而为之，请`谨慎使用`。

## 操作系统补丁

见附件《操作系统补丁由来》；更名原理和方法见《ACPI二进制更名》。

## `操作系统更名补丁`

- `"Windows 2009"更名补丁`—Win7 补丁
- `"Windows 2012"更名补丁`—Win8 补丁
- `"Windows 2013"更名补丁`—Win8.1 补丁
- `"Windows 2015"更名补丁`—Win10 Build 10536 补丁
- `"Windows 2016"更名补丁`—Win10 Build 15086 补丁
- `"Windows 2017"更名补丁`—Win10 Build 16299 补丁
- `"Windows 2018"更名补丁`—Win10 Build 17134 补丁

### 示例（"Windows 2013”更名补丁）

更名前：

```Swift
    If (_OSI ("Windows 2013"))
    {
        OSYS = 0x07DD
    }
```

更名后：

```Swift
    If (_OSI ("Darwin"))
    {
        Noop
        Noop
        Noop
        Noop
        Noop
        Noop
        OSYS = 0x07DD
    }
```

### 正确选择 `操作系统更名补丁`

哪一个 `操作系统更名补丁` 正确，由 ACPI 的 `"Windows 20xx"` 具体位置决定。

- 正确位置：`"Windows 20xx"` 在一行语句的 `末端`。
- 错误位置：`"Windows 20xx"` 在一行语句的 `首端`。

如：

```Swift
    If ((_OSI ("Windows 2009") || _OSI ("Windows 2013")))
    {
        ...
    }
```

示例中，选择 `"Windows 2009"更名补丁` 将产生错误。选择 `"Windows 2013"更名补丁` 是正确的。

下面情况，`"Windows 2013"更名补丁` 同样正确有效。

更名前：

```Swift
    Name (WN81, "Windows 2013")
    Name (LINX, "Linux")
```

更名后：

```Swift
    Name (WN81, "Darwin")
    Noop
    Noop
    Noop
    Noop
    Noop
    Noop
    Name (LINX, "Linux")
```

### 对双系统的影响

如果机器中安装了 Windows 系统，并且 Windows 系统由 OC 引导，`操作系统更名补丁` 可能导致 Windows 工作异常。更换其他 `操作系统更名补丁` 以规避两种系统之间因彼此干扰而带来的风险。

- 规避原则：`操作系统更名补丁` 不等于 `Windows系统版本号`。比如：双系统中的 Windows 系统是 Win7，那么，`操作系统更名补丁` 应选择 `"Windows 2009"更名补丁` 以外的其他的、正确的更名补丁。

#### 使用注意事项

- DSDT中有多处 `"Windows 20xx"` 的，要一并更名，不可遗漏。
- 提取 `System DSDT` 文件，搜索 `Darwin`，确认已经正确更名。
- 如果你希望的 `操作系统更名补丁` 不在样本之列，请自行添加。

## 附件：操作系统补丁由来

### 描述

- 当系统加载时，ACPI 的 `_OSI` 会接收到一个参数，不同的系统，接收的参数不同，ACPI 执行的指令就不同。比如，系统是 **Win7**，这个参数是 `Windows 2009`，系统是 **Win8**，这个参数就是 `Windows 2012`。

  **注**：Win10 有多个版本，分别对应不同的参数。

  ACPI 还定义了 `OSYS`。`OSYS` 和上述参数关系如下：

  `OSYS = 0x07D9`: Win7 系统，即 `Windows 2009`。

  `OSYS = 0x07DC`: Win8 系统，即 `Windows 2012`。

  `OSYS = 0x07DD`: Win8.1 系统，即 `Windows 2013`。

  `OSYS = 0x07DF`: Win10 第一个版本，即 `Windows 2015`。

  ...

- 当加载的系统不被 ACPI 识别时，`OSYS` 被赋予默认值，这个值随机器不同而不同，有的代表 `Linux`，有的代表 `Windows2003`，有的是其他值。

- 不同的操作系统支持不同的硬件，比如 `Win8` 以上才支持 I2C 设备。

- 当加载 macOS 时，`_OSI` 接受的参数不会被 ACPI 识别，`OSYS` 被赋予了默认值。这个默认值通常小于 Win8 要求的值，显然 I2C 无法工作。这就需要补丁来纠正这种错误，操作系统补丁也源于此。
