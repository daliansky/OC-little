# 综合补丁

## 描述

- 通过对 `_PTS` 和 `_WAK` 更名，加上综合补丁和它的扩展补丁，解决某些机器睡眠或唤醒过程中出现一些问题。

- 综合补丁是一个框架，它包括：
  - 屏蔽独显接口 `_ON`, `_OFF`。
  - 6 个扩展补丁接口 `EXT1`, `EXT2`, `EXT3`, `EXT4` , `EXT5` 和 `EXT6`。
  - 定义强制睡眠传递参数 `FNOK` 和 `MODE` ，详见《PNP0C0E睡眠修正方法》。
  - 定义调试参数 `TPTS` 和 `TWAK` ，用于在睡眠和唤醒过程中，侦测、跟踪 `Arg0` 变化。比如，在亮度快捷键补丁里添加以下代码：

    ```Swift
    ...
    /* 某按键： */
    \RMDT.P2 ("ABCD-_PTS-Arg0=", \_SB.PCI9.TPTS)
    \RMDT.P2 ("ABCD-_WAK-Arg0=", \_SB.PCI9.TWAK)
    ...
    ```

    当按下亮度快捷键后，能够在控制台上看到前一次睡眠、唤醒后 `Arg0` 的值。

    注：调试ACPI需要安装驱动 ACPIDebug.kext，添加补丁 SSDT-RMDT，以及自定义的调试补丁。具体方法参见《ACPIDebug》。

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

如果 DSDT 中存在 `_TTS` 也需要对其更名；如果不存在，则无需更名。依据原始 DSDT 内容选择正确的更名，如：

- `_TTS` to `ZTTS(1,N)`:

  ```Swift
    Method (_TTS, 1, NotSerialized)  /* _WAK: Wake */
    {
  ```

- `_TTS` to `ZTTS(1,S)`:

  ```Swift
    Method (_TTS, 1, Serialized)  /* _WAK: Wake */
    {
  ```


## 补丁

- ***SSDT-PTSWAKTTS*** —— 综合补丁。

- ***SSDT-EXT1-FixShutdown*** —— `EXT1` 扩展补丁。 修复因 XHC 控制器导致的关机变重启的问题，原理是当 `_PTS` 中传入的参数为 `5` 时将 `XHC.PMEE` 置 0。该补丁与 Clover 的 `FixShutdown` 效果等同。部分 XPS / ThinkPad 机器会需要这个补丁。

- ***SSDT-EXT3-WakeScreen*** —— `EXT3` 扩展补丁。解决某些机器唤醒后需按任意键亮屏的问题。使用时应查询 `PNP0C0D` 设备名称和路径是否已存在补丁文件中，如 `_SB.PCI0.LPCB.LID0`。如果不存在自行添加。

- ***SSDT-EXT5-TP-LED*** —— `EXT5` 扩展补丁。 解决 ThinkPad 机器唤醒后 A 面呼吸灯和电源键呼吸灯未恢复正常的问题；修复在 ThinkPad 老机型上唤醒后 <kbd>F4</kbd> 麦克风指示灯状态不正常的问题。

## 注意

具有相同扩展名称的补丁不可同时使用。如有同时使用的要求必须合并后使用。
