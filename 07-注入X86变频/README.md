# 注入X86

## 描述

注入 X86，实现 CPU 电源管理。

## 使用说明

- DSDT中搜索 `Processor`，如：

  ```Swift
      Scope (_PR)
      {
          Processor (CPU0, 0x01, 0x00001810, 0x06){}
          Processor (CPU1, 0x02, 0x00001810, 0x06){}
          Processor (CPU2, 0x03, 0x00001810, 0x06){}
          Processor (CPU3, 0x04, 0x00001810, 0x06){}
          Processor (CPU4, 0x05, 0x00001810, 0x06){}
          Processor (CPU5, 0x06, 0x00001810, 0x06){}
          Processor (CPU6, 0x07, 0x00001810, 0x06){}
          Processor (CPU7, 0x08, 0x00001810, 0x06){}
      }
  ```

  根据查询结果，选择注入文件 ***SSDT-PLUG-_PR.CPU0***

  再如：

  ```Swift
      Scope (_SB)
      {
          Processor (PR00, 0x01, 0x00001810, 0x06){}
          Processor (PR01, 0x02, 0x00001810, 0x06){}
          Processor (PR02, 0x03, 0x00001810, 0x06){}
          Processor (PR03, 0x04, 0x00001810, 0x06){}
          Processor (PR04, 0x05, 0x00001810, 0x06){}
          Processor (PR05, 0x06, 0x00001810, 0x06){}
          Processor (PR06, 0x07, 0x00001810, 0x06){}
          Processor (PR07, 0x08, 0x00001810, 0x06){}
          Processor (PR08, 0x09, 0x00001810, 0x06){}
          Processor (PR09, 0x0A, 0x00001810, 0x06){}
          Processor (PR10, 0x0B, 0x00001810, 0x06){}
          Processor (PR11, 0x0C, 0x00001810, 0x06){}
          Processor (PR12, 0x0D, 0x00001810, 0x06){}
          Processor (PR13, 0x0E, 0x00001810, 0x06){}
          Processor (PR14, 0x0F, 0x00001810, 0x06){}
          Processor (PR15, 0x10, 0x00001810, 0x06){}
      }
  ```

  根据查询结果，选择注入文件：***SSDT-PLUG-_SB.PR00***

- 如果查询结果和补丁文件名 **无法对应** ，请任选一个文件作为样本，自行修改补丁文件相关内容。

## 注意

2 代，3 代机器无需注入 X86。
