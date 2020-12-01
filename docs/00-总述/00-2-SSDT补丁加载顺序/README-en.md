# SSDT loading sequence

- Generally speaking, we apply SSDTs for a specific machine(its DSDT or other SSDTs),the loading sequence of the orginal ACPI has higher priority than the SSDT patches that we made. Therefore, the SSDT patches **do not have** a loading sequence under `Add`. 
- There is an exception. If the SSDT defines a `device`, and also utilises `Scope` to quote the `device` from another SSDT, the sequence is **required**.

## Examples

- Patch 1：**SSDT-XXXX-1.aml**
  
  ```Swift
  External (_SB.PCI0.LPCB, DeviceObj)
  Scope (_SB.PCI0.LPCB)
  {
      Device (XXXX)
      {
          Name (_HID, EisaId ("ABC1111"))
      }
  }
  ```
  
- Patch 2：**SSDT-XXXX-2.aml**

  ```Swift
  External (_SB.PCI0.LPCB.XXXX, DeviceObj)
  Scope (_SB.PCI0.LPCB.XXXX)
  {
        Method (YYYY, 0, NotSerialized)
       {
           /* do nothing */
       }
    }
  ```
  
- `Add` loading sequence

  ```XML
  Item 1
            path    <SSDT-XXXX-1.aml>
  Item 2
            path    <SSDT-XXXX-2.aml>
  ```
