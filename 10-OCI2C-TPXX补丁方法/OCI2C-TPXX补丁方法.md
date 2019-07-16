## OCI2C-TPXX补丁方法

1. 描述

   本方法提供一种对I2C设备实施HOTpatch补丁的解决方案。本方法不涉及I2C补丁具体过程和细节，有关更多的I2C方面内容详见：

   - @penghubingzhou：https://www.penghubingzhou.cn
   - @bat.bat：https://github.com/williambj1/VoodooI2C-PreRelease/blob/master/触摸板补充.md#iv-查看-ioregisteryexplorer-里-voodooi2c-是否正常加载
   - https://voodooi2c.github.io/#GPIO%20Pinning/GPIO%20Pinning
   - https://www.tonymacx86.com/threads/voodooi2c-help-and-support.243378/
   - Q群：837538729

2. 补丁原理和过程

   - 禁止原I2C设备。
   - 新建一个I2C设备：TPXX。
   - 将原设备所有内容移植到新建设备中。
   - 修正TPXX相关内容。
   - 排除错误。
   - 打I2C补丁。
   
3. 示例（dell Latitude5480，设备路径：_SB.PCI0.I2C1.TPD1）

   以下是补丁过程：

   - 采用《预置变量法》禁止TPD1。详见《操作系统和工作状态的表述》中的《补丁拓展应用》。

         Scope (\)
         {
             If (_OSI ("Darwin"))
             {
                 SDS1 = 0
             }
         }

   - 新建设备：TPXX

         External(_SB.PCI0.I2C1, DeviceObj)
         Scope (_SB.PCI0.I2C1)
         {
             Device (TPXX)
             {

   - 将原TPD1所有内容移植到TPXX中。

   - 修正TPXX内容1: 所有TPD1替换TPXX。

   - 修正TPXX内容2: 补丁中 _STA部分替换为：

                 Method (_STA, 0, NotSerialized)
                 {
                     If (_OSI ("Darwin"))
                     {
                         Return (0x0F)
                     }
                     Else
                     {
                         Return (Zero)
                     }
                 }

   - 修正TPXX内容3: 查找SDS1（禁止原I2C设备关联的变量），将原if（SDS1…..）修改为if（one）。

   - 添加外部引用External...修补所有错误。

   - I2C补丁（略）