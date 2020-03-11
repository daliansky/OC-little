# AOAC唤醒方法

## 描述

- ***SSDT-DeepIdle*** 补丁可以使机器进入深度空闲状态，延长机器待机时间。但同时也会导致唤醒机器比较困难，需要采取特殊方法来唤醒机器
- 有关***SSDT-DeepIdle*** 方面的内容参见《电源空闲管理》。

## 唤醒

- **电源键** 
- 当 **电源键** 无法唤醒机器时，通过定制补丁来协助 **电源键** 唤醒机器。找到符合以下要求的 `PCI` 设备或者它的 `父设备` ，通常选用 `NVMe` 设备。
  - 该设备路径下无 `_PS0` 和 `_PS3` 方法
  - 按下电源键后，该设备能够从空闲状态返回到 `S0` 状态

## 补丁示例

- ***SSDT-PCIWake-AOAC*** 

  ```
  		......
      Scope (_SB.PCI0.RP09.PXSX)
      {
          If (_OSI ("Darwin"))
          {
              Method (_PS0, 0, Serialized)
              {
                  If(\_SB.PCI0.LPCB.H_EC.LID0._LID()==Zero)//当屏幕不亮时
                  {
                      \_SB.PCI0.LPCB.H_EC._Q0D()//小新PRO13开盖方法
                      //替换内容：
                      //依据《附件》的《PNP0C0D唤醒条件》，定制适合于自己的开盖补丁
                      //或者采用通用开盖补丁
                  }
              }
              Method (_PS3, 0, Serialized)
              {
              }
          }
      }
  ```

  **说明：**

  1 `_SB.PCI0.RP09.PXSX` 为小新PRO的SSD路径。

  2 `_SB.PCI0.LPCB.H_EC.LID0` 为小新PRO的盖子设备。

  3  `_SB.PCI0.LPCB.H_EC._Q0D` 为小新PRO开盖方法。

  

- ***SSDT-LIDpatch-AOAC*** ——通用开盖补丁

  当无法或者很难找到适合于自己的定制方法时，才使用通用开盖补丁。使用通用开盖补丁时，需将 ***SSDT-PCIWake-AOAC*** 补丁的 `_PS0` 部分替换为
  
  ```
  	......
              Method (_PS0, 0, Serialized)
              {
                  If(\_SB.PCI0.LPCB.H_EC.LID0._LID()==Zero)//当屏幕不亮时
                  {
                      \_SB.PCI0.LPCB.H_EC.LID0.AOAC = 1
                      Notify (\_SB.PCI0.LPCB.H_EC.LID0, 0x80)
                      Sleep (200)
                      \_SB.PCI0.LPCB.H_EC.LID0.AOAC = 0
                  }
              }
  	......
  ```
  
  **注意**：所有补丁示例的设备路径同原始ACPI的设备路径一致。

## 附件

**PNP0C0D唤醒条件** 

- `_LID`  返回 `One` 。 `_LID` 是 `PNP0C0D` 设备当前状态
- 执行 `Notify(***.LID0, 0x80)`。 `LID0` 是 `PNP0C0D` 设备名称