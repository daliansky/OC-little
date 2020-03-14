# AOAC唤醒方法

## 描述

- ***SSDT-DeepIdle*** 补丁可以使机器进入深度空闲状态，延长机器待机时间。但同时也会导致唤醒机器比较困难，需要采取特殊方法来唤醒机器。有关***SSDT-DeepIdle*** 方面的内容参见《电源空闲管理》。
- **本方法** 通过定制补丁协助 **电源按键** 自动点亮屏幕。

## 唤醒方法：电源按键

## 唤醒原理简述

- 一般情况下， **电源按键** 能够唤醒机器。但有些时候，机器被唤醒后的状态并不完整，表现为：除了屏幕不亮，其他部件都能正常工作。这表明机器已经进入了 `S0` 状态。这种情况下，只要在 `LPCB` 设备下添加 `_PS0` 方法，并且在`_PS0` 方法里添加符合 **PNP0C0D唤醒条件** 的内容，即可自动点亮屏幕。
-  建议同时使用 `_PS0` 和 `_PS3` 方法。

## 补丁示例

- ***SSDT-PCI.LPCB-Wake-AOAC*** 

  ```
  		......
      Scope (_SB.PCI0.LPCB)
      {
          If (_OSI ("Darwin"))
          {
              Method (_PS0, 0, Serialized)
              {
                  If(\_SB.PCI0.LPCB.H_EC.LID0._LID()==Zero)//当屏幕不亮时
                  {
                      \_SB.PCI0.LPCB.H_EC._Q0D()//小新PRO13开盖方法
                      //定制内容：
                      //依据《附件》的《PNP0C0D唤醒条件》，制作适合于自己的开盖补丁
                      //或者使用通用开盖补丁
                  }
              }
              Method (_PS3, 0, Serialized)
              {
              }
          }
      }
  ```

  **说明：** 

  1  `_SB.PCI0.LPCB.H_EC.LID0._LID` 为小新PRO盖子设备的当前状态。

  2  `_SB.PCI0.LPCB.H_EC._Q0D` 为小新PRO开盖方法。

  **注意1：** LPCB控制器名称可能是 `LPCB` ，也可能是 `LPC` 。

  **注意2：** 盖子部件【PNP0C0D】的名称、路径应与ACPI原始名称、路径一致。

  **注意3：** 如果使用通用开盖补丁，将 `_PS0` 部分替换为以下内容：

  ```
  	......
              Method (_PS0, 0, Serialized)
              {
                  If(\_SB.PCI0.LPCB.H_EC.LID0._LID()==Zero)//当屏幕不亮时
                  {
                      \_SB.PCI0.LPCB.H_EC.LID0.AOAC = 1 //满足 PNP0C0D唤醒条件 之一
                      Notify (\_SB.PCI0.LPCB.H_EC.LID0, 0x80) //满足 PNP0C0D唤醒条件 之二
                      Sleep (200) //延时200
                      \_SB.PCI0.LPCB.H_EC.LID0.AOAC = 0 //恢复原始状态
                  }
              }
  	......
  ```

- ***SSDT-LIDpatch-AOAC*** ——通用开盖补丁

  当无法或者很难找到适合于自己的定制方法时，使用本补丁。
  
  **注意1**：通用开盖补丁应和 ***SSDT-PCI.LPCB-Wake-AOAC*** 一同使用。
  
  **注意2**：补丁里的设备名称、路径应与ACPI原始名称、路径一致。补丁要求的更名在文件的注释里。

## 附件

**PNP0C0D唤醒条件** 

- `_LID`  返回 `One` 。 `_LID` 是 `PNP0C0D` 设备当前状态
- 执行 `Notify(***.LID0, 0x80)`。 `LID0` 是 `PNP0C0D` 设备名称