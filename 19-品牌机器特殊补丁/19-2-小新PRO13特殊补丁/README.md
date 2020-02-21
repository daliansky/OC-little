# 小新PRO13特殊补丁

### 特殊更名

PNLF renamed XNLF

```text
Find:     504E4C46
Replace:  584E4C46
```

小新PRO的 DSDT 存在变量 `PNLF` ， `PNLF` 和亮度补丁名称有可能冲突，固使用以上更名规避之。

### 特殊补丁

- ***SSDT-NameS3-disable*** ——参见《AOAC方法》

- ***SSDT-DeepIdle*** ——参见《AOAC方法》


### 其他补丁(参考)

- ***SSDT-EC*** ——参见《仿冒EC》

- ***SSDT-PLUG-_SB.PR00*** ——参见《注入X86》

- ***SSDT-PNLF-CFL*** ——参见《PNLF注入方法》

- ***SSDT-BKeyQ38Q39-LenovoPRO13*** ——参见《亮度快捷键》

- ***SSDT-ALS0*** ——参见《仿冒环境光传感器》

- ***SSDT-MCHC*** ——参见《添加缺失的部件》

- ***SSDT-PMCR*** ——参见《添加缺失的部件》

- ***SSDT-XSPI*** ——参见《添加缺失的部件》

- ***SSDT-SBUS*** ——参见《SBUS/SMBU补丁》

- ***SSDT-RTC_Y-AWAC_N*** ——参见《二进制更名与预置变量》

- ***SSDT-OCBAT1-lenovoPRO13*** ——参见《电池补丁》

- ***SSDT-I2CxConf*** ——参见《I2C专用部件》

- ***SSDT-OCI2C-TPXX-lenovoPRO13*** ——参见《I2C专用部件》

  **注**：以上补丁所要求的更名在对应补丁文件的注释里。

### 备注

- 请阅读《AOAC方法》
