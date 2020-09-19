# 小新PRO13特殊补丁

## 特殊更名

PNLF renamed XNLF

```text
Find:     504E4C46
Replace:  584E4C46
```

小新PRO的 DSDT 存在变量 `PNLF` ， `PNLF` 和亮度补丁名称有可能冲突，固使用以上更名规避之。

## 特殊的AOAC补丁

- ***SSDT-NameS3-disable*** ——参见《AOAC方法》之《禁止S3睡眠》
- ***SSDT-NDGP_OFF-AOAC*** ——参见《AOAC方法》之《AOAC禁止独显》
- ***SSDT-DeepIdle*** ——参见《AOAC方法》之《电源空闲管理》
- ***SSDT-PCI0.LPCB-Wake-AOAC*** ——参见《AOAC方法》之《AOAC唤醒方法》

## 其他补丁(参考)

- ***SSDT-PLUG-_SB.PR00*** ——参见《注入X86》
- ***SSDT-EC*** ——参见《仿冒设备—仿冒EC》
- ***SSDT-PNLF-CFL*** ——参见《PNLF注入方法》
- ***SSDT-PMCR*** ——参见《添加缺失的部件》
- ***SSDT-SBUS*** ——参见《SBUS/SMBU补丁》
- ***SSDT-OCBAT1-lenovoPRO13*** ——参见《电池补丁》
- ***SSDT-I2CxConf*** ——参见《I2C专用部件》
- ***SSDT-OCI2C-TPXX-lenovoPRO13*** ——参见《I2C专用部件》
- ***SSDT-CB-01_XHC*** ——参见《ACPI定制USB端口》
- ***SSDT-GPRW*** ——参见《060D补丁》
- ***SSDT-RTC_Y-AWAC_N*** ——参见《二进制更名与预置变量》
- ***SSDT-RMCF-PS2Map-LenovoPRO13*** ——本章补丁，参见《PS2键盘映射》
- ***SSDT-OCPublic-Merge*** ——本章补丁，参见 **附件** 说明
- ***SSDT-BATS-PRO13*** ——参见《电池补丁》

**注**：以上补丁所要求的更名在对应补丁文件的注释里。

## 备注

- 请阅读《AOAC方法》

## 附件：合并共用补丁

- 为了简化操作以及减少补丁数量，将某些公用补丁合并为：***SSDT-OCPublic-Merge*** 。

#### 合并的补丁

- ***SSDT-EC-USBX*** ——来自OC官方补丁示例的 **USBX** 部分
- ***SSDT-ALS0*** ——原补丁位于《仿冒设备—仿冒环境光传感器》
- ***SSDT-MCHC*** ——原补丁位于《添加缺失的部件》

#### 注意事项

- ***SSDT-OCPublic-Merge*** 适用于所有机器。
- 使用 ***SSDT-OCPublic-Merge*** 后，上述 **<u>合并的补丁</u>** 所列补丁不再适用。

