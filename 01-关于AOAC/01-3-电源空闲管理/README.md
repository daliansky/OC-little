# 电源空闲管理

## 描述

- 本补丁开启MAC系统自身的电源空闲管理，延长电池工作模式下的待机时间。
- 参阅：<https://pikeralpha.wordpress.com/2017/01/12/debugging-sleep-issues/>。

## SSDT补丁

- ***SSDT-DeepIdle*** ——电源空闲管理补丁


## 注意事项

- ***SSDT-DeepIdle*** 和 `S3` 睡眠可能有严重冲突，使用 ***SSDT-DeepIdle*** 应避免 `S3` 睡眠，参见《禁止S3睡眠》
- ***SSDT-DeepIdle*** 可能会导致机器唤醒困难，可以通过补丁解决这个问题，参见《AOAC唤醒补丁》
- 试验确定使用 `0D6D` 补丁是否更有利于电源空闲管理。有关 `0D6D` 补丁方面的内容参考《0D6D补丁》

## 备注

- ***SSDT-DeepIdle*** 主要内容来自 @Pike R.Alpha

