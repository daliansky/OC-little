# Dell机器特殊补丁

## 要求

- 检查ACPI是否存在下列 `Device` 和 `Method` ，并且名称相符，否则忽略本章内容。
  - `Device` ：ECDV【PNP0C09】
  - `Device` ：LID0【PNP0C0D】
  - `Method` ：OSID
  - `Method` ：BTNV

## 特殊更名

PNLF renamed XNLF

```text
Find:     504E4C46
Replace:  584E4C46
```

一些 Dell 机器的 DSDT 存在变量 `PNLF` ， `PNLF` 和亮度补丁名称相同有可能发生冲突，固使用以上更名规避之。

## 特殊补丁

- ***SSDT-OCWork-dell*** 
  - 多数 Dell 机器都存在 `OSID` 方法， `OSID` 方法包括了2个变量 `ACOS` 和 `ACOS` ，这2个变量决定了机器的工作模式。比如，只有 `ACOS` >= `0x20` 时，ACPI 的亮度快捷键方法才起作用。以下列举2个变量和工作模式的几种关系。有关 `OSID` 方法的详细内容请查看 DSDT 的 `Method (OSID...` 。
    - `ACOS` >= `0x20` ，亮度快捷键工作
    - `ACOS` = `0x80` ，`ACSE` = 0 为 win7 模式，在此模式下，机器睡眠期间呼吸灯闪烁
    - `ACOS` = `0x80` ，`ACSE` = 1 为 win8 模式，在此模式下，机器睡眠期间呼吸灯灭
  - `OSID` 方法里的2个变量的具体内容取决于操作系统本身，黑苹果状态下必须使用 **操作系统补丁** 或者使用 **本补丁** 才能改变这2个变量满足特定要求。

- 修复 Fn+Insert 功能键的补丁组合
  
  - ***SSDT-PTSWAK***   参见《PTSWAK综合扩展补丁》
  - ***SSDT-EXT3-WakeScreen***   参见《PTSWAK综合扩展补丁》
  - ***SSDT-LIDpatch***   参见《PNP0C0E睡眠修正方法》
  - ***SSDT-FnInsert_BTNV-dell***   参见《PNP0C0E睡眠修正方法》
