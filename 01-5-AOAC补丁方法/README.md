# AOAC补丁方法

## AOAC技术

- 新的笔记本电脑引入了一项新技术—— `AOAC` ，即：*Always On/Always Connected* 。 `AOAC` 由 `Intel` 提出，旨在电脑在睡眠或者休眠模式下仍然保持网络连接及资料传输。简单的说，  `AOAC` 的引入使笔记本和我们的手机一样，永不关机，永远在线。
- 有关AOAC方面的内容请百度 `AOAC` 、 `联想AOAC` 、 `AOAC网卡` 等。

## AOAC带来的问题

##### 睡眠失败问题

- 由于 `AOAC` 和 `S3` 本身相矛盾，采用了 `AOAC` 技术的机器不具有 `S3` 睡眠功能，如 `Lenovo PRO13` 。这样的机器一旦进入 `S3` 睡眠就会 **睡眠失败** 。 **睡眠失败** 主要表现为：睡眠后无法被唤醒，呈现死机状态，只能强制关机。**睡眠失败** 本质是机器一直停滞在睡眠过程，始终没有睡眠成功。
- <u>解决方法</u> ： **禁止`S3`睡眠** ，见后文的补丁方法。有关 `S3` 方面内容参见《ACPI 规范》。

##### 待机时间问题

- **禁止`S3`睡眠** 后机器将不再睡眠。没有了睡眠随之而来的问题是：在电池供电模式下，机器待机时间大大缩短。比如，在"菜单睡眠"、"自动睡眠"、"盒盖睡眠"等情况下，电池耗电量较大，大约每小时耗电5%--10%。
- <u>解决方法</u> ：
  - 关闭独显的供电电源
  - 优化SSD固态硬盘的电源管理
    - 选择品质较好的SSD：SLC>MLC>TLC>QLC（不确定）
    - 可能的话更新SSD固件以提高电源管理的效能
    - 使用SSDT-DeepIdle提高SSD进入空闲电源管理的可能性，见后文的补丁方法
    - 使用NVMeFix.kext开启SSD的APST
    - 启用主板ASPM（通常在BIOS高级选项里），有关ASPM设置参考：https://www.sohu.com/a/120850299_505795

## AOAC补丁

- 禁止`S3`补丁，见本章

  - 更名：`_S3` to `XS3` 

    ```
    Find:     5F53335F
    Replace:  5853335F
    ```

  - 补丁： ***SSDT-S3-disable*** 

    ```
    If (_OSI ("Darwin"))
    {
        /* Empty */
    }
    Else
    {
        Name (_S3, Package (0x04)
        {
            0x05,
            Zero,
            Zero,
            Zero
        })
    }
    ```

- `DeepIdle` 补丁，见本章

  - 更名：无

  - 补丁： ***SSDT-DeepIdle*** 

    ```
    // IORegistryExplorer
    // IOService:/AppleACPIPlatformExpert/IOPMrootDomain:
    // IOPMDeepIdleSupported = true
    // IOPMSystemSleepType = 7
    // PMStatusCode = ?
    Scope (_SB)
    {
    		Method (LPS0, 0, NotSerialized)
    		{
    				If (_OSI ("Darwin"))
    				{
    						Return (One)
    				}
    		}
    }  
    Scope (_GPE)
    {
    		Method (LXEN, 0, NotSerialized)
    		{
    				If (_OSI ("Darwin"))
    				{
    						Return (One)
    				}
    		}
    }
    ```

  - 详细内容参见：https://pikeralpha.wordpress.com/2017/01/12/debugging-sleep-issues/

- 禁止独显补丁

  参见《AOAC禁止独显》。

- 唤醒亮屏补丁，见本章

  使用 ***SSDT-S3-disable*** 会导致唤醒困难。为了解决这个问题，采用以下方法：

  - 指定一个按键作为唤醒按键，以小新PRO13为例，指定`Fn+Q`（位置：`_Q50` ）
  - 使用 `PNP0C0D` 唤醒方法，参见《PNP0C0E睡眠修正方法》
  
    附： `PNP0C0D` 唤醒条件：
    - `_LID`  返回 `One` 。 `_LID` 是 `PNP0C0D` 设备当前状态。
    - 执行 `Notify(***.LID0, 0x80)`。 `LID0` 是 `PNP0C0D` 设备名称。
  - 示例：***SSDT-FnQ-WakeScreen*** 

## 注意事项

- 本方法只是临时解决方案。随着 `AOAC` 技术的广泛应用，相信不久会有更好的解决方法。
- 非 `AOAC` 的机器也可尝试本方法。
- `AOAC` 和 `S3` 睡眠、唤醒无关。以下补丁无需使用：
  - 《PTSWAK综合补丁和扩展补丁》
  - 《PNP0C0E睡眠修正方法》
  - 《0D6D补丁》