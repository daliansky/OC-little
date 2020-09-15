# SSDT 屏蔽独显方法

## 二种屏蔽独显方法

- `config` 方法

  - `DeviceProperties\Add\PciRoot(0x0)/Pci(0x2,0x0)` 添加

    ```text
    disable-external-gpu  01000000
    ```

  - 添加引导参数

    ```text
    boot-args             -wegnoegpu
    ```

- **本方法** —— SSDT 屏蔽独显方法

## SSDT屏蔽独显过程

- 初始化阶段禁用独显。
- 机器睡眠期间启用独显，防止独显在被禁用状态下进入 `S3` 而可能导致的系统崩溃。
- 机器唤醒后再次禁用独显。

## 补丁组合

- 综合补丁—— ***SSDT-PTSWAK***
- 屏蔽独显补丁—— ***SSDT-NDGP_OFF*** 【或者 ***SSDT-NDGP_PS3*** 】

## 示例

- ***SSDT-PTSWAK***

  略，详见《PTSWAK综合扩展补丁》。
  
- ***SSDT-NDGP_OFF***

  - 查询独显的名称和路径，确认其存在 `_ON` 和 `_OFF` 方法
  - 参考示例，修改其名称和路径同查询结果一致
  
- ***SSDT-NDGP_PS3***

  - 查询独显的名称和路径，确认其存在 `_PS0`  、 `_PS3` 和 `_DSM` 方法
  - 参考示例，修改其名称和路径同查询结果一致
  
- **注意**

  - 查询独显名称和路径以及 `_ON` 、 `_OFF` 、 `_PS0` 、 `_PS3` 和 `_DSM` 时，应对全部 `ACPI` 文件进行搜索，它可能存在于 `DSDT` 文件中，也可能存在于 `ACPI` 的其他 `SSDT` 文件中。
  - 示例中的独显名称和路径是： `_SB.PCI0.RP13.PXSX` 。

## 注意事项

- 按照 **补丁组合** 要求，须同时使用 ***SSDT-PTSWAK*** 和 ***SSDT-NDGP_OFF*** 【或者 ***SSDT-NDGP_PS3*** 】
- 如果 ***SSDT-NDGP_OFF*** 和 ***SSDT-NDGP_PS3*** 均满足使用要求，优先使用 ***SSDT-NDGP_OFF***

**注** ：以上主要内容来自 [@RehabMan](https://github.com/rehabman)
