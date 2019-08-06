# ThinkPad电池补丁

## 重要说明

- 请阅读《ThinkPad 电池系统》。
- 确认主电池路径是`\_SB.PCI0.LPC.EC.BAT0` 或者 `\_SB.PCI0.LPCB.EC.BAT0`，非两者，本章内容仅供参考。
- 可能用到的更名
  - TP 电池基本更名
  - TP 双物理电池 Notify 更名 `LPC`
  - TP 双物理电池 Notify 更名 `LPCB`
- 可能用到的补丁
  - ***SSDT-OCBAT0-TP***
  - ***SSDT-OCBAT1-TP-disable***
  - ***SSDT-OCBATC-TP-LPC***
  - ***SSDT-OCBATC-TP-LPCB***

### 更名和补丁

- 单电池系统

  - 更名：TP电池基本更名
  - 补丁：***SSDT-OCBAT0-TP***

- 双电池系统一块物理电池

  - 更名
    - TP 电池基本更名
  - 补丁
    - ***SSDT-OCBAT0-TP***
    - ***SSDT-OCBAT1-TP-disable***

- 双电池系统二块物理电池

  - 更名
    - TP 电池基本更名
    - ***TP 双物理电池 Notify 更名-LPC*** 或者 ***TP 双物理电池 Notify 更名-LPCB***
  - 补丁
    - ***SSDT-OCBAT0-TP***
    - ***SSDT-OCBATC-TP-LPC*** 或者 ***SSDT-OCBATC-TP-LPCB***

> **注1**：***SSDT-OCBAT0-TP*** 是主电池补丁。根据机器型号确认对应的补丁文件。
> **注2**：选 `LPC` 的更名、补丁还是 `LPCB` 的更名、补丁，取决于主电池路径。
