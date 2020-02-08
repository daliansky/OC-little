# 综合补丁

## 描述

- 通过对 `_PTS` 和 `_WAK` 更名，加上综合补丁和它的扩展补丁，解决某些机器睡眠或唤醒过程中出现一些问题。

- 综合补丁是一个框架，它包括：
  - 4 个扩展补丁接口 `EXT1`, `EXT2`, `EXT3` 和 `EXT4` 。
  
  - 定义强制睡眠传递参数 `FNOK` 和 `MODE` ，详见《PNP0C0E睡眠修正方法》。
  
  - 定义调试参数 `TPTS` 和 `TWAK` ，用于在睡眠和唤醒过程中，侦测、跟踪 `Arg0` 变化。比如，在亮度快捷键补丁里添加以下代码：
  
    ```
    ......
    //某按键：
    \RMDT.P2 ("ABCD-_PTS-Arg0=", \_SB.PCI9.TPTS)
    \RMDT.P2 ("ABCD-_WAK-Arg0=", \_SB.PCI9.TWAK)
    ......
    ```
    
    当按下亮度快捷键后，能够在控制台上看到前一次睡眠、唤醒后 `Arg0` 的值。
    
    注：调试ACPI需要安装驱动ACPIDebug.kext，添加补丁SSDT-RMDT，以及自定义的调试补丁。具体方法参见《ACPIDebug》。

## 更名

使用综合补丁必须对 `_PTS` 和 `_WAK` 更名。依据原始 DSDT 内容选择正确的更名，如：

- `_PTS` to `ZPTS(1,N)`:

  ```Swift
    Method (_PTS, 1, NotSerialized)  /* _PTS: Prepare To Sleep */
    {
  ```

- `_WAK` to `ZWAK(1,N)`:

  ```Swift
    Method (_WAK, 1, NotSerialized)  /* _WAK: Wake */
    {
  ```

- `_PTS` to `ZPTS(1,S)`:

  ```Swift
    Method (_PTS, 1, Serialized)  /* _PTS: Prepare To Sleep */
    {
  ```

- `_WAK` to `ZWAK(1,S)`:

  ```Swift
    Method (_WAK, 1, Serialized)  /* _WAK: Wake */
    {
  ```

## 补丁

- ***SSDT-PTSWAK*** —— 综合补丁。

- ***SSDT-EXT3-LedReset-TP*** —— `EXT3` 扩展补丁。 解决 TP 机器唤醒后呼吸灯未恢复正常的问题。

- ***SSDT-EXT4-WakeScreen*** —— `EXT4` 扩展补丁。解决某些机器唤醒后需按任意键亮屏的问题。使用时应查询 `PNP0C0D` 设备名称和路径是否已存在补丁文件中，如 `_SB.PCI0.LPCB.LID0`。如果不存在自行添加。

  


## 注意

具有相同扩展名称的补丁不可同时使用。如有同时使用的要求必须合并后使用。
