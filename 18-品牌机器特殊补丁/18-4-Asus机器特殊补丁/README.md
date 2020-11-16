# Asus机器特殊补丁

## 要求

- 检查ACPI是否存在下列 `Method` 和 `Name` ，如果不存在忽略本章内容。
  - `Name` ：OSFG
  - `Method` ：MSOS

## 特殊更名

PNLF renamed XNLF

```text
Find:     504E4C46
Replace:  584E4C46
```

一些 Asus 机器的 DSDT 存在变量 `PNLF` ， `PNLF` 和亮度补丁名称相同有可能发生冲突，固使用以上更名规避之。

## 特殊补丁

- ***SSDT-OCWork-asus*** 
  - 多数 Asus 机器都存在 `MSOS` 方法， ``MSOS`` 方法向 `OSFG` 赋值并返回当前状态值，这个【当前状态值】决定了机器的工作模式。比如，只有 `MSOS` >= `0x0100` 时，ACPI 的亮度快捷键方法才起作用。在默认状态下， `MSOS` 被锁定于 `OSME` 。 **本补丁** 通过改变 `OSME` 从而改变 ``MSOS`` 。有关 `MSOS` 方法的详细内容请查看 DSDT 的 `Method (MSOS...` 。
    -  `MSOS` >= `0x0100` ，win8模式，亮度快捷键工作
  - ``MSOS`` 返回值取决于操作系统本身，黑苹果状态下必须使用 **操作系统补丁** 或者使用 **本补丁** 才能满足特定要求。
  
