# 小新PRO特殊更名和补丁

### 特殊更名和补丁

-   特殊更名 
   
   PNLF renamed XNLF
   
   ```
	Find:		504E4C46 
   Replace:	584E4C46 
   ```
   
   小新PRO的 DSDT 存在变量 `PNLF` ，通过以上更名规避变量 `PNLF` 和亮度补丁发生的冲突。
   
- 特殊补丁 
  
  - ***SSDT-S3-disable***   
  
    因小新PRO未提供S3睡眠，禁用S3使机器避免因睡眠而导致的死机问题。参见《禁止S3睡眠》。
  
  - ***SSDT-Q50-FnQ-disbale***   
  
    该补丁禁用Fn+Q功能。见本章 **补丁** 。
  
  以上补丁所要求的更名在对应补丁文件的注释里。
  
-   其他补丁

    - 参考《OC-little》相关内容

### 备注

- 因小新PRO无法睡眠，不必使用《0D6D补丁》的 ***SSDT-GPRW*** 。