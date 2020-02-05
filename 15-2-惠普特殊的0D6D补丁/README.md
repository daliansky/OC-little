# 惠普特殊的 `0D6D` 补丁

- 关于 `0D/6D补丁` 的相关内容请参阅《0D6D补丁》

- 某些惠普机器，其 `ACPI` 的一些部件（和 `0D6D` 有关的）的 `_PRW` 方法如下：

  ```swift
  Method (_PRW, 0, NotSerialized)
  {
      Local0 = Package (0x02)
      {
          Zero,
          Zero
      }
      Local0 [Zero] = 0x6D
      If ((USWE == One))    /* 注意USWE */
      {
          Local0 [One] = 0x03
      }
      Return (Local0)
  }
  ```

  这种情况可以使用《预置变量法》完成 `0D/6D补丁`，如：

  ```swift
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          USWE = 0
      }
  }
  ```

- 示例： ***SSDT-0D6D-HP***

   ***SSDT-0D6D-HP*** 适用于 `HP 840 G3`，补丁修补了 `XHC` 、 `GLAN` 的 `_PRW` 返回值。

- 其他有类似情况的机器参考示例文件。
