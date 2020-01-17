# AOAC禁止独显

## 两种方法

- `Properties` 方法

  `DeviceProperties\Add\PciRoot(0x0)/Pci(0x2,0x0)` 添加

  ``` xml
  disable-external-gpu  01000000
  ```

- `SSDT` 补丁方法

  - 补丁1: ***SSDT-NDGP_OFF-AOAC***
    - 查询独显 `ACPI` 路径，确认存在 `_OFF` 方法  【 `_ON`  和  `_OFF` 成对出现】
    - 参考示例，修改其路径同 `ACPI` 独显路径一致
  - 补丁2: ***SSDT-NDGP_PS3-AOAC***
    - 查询独显 `ACPI` 路径，确认存在 `_PS3` 方法  【 `_PS0`  和  `_PS3` 成对出现】
    - 参考示例，修改其路径同 `ACPI` 独显路径一致
  - **注意**
    - 查询独显 `ACPI` 路径时，应对全部 `ACPI` 文件进行搜索，它可能存在于 `DSDT` ，也可能存在于其他 `ACPI` 文件中。
    - 以上2个示例为小新PRO13定制补丁，独显路径是： `_SB.PCI0.RP13.PXSX`

## 注意

- 优先使用 `Properties` 方法，如果 `Properties` 方法无效尝试使用 `SSDT` 补丁方法。
- 本文的 `SSDT` 补丁方法仅适用于采用了 `AOAC` 技术的机器。完整的 `SSDT` 补丁方法见《P-部件补丁》之《屏蔽独显》
