```swift
//
// In config ACPI, GPRW to XPRW
// Find:     47505257 02
// Replace:  58505257 02
//
DefinitionBlock ("", "SSDT", 2, "OCLT", "GPRW", 0)
{
    External(XPRW, MethodObj)
    Method (GPRW, 2, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            If ((0x6D == Arg0))
            {
                Return (Package ()
                {
                    0x6D, 
                    Zero
                })
            }

            If ((0x0D == Arg0))
            {
                Return (Package ()
                {
                    0x0D, 
                    Zero
                })
            }
        }
        Return (XPRW (Arg0, Arg1))
    }
}

```
## 提示
关于使用 GPRW 重命名后导致打开 System DSDT 后所有设备的`_PRW`方法都出现了 6126 语法错误原因是`Method (GPRW, 2)`被重命名后`DSDT`中不存在`GPRW`方法也没有明确外部引用声明因为`GPRW` 需要两个参数则导致编译器自动补全外部引用声明而出现的错误，虽然不影响使用但错误会导致无法直接另存`System DSDT`确实会不方便，解决反编译报错的方法则是在`DSDT`中现有声明的外部引用对象中找一个没有调用者的空白声明使用 `ACPI` 查找替换补丁改成 `External (GPRW, Method) // 2 Arguments` 台式机6代+ 通常外部引用 `IGDS` `BRTL` `CRBI` `LIDS` `P2WK` `P1WK` `P0WK` 为空白声明没有调用者且均为`UnknownObj`，不同机型可能有差异具体请自行确认，查找到后替换为：155C475052570802 (Find 值自行确认）

## 解析：
155C 代表外部引用对象 External (通用），47505257 为对象名称 (以GPRW为例) ，08 为声明对象为 MethodObj ，02则表示方法需要两个参数

**例举上述已知空白声明的 Find值：**

已知 151C 为外部引用声明，0000 为 `UnknownObj` Find就以 `LIDS` 为例：151C + (LIDS 的 Hex: 4C494453) + 0000 

Find        = 155C4C49 44530000 

Replace = 155C4750 52570802 
