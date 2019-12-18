# ACPI二进制更名

为了达成补丁效果，我们对ACPI进行二进制更名，可以说这是一种特殊的、不得已的解决方法，也可以认为这种方法更加方便、快捷、高效。

## 示例

以启用`HPET`为例。我们希望它的`_STA` 返回 `0x0F`。

二进制更名：

Find：`A0 08 48 50`【注：`A0`=`If`】

Replace：`A4 0A 0F A3` 【注：`A4 0A 0F` =`Return (0x0F)`； `A3`=Noop，用于补齐字节数量】

- 原始代码

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
        If (HPTE)
        {
            Return (0x0F)
        }
        Return (Zero)
    }
  ```

- 更名后代码

  ```Swift
    Method (_STA, 0, NotSerialized)
      {
          Return (0x0F)
          Noop
          TE** ()
          Return (Zero)
    }
  ```

  **解释**：更名后出现了明显错误，但是这种错误不会产生危害。首先，`Return (0x0F)` 后面内容不会被执行。其次，错误位于 `{}` 内不会对其他内容产生影响。

  这是说明示例。实际情况，我们应尽可能保证更名后语法的完整性。下面是完整的 `Find`, `Replace` 数据。
  
  Find：`A0 08 48 50 54 45 A4 0A 0F A4 00`
  
  Replace：`A4 0A 0F A3 A3 A3 A3 A3 A3 A3 A3`
  
  完整 `Find`、`Replace` 后代码
  
  ```Swift
    Method (_STA, 0, NotSerialized)
    {
        Return (0x0F)
        Noop
        Noop
        Noop
        Noop
        Noop
        Noop
        Noop
        Noop
    }
  ```

## 要求

- ***ACPI*** 原始文件

  `Find` 二进制文件必须是 ***ACPI*** 原始文件，不可以被任何软件修改、保存过，也就是说它必须是机器提供的原始二进制文件。

- `Find` 唯一性、正确性

  本文所描述的方法不是通常意义的对 `Device` 或者 `Method` 的更名，是通过更名实现的一种补丁。这要求 `Find` 数量只有一个，**除非** 我们本意就是对多处实施 `Find` 和 `Replace` 相同操作。

  **特别注意**：为了保证 `Find` 数据的正确性，任何重写一段代码而从中查找确认的二进制数据，非常不可信！

- `Replace` 字节数量

  `Find`, `Replace` 字节数量要求相等。比如 `Find` 10个字节，那么 `Replace`  也是 10 个字节。如果`Replace` 少于 10 个字节就用 `A3`（空操作）补齐。

## `Find` 数据查找方法

通常，用二进制软件（如 `010 Editor` 和 `MaciASL.app`） 打开同一个 `ACPI` 文件，以二进制数据方式或者文本方式 `Find` 相关内容，观察上下文，相信很快能够确定 `Find` 数据。

## `Replace` 内容

《要求》中说明 `Find` 时，【任何重写一段代码而从中查找确认的二进制数据，非常不可信！】，然而 `Replace` 可以这样操作。按照上面的示例，我们写一段代码：

```Swift
    DefinitionBlock ("", "SSDT", 2, "hack", "111", 0)
    {
        Method (_STA, 0, NotSerialized)
        {
            Return (0x0F)
        }
    }
```

编译后用二进制软件打开，发现：`XX ... 5F 53 54 41 00 A4 0A 0F` ，其中 `A4 0A 0F` 就是 `Return (0x0F)`。

注：`Replace` 内容要遵循 ACPI 规范和 ASL 语言要求。

## 注意事项

 更新BIOS有可能造成更名失效。`Find` 字节数越多失效的可能性也越大。

### 附：TP-W530 禁止 BAT1

Find：`00 A0 4F 04 5C 48 38 44 52`

Replace：`00 A4 0A 00 A3 A3 A3 A3 A3`

- 原始代码

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
          If (\H8DR)
          {
              If (HB1A)
              {
              ...
    }
  ```

- 更名后代码

  ```Swift
    Method (_STA, 0, NotSerialized)
      {
          Return (0x00)
          Noop
          Noop
          Noop
          Noop
          Noop
          If (HB1A)
          ...
    }
  ```
