# ACPIDebug说明

## 描述

通过在 ***SSDT-xxxx*** 补丁里添加调试代码，能够在控制台上看到补丁或者 ACPI的工作过程，用于调试补丁。

## 要求

- 驱动
  - 安装 ***ACPIDebug.kext*** 至 `OC\Kexts`，并添加驱动列表。
- 补丁
  - 添加主补丁 ***SSDT-RMDT*** 至 `OC\ACPI`，并添加补丁列表。
  - 添加 ***自定义补丁*** 至 `OC\ACPI`，并添加补丁列表。

## 调试

- 打开 **控制台** ，搜索 **`关键字`** （ **`关键字`** 来自 ***自定义补丁*** ）
- 观察控制台输出结果

## 示例

- 目的

  - 观察机器睡眠、唤醒后， `ACPI` 的 `_PTS`、`_WAK` 接收 `Arg0` 的情况。

- 驱动和补丁

  - ***ACPIDebug.kext*** ——见前文

  - ***SSDT-RMDT*** ——见前文

  - ***SSDT-PTSWAK*** ——补丁内置了参数传递变量 `\_SB.PCI9.TPTS`、`\_SB.PCI9.TWAK` ，方便其他补丁使用。参见《PTSWAK综合扩展补丁》

  - ***SSDT-BKeyQxx-Debug*** ——本补丁只是范例。补丁内添加了调试代码，能够在按键响应后执行调试代码。实际使用时可以指定亮度快捷键，或者其他按键。

    **注**：以上补丁所要求的更名在对应补丁文件的注释里。

- 观察控制台输出结果

  - 打开控制台，搜索 `ABCD-`

  - 完成一次睡眠、唤醒过程

  - 按下 ***SSDT-BKeyQxx-Debug*** 指定的键，观察控制台输出结果。一般情况下，显示结果如下：

    ```log
    13:19:50.542733+0800  kernel  ACPIDebug: { "ABCD-_PTS-Arg0=", 0x3, }
    13:19:55.541826+0800  kernel  ACPIDebug: { "ABCD-_WAK-Arg0=", 0x3, }
    ```

    以上显示结果是最近一次睡眠、唤醒后 `Arg0` 的值。

## 备注

- Debug调试代码可以多样化，如：`\RMDT.P1`, `\RMDT.P2`, `\RMDT.P3` 等等，详见 ***SSDT-RMDT.dsl***
- 以上驱动、主要补丁来自 [@RehabMan](https://github.com/rehabman)
