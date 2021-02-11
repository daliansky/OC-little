/*
 * Add XOSI-I2C Device with Darwin method.
 */
DefinitionBlock ("", "SSDT", 2, "HACK", "I2C-XOSI", 0x00000000)
{
    External (_SB_.PCI0.I2C0.ETPD, DeviceObj)
    External (_SB_.PCI0.I2C0.TPAD, DeviceObj)
    External (_SB_.PCI0.I2C0.TPD0, DeviceObj)
    External (_SB_.PCI0.I2C0.TPD1, DeviceObj)
    External (_SB_.PCI0.I2C0.TPL0, DeviceObj)
    External (_SB_.PCI0.I2C0.TPL1, DeviceObj)
    External (_SB_.PCI0.I2C1.ETPD, DeviceObj)
    External (_SB_.PCI0.I2C1.TPAD, DeviceObj)
    External (_SB_.PCI0.I2C1.TPD0, DeviceObj)
    External (_SB_.PCI0.I2C1.TPD1, DeviceObj)
    External (_SB_.PCI0.I2C1.TPL0, DeviceObj)
    External (_SB_.PCI0.I2C1.TPL1, DeviceObj)

    If (CondRefOf (\_SB.PCI0.I2C0.TPD0)) {
        Scope (\_SB.PCI0.I2C0.TPD0) {
            If (_OSI ("Darwin")) {
                Name (OSYS, 0x07DC)
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.I2C0.TPD1)) {
        Scope (\_SB.PCI0.I2C0.TPD1) {
            If (_OSI ("Darwin")) {
                Name (OSYS, 0x07DC)
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.I2C0.TPL0)) {
        Scope (\_SB.PCI0.I2C0.TPL0) {
            If (_OSI ("Darwin")) {
                Name (OSYS, 0x07DC)
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.I2C0.TPL1)) {
        Scope (\_SB.PCI0.I2C0.TPL1) {
            If (_OSI ("Darwin")) {
                Name (OSYS, 0x07DC)
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.I2C0.TPAD)) {
        Scope (\_SB.PCI0.I2C0.TPAD) {
            If (_OSI ("Darwin")) {
                Name (OSYS, 0x07DC)
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.I2C0.ETPD)) {
        Scope (\_SB.PCI0.I2C0.ETPD) {
            If (_OSI ("Darwin")) {
                Name (OSYS, 0x07DC)
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.I2C1.TPD0)) {
        Scope (\_SB.PCI0.I2C1.TPD0) {
            If (_OSI ("Darwin")) {
                Name (OSYS, 0x07DC)
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.I2C1.TPD1)) {
        Scope (\_SB.PCI0.I2C1.TPD1) {
            If (_OSI ("Darwin")) {
                Name (OSYS, 0x07DC)
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.I2C1.TPL0)) {
        Scope (\_SB.PCI0.I2C1.TPL0) {
            If (_OSI ("Darwin")) {
                Name (OSYS, 0x07DC)
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.I2C1.TPL1)) {
        Scope (\_SB.PCI0.I2C1.TPL1) {
            If (_OSI ("Darwin")) {
                Name (OSYS, 0x07DC)
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.I2C1.TPAD)) {
        Scope (\_SB.PCI0.I2C1.TPAD) {
            If (_OSI ("Darwin")) {
                Name (OSYS, 0x07DC)
            }
        }
    }

    If (CondRefOf (\_SB.PCI0.I2C1.ETPD)) {
        Scope (\_SB.PCI0.I2C1.ETPD) {
            If (_OSI ("Darwin")) {
                Name (OSYS, 0x07DC)
            }
        }
    }
}