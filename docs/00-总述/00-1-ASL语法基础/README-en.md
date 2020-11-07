# ACPI Source Language

> This guide is quoted from PCBeta, Published at 2011-11-21 11:16:20,Author:suhetao.
>
> Markdowned and proofread by Bat.bat(williambj1) on 2020-2-14.
>
> <http://bbs.pcbeta.com/forum.php?mod=viewthread&tid=944566&archive=2&extra=page%3D1&page=1>

## Foreword

I am not a BIOS developer, the following contents are based on the understanding of `ACPI Specification` ~~<http://www.acpi.info/>~~ [Invalid, has been transfered to <https://uefi.org>]. As such, I am not able to avoid some misunderstandings and mistaken views, and hope you are able to adjust and improve them.

## Descrption

First of all, it is neccessary to differentiate DSDT (Differentiated System Description Table Fields) and SSDT (Secondary System Description Table Fields). They are all forms of `Advanced Configuration & Power Interface`, of which is abbreviated as `ACPI`. Literally, we perceive it as a series of tables to describe the interfaces. As a result, the major function of `ACPI` is to provide operating systems some serivces and information. DSDT and SSDT are not excepted. A notable feature of `ACPI` is using a specific language to make ACPI tables. This language, ASL (ACPI Source Language), is the core of this article. We compile ASL to AML(ACPI Machine Language) by specific softwares, in turn, executed by the operating system. Since ASL is a type of language, it must have its roles.


## ASL Roles

1. The variable must not exceed 4 
characters, and not begin with digitals. Just check any DSDT/SSDT, no exceptions.

1. `Scope` is similar to `{}`. There is one and there is only one `Scope`. Therefore, DSDT begins with

   ```swift
   DefinitionBlock ("xxxx", "DSDT", 0x02, "xxxx", "xxxx", xxxx)
   {
   ```

   and ended by

   ```swift
   }
   ```

   This is `root Scope`.

   `xxxx` parameters refer to `File Name`、`OEMID`、`Table ID`、`OEM Version`. The third parameter is based on the second parameter. As shown above, if the second parameter is **`DSDT`**, in turn, the third parameter is`0x02`. Other parameters are free to fill in.

2. Those methods and variables begin with `_` are reserved by operating systems. that is why some ASL tables contain `_T_X` trigger warnings after decompilation.

   
3. `Method` can be defined followed by `Device` or `Scope`. As such, `method` cannot be defined without `Scope`, and the instances listed below are **invalid**.

   ```swift
   Method (xxxx, 0, NotSerialized)
   {
       ...
   }
   DefinitionBlock ("xxxx", "DSDT", 0x02, "xxxx", "xxxx", xxxx)
   {
       ...
   }
   ```

4. `\_GPE`,`\_PR`,`\_SB`,`\_SI`,`\_TZ` belong to root scope `\`.

   - `\_GPE`--- ACPI Event handlers
   - `\_PR` --- CPU
   - `\_SB` --- Devices and buses
   - `\_SI` --- System indicator
   - `\_TZ` --- Thermal zone

   > **Components with different atrributes place under corresponding scopes. For examples:**

   - `Device (PCI0)` places under `Scope (\_SB)`

     ```swift
     Scope (\_SB)
     {
         Device (PCI0)
         {
             ...
         }
         ...
     }
     ```

   - Components relate to CPU place under

     > different CPUs place variously, common scopes for instance `_PR`,`_SB`,`SCK0`

     ```swift
     Scope (_PR)
     {
         Processor (CPU0, 0x00, 0x00000410, 0x06)
         {
             ...
         }
         ...
     }
     ```

   - `Scope (_GPE)` places event handlers

      ```swift
      Scope (_GPE)
      {
          Method (_L0D, 0, NotSerialized)
          {
              ...
          }
          ...
      }
      ```

      Yes, methods can be placed here. Caution, methods begin with **`_`** are reserved by operating systems.

5. `Device (xxxx)` also can be recognised as a scope, it cotains various descriptions to devices, e.g. `_ADR`,`_CID`,`_UID`,`_DSM`,`_STA`.

6. Symbol `\` quotes the root scope; `^` quotes the superior scope. Similarly,`^` is superior to `^^`.

7. Symbol `_` is meaningless, it only completes the 4 characters, e.g. `_OSI`.

8. For better understanding, ACPI releases `ASL+(ASL2.0)`, it introduces C language's `+-*/=`, `<<`, `>>` and logical judgment `==`, `!=` etc.

9. Methods in ASL can accept up to 7 arguments; they are represented by `Arg0` to `Arg6` and cannot be customised.

10. Local Variables in ASL can accept up to 8 arguments；they are represented by `Local0`~`Local7`. Definitions is not necessary, but should be initialised, in other words, assignment is needed.

## ASL Common Type of Data

|    ASL    |  
| :-------: | 
| `Integer` | 
| `String`  |  
|  `Event`  |  
| `Buffer`  |  
| `Package` | 

## ASL Variables Definition

- Define Integer

  ```swift
  Name (TEST, 0)
  ```

- Define String
  
  ```swift
  Name (MSTR,"ASL")
  ```

- Define Package

  ```swift
  Name (_PRW, Package (0x02)
  {
      0x0D,
      0x03
  })
  ```

- Define Buffer Field

  > Buffer Field 6 types in total:

|     Create statement     |   size   |
| :--------------: | :------: |
|  CreateBitField  |  1-Bit   |
| CreateByteField  |  8-Bit   |
| CreateWordField  |  16-Bit  |
| CreateDWordField |  32-Bit  |
| CreateQWordField |  64-Bit  |
|   CreateField    | any sizes |

  ```swift
  CreateBitField (AAAA, Zero, CCCC)
  CreateByteField (DDDD, 0x01, EEEE)
  CreateWordField (FFFF, 0x05, GGGG)
  CreateDWordField (HHHH, 0x06, IIII)
  CreateQWordField (JJJJ, 0x14, KKKK)
  CreateField (LLLL, Local0, 0x38, MMMM)
  ```

It is not necessary to announce its type when defining a variable.

## ASL Assignment

```swift
Store (a,b) /* legacy ASL */
b = a      /*   ASL+  */
```

Examples:

```swift
Store (0, Local0)
Local0 = 0

Store (Local0, Local1)
Local1 = Local0
```

## ASL Calculation

|  ASL+  |  Legacy ASL  |     Examples                                                         |
| :----: | :--------: | :----------------------------------------------------------- |
|   +    |    Add     |    `Local0 = 1 + 2`<br/>`Add (1, 2, Local0)`                    |
|   -    |  Subtract  |     `Local0 = 2 - 1`<br/>`Subtract (2, 1, Local0)`               |
|   *    |  Multiply  |     `Local0 = 1 * 2`<br/>`Multiply (1, 2, Local0)`               |
|   /    |   Divide   |    `Local0 = 10 / 9`<br/>`Divide (10, 9, Local1(remainder), Local0(result))` |
|   %    |    Mod     |     `Local0 = 10 % 9`<br/>`Mod (10, 9, Local0)`                  |
|   <<   | ShiftLeft  |      `Local0 = 1 << 20`<br/>`ShiftLeft (1, 20, Local0)`           |
|   >>   | ShiftRight |    `Local0 = 0x10000 >> 4`<br/>`ShiftRight (0x10000, 4, Local0)` |
|   --   | Decrement  |   `Local0--`<br/>`Decrement (Local0)`                          |
|   ++   | Increment  |   `Local0++`<br/>`Increment (Local0)`                          |
|   &    |    And     |      `Local0 = 0x11 & 0x22`<br/>`And (0x11, 0x22, Local0)`        |
| &#124; |     Or     |        `Local0 = 0x01`&#124;`0x02`<br/>`Or (0x01, 0x02, Local0)`  |
|   ~    |    Not     |   `Local0 = ~(0x00)`<br/>`Not (0x00,Local0)`                   |
|      |    Nor     |    `Nor (0x11, 0x22, Local0)`                                   |

Read `ACPI Specification` for details

## ASL Logic

|  ASL+  |   Legacy ASL  | Examples             |
| :----: | :-----------: | :----------------------------------------------------------- |
|   &&   |     LAnd      |  `If (BOL1 && BOL2)`<br/>`If (LAnd(BOL1, BOL2))`              |
|   !    |     LNot      |  `Local0 = !0`<br/>`Store (LNot(0), Local0)`                  |
| &#124; |      LOr      |  `Local0 = (0`&#124;`1)`<br/>`Store (LOR(0, 1), Local0)`    |
|   <    |     LLess     |  `Local0 = (1 < 2)`<br/>`Store (LLess(1, 2), Local0)`         |
|   <=   |  LLessEqual   |  `Local0 = (1 <= 2)`<br/>`Store (LLessEqual(1, 2), Local0)`   |
|   >    |   LGreater    |  `Local0 = (1 > 2)`<br/>`Store (LGreater(1, 2), Local0)`      |
|   >=   | LGreaterEqual |  `Local0 = (1 >= 2)`<br/>`Store (LGreaterEqual(1, 2), Local0)` |
|   ==   |    LEqual     |  `Local0 = (Local0 == Local1)`<br/>`If (LEqual(Local0, Local1))` |
|   !=   |   LNotEqual   |  `Local0 = (0 != 1)`<br/>`Store (LNotEqual(0, 1), Local0)`    |

Only two results from logical calculation - `0` or `1`

## ASL Definition of Method

1. Define a Method

   ```swift
   Method (TEST)
   {
       ...
   }
   ```

2. Define a method contains 2 parameters, and apply local variables`Local0`~`Local7`

   Numbers of parameters are defaulted as `0`

   ```swift
   Method (MADD, 2)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1
   }
   ```


3. Define a method contains a return value
  
   ```swift
   Method (MADD, 2)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1

       Return (Local0) /* return here */
   }
   ```

   

   ```swift
   Local0 = 1 + 2            /* ASL+ */
   Store (MADD (1, 2), Local0)  /* Legacy ASL */
   ```

4. Define serialised method

   If not define `Serialized` or `NotSerialized`, default as `NotSerialized`

   ```swift
   Method (MADD, 2, Serialized)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1
       Return (Local0)
   }
   ```

   It looks like `multi-thread synchronisation`. In other words, only one instance can be existed in the memory when the method is stated as `Serialized`. Normally the application create one object, for example:

   ```swift
   Method (TEST, Serialized)
   {
       Name (MSTR,"I will sucess")
   }
   ```

   If we state `TEST` shown above，and call it from two different methods:

   ```swift
   Device (Dev1)
   {
        TEST ()
   }
   Device (Dev2)
   {
        TEST ()
   }
   ```
If we execute `TEST` in `Dev1`, then `TEST` in `Dev2` will wait until the first one finalised. If we state:

   ```swift
   Method (TEST, NotSerialized)
   {
       Name (MSTR, "I will sucess")
   }
   ```

   when one of `TEST` called from `Devx`, another `TEST` will be failed to create `MSTR`.

## ACPI Preset Function

### `_OSI`  (Operating System Interfaces)

It is easy to acquire the current operating system's name and version when applying `_OSI`. For example, we could apply a patch that is specific to Windows or MacOS.

`_OSI` requires a string, the string must be picked from the table below.

|                 OS                  |      String      |
| :---------------------------------------: | :--------------: |
|                   macOS                   |    `"Darwin"`    |
| Linux<br/>(Including OS based on Linux kernel) |    `"Linux"`     |
|                  FreeBSD                  |   `"FreeBSD"`    |
|                  Windows                  | `"Windows 20XX"` |

> Notably，different Windows versions requre a unique string，read：
>
> <https://docs.microsoft.com/en-us/windows-hardware/drivers/acpi/winacpi-osi>

When `_OSI`'s string matchs the current system, it returns `1`, `If` condition is valid.

```swift
If (_OSI ("Darwin")) /* judge if the current system is macOS */
```

### `_STA` (Status)

**Caution⚠️: two types of `_STA`，do not mix up`_STA`from`PowerResource`！！！**

5 types of bit can be return from `_STA` method, explanations are listed below:

| Bit   | Explanations                           |
| :-----: | :----------------------------- |
| Bit [0] | Set if the device is present.                   |
| Bit [1] | Set if the device is enabled and decoding its resources. |
| Bit [2] | Set if the device should be shown in the UI.         |
| Bit [3] | Set if the device is functioning properly (cleared if device failed its diagnostics).            |
| Bit [4] | Set if the battery is present.             |

We need to transfer these bits from hexadecimal to binary. `0x0F` transfered to `1111`, meaning enable it(the first four bits); while `Zero` means disable. 

We also encounter `0x0B`,`0x1F`. `1011` is a binary form of `0x0B`, meaning the device is enabled and not is not allowed to decode its resources. `0X0B` often utilised in **`SSDT-PNLF`**. `0x1F` (`11111`)only appears to describe battery device from laptop, the last bit is utilised to inform Control Method Battery Device `PNP0C0A` that the battery is present.

> In terms of `_STA` from `PowerResource`
>
> `_STA` from `PowerResource` only returns `One` or `Zero`. Please read `ACPI Specification` for detail.

### `_CRS` (Current Resource Settings)
`_CRS` returns a `Buffer`, it is often utilised to acquire touchable devices' `GPIO Pin`,`APIC Pin` for controlling the interrupt mode.


## ASL flow Control

ASL also has its method to control flow.

- Switch
  - Case
  - Default
  - BreakPoint
- While
  - Break
  - Continue
- If
  - Else
  - ElseIf
- Stall

### Branch control `If` & `Switch`

#### `If`

   The following codes check if the system is `Darwin`, if yes then`OSYS = 0x2710`

   ```swift
   If (_OSI ("Darwin"))
   {
       OSYS = 0x2710
   }
   ```

#### `ElseIf`, `Else`

   The following codes check if the system is `Darwin`, and if the system is not `Linux`, if yes then `OSYS = 0x07D0`

   ```swift
   If (_OSI ("Darwin"))
   {
       OSYS = 0x2710
   }
   ElseIf (_OSI ("Linux"))
   {
       OSYS = 0x03E8
   }
   Else
   {
       OSYS = 0x07D0
   }
   ```

#### `Switch`, `Case`, `Default`, `BreakPoint`

   ```swift
   Switch (Arg2)
   {
       Case (1) /* Condition 1 */
       {
           If (Arg1 == 1)
           {
               Return (1)
           }
           BreakPoint /* Mismatch condition, exit */
       }
       Case (2) /* Condition 2 */
       {
           ...
           Return (2)
       }
       Default /* if condition is not match，then */
       {
           BreakPoint
       }
   }
   ```


### Loop control

#### `While` & `Stall`

```swift
Local0 = 10
While (Local0 >= 0x00)
{
    Local0--
    Stall (32)
}
```

`Local0` = `10`,if `Local0` ≠ `0` is false, `Local0`-`1`, stall `32μs`, the codes delay `10 * 32 = 320 μs`。

#### `For`

`For` from `ASL` is similar to `C`, `Java`

```swift
for (local0 = 0, local0 < 8, local0++)
{
    ...
}
```

`For` shown above and `While` shown below are equivalent

```swift
Local0 = 0
While (Local0 < 8)
{
    Local0++
}
```

## `External` Quote

|    Quote Types    | External SSDT Quote| Quoted    |
| :------------: | :------------: |  :------------------------------------ |
|   UnknownObj    | `External (\_SB.EROR, UnknownObj`             | (avoid to use)                          |
|     IntObj        | `External (TEST, IntObj`                      | `Name (TEST, 0)`                                                        |
|     StrObj        | `External (\_PR.MSTR, StrObj`                 | `Name (MSTR,"ASL")`                                                     |
|    BuffObj       | `External (\_SB.PCI0.I2C0.TPD0.SBFB, BuffObj` | `Name (SBFB, ResourceTemplate ()`<br/>`Name (BUF0, Buffer() {"abcde"})` |
|     PkgObj      | `External (_SB.PCI0.RP01._PRW, PkgObj`        | `Name (_PRW, Package (0x02) { 0x0D, 0x03 })`                            |
|  FieldUnitObj     | `External (OSYS, FieldUnitObj`                | `OSYS,   16,`                                                           |
|   DeviceObj       | `External (\_SB.PCI0.I2C1.ETPD, DeviceObj`    | `Device (ETPD)`                                                         |
|    EventObj       | `External (XXXX, EventObj`                    | `Event (XXXX)`                                                          |
|   MethodObj        | `External (\_SB.PCI0.GPI0._STA, MethodObj`    | `Method (_STA, 0, NotSerialized)`                                       |
|    MutexObj       | `External (_SB.PCI0.LPCB.EC0.BATM, MutexObj`  | `Mutex (BATM, 0x07)`                                                    |
|  OpRegionObj      | `External (GNVS, OpRegionObj`                 | `OperationRegion (GNVS, SystemMemory, 0x7A4E7000, 0x0866)`              |
|  PowerResObj     | `External (\_SB.PCI0.XDCI, PowerResObj`       | `PowerResource (USBC, 0, 0)`                                            |
|  ProcessorObj      | `External (\_SB.PR00, ProcessorObj`           | `Processor (PR00, 0x01, 0x00001810, 0x06)`                              |
| ThermalZoneObj    | `External (\_TZ.THRM, ThermalZoneObj`         | `ThermalZone (THRM)`                                                    |
|  BuffFieldObj      | `External (\_SB.PCI0._CRS.BBBB, BuffFieldObj` | `CreateField (AAAA, Zero, BBBB)`                                        |

> DDBHandleObj is rare, no discussion


## ASL CondRefOf

`CondRefOf` is useful to check the object is existed or not.

```swift
Method (SSCN, 0, NotSerialized)
{
    If (_OSI ("Darwin"))
    {
        ...
    }
    ElseIf (CondRefOf (\_SB.PCI0.I2C0.XSCN))
    {
        If (USTP)
        {
            Return (\_SB.PCI0.I2C0.XSCN ())
        }
    }

    Return (Zero)
}
```

The codes are quoted from **`SSDT-I2CxConf`**. When system is not MacOS, and `XSCN` exists under `I2C0`, it returns the orginal value.

## Conclusion
Hoping this article assists you when you are editing DSDT/SSDT.
