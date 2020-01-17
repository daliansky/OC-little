# 小新PRO13特殊更名和补丁

## 特殊更名和补丁

- 特殊更名
  
  PNLF renamed XNLF
  
  ```text
  Find:     504E4C46
  Replace:  584E4C46
  ```
  
  小新PRO的 DSDT 存在变量 `PNLF` ，和亮度补丁名称有冲突之嫌，固使用以上更名规避。
  
- 特殊补丁
  
  - ***SSDT-S3-disable*** ——参见《AOAC补丁方法》
  
  - ***SSDT-DeepIdle*** ——参见《AOAC补丁方法》
  
  - ***SSDT-FnQ-WakeScreen***   ——参见《AOAC补丁方法》
  
    以上补丁所要求的更名在对应补丁文件的注释里。
  
- 其他补丁

  - 参考《OC-little》相关内容

### 备注

- 请阅读《AOAC补丁方法》、《AOAC禁止独显》。
