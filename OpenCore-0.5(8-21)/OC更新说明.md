# 8月21号**`OC0.5+`**更新说明

- 更新BOOTx64.efi、OpenCore.efi。

- config新增`Uefi\Quirks\ClearScreenOnModeSwitch`、`Uefi\Quirks\ReplaceTabWithSpace`。

  - `ClearScreenOnModeSwitch`

    当从图形模式切换到文本模式时，某些机器会残留切换前的部分内容。此选项在切换到文本模式之前将整个屏幕填充黑色。

    Uefi\Protocols\ConsoleControl设置为true才能使其工作。

  - `ReplaceTabWithSpace`

    一些机器在Shell状态下无字符输出。

    Uefi\Protocols\ConsoleControl设置为true才能使其工作。

- config新增项目见`新增0821.plist`。

