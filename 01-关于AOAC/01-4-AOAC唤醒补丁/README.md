# AOAC唤醒补丁

## 描述

- ***SSDT-DeepIdle*** 补丁可以使机器进入深度空闲状态，能够延长机器待机时间，但同时也可能导致机器唤醒困难。<u>如果电源键无法正常唤醒机器，详见以下方法，否则，忽略本章内容</u> 。
- 有关***SSDT-DeepIdle*** 方面的内容参见《电源空闲管理》。

## AOAC唤醒方案

### PNP0C0D唤醒条件

- 根据 `ACPI `规范， `PNP0C0D` 唤醒条件如下：
  - `_LID`  返回 `One` 。 `_LID` 是 `PNP0C0D` 设备当前状态
  - 执行 `Notify(***.LID0, 0x80)`。 `LID0` 是 `PNP0C0D` 设备名称

### 按键触发唤醒

- 指定某个按键触发一个事件来唤醒 `PNP0C0D` 设备。

## AOAC唤醒补丁

- ***SSDT-LIDpatch-AOAC*** —— `_LID` 补丁，主要内容如下

  ```
      External(_SB.PCI0.LPCB.H_EC.LID0, DeviceObj)
      External(_SB.PCI0.LPCB.H_EC.LID0.XLID, MethodObj)
      
      Scope (_SB.PCI0.LPCB.H_EC.LID0)
      {
          Method (_LID, 0, NotSerialized)
          {
              If ((_OSI ("Darwin") && (\_SB.PCI8.AOAC == One)))
              {
                  Return (One)
              }
              Else
              {
                  Return (\_SB.PCI0.LPCB.H_EC.LID0.XLID())
              }
          }
      }
  ```

    对原始 `PNP0C0D` 设备`_LID`  打补丁，并设定变量 `AOAC` 

  -  `AOAC` =1时，`_LID`  返回 `One` ，满足 `PNP0C0D` 唤醒条件之一。
  -  `AOAC` =0时，恢复原始状态。
  -  `AOAC` 归属仿冒设备 `_SB.PCI8` ，防止变量重命。具体内容见补丁文件。

- ***唤醒按键补丁*** ——补丁包括 `Notify(***.LID0, 0x80)`，满足 `PNP0C0D` 唤醒条件之二，主要内容如下

  ```
  		......
  		\_SB.PCI8.AOAC = One
  		Notify (\_SB.PCI0.LPCB.H_EC.LID0, 0x80)
  		Sleep (200)
  		\_SB.PCI8.AOAC = Zero
  		......
  ```

- 小新PRO13唤醒按键补丁示例—— ***SSDT-FnQ-AOACWake*** 

  按键：`Fn+Q` ，`ACPI` 位置 `_Q50` ，具体内容见补丁文件。

## 注意事项

- 使用补丁时应保证补丁文件中 `PNP0C0D` 设备的路径、名称和原始 `ACPI` 一致。
- 补丁所要求的更名在对应补丁文件的注释里。
