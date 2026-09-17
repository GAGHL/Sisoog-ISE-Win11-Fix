# Sisoog — Xilinx ISE Windows 11 Compatibility Patch

A small batch script that automatically applies the `libPortability.dll` files required to run **Xilinx ISE Design Suite 14.7** on **Windows 11**, without doing the file copying by hand.

## Persian Tutorial

A Persian-language tutorial on installing and using this method is available on the Sisoog website:
[Installing Xilinx ISE on Windows 11 Using the Sisoog Method](https://sisoog.com/xilinx-ise-installation-on-windows-11-using-sisoog-method/)

## What it does

Xilinx ISE 14.7 predates Windows 11, and installing it on this version of Windows comes with issues. To install it on Windows 11, you first need to install the software following the tutorial above, and then copy the required DLLs into several folders inside the ISE installation. This script automates that copy step and takes a backup of every file it overwrites.

**64-bit (`nt64`) file is copied to:**

```
ISE_DS\ISE\sysgen\bin\nt64
ISE_DS\ISE\bin\nt64
ISE_DS\EDK\lib\nt64\sdk
ISE_DS\EDK\lib\nt64
ISE_DS\ISE\lib\nt64
ISE_DS\common\lib\nt64
ISE_DS\xinstall\bin\nt64
```

**32-bit (`nt`) file is copied to:**

```
ISE_DS\EDK\lib\nt
ISE_DS\ISE\lib\nt
ISE_DS\common\lib\nt
```

Before overwriting any file, the script backs up the original as `libPortability.dll.bak` in the same folder (only on the first run, so re-running the script never overwrites a good backup).

## Folder structure

Place the script in any folder under `C:\Xilinx`, alongside the patched DLLs:

```
C:\Xilinx\
└── Sisoog ISE Win11 Fix\
    ├── Sisoog ISE Win11 Fix.bat
    ├── nt\
    │   └── libPortability.dll
    └── nt64\
        └── libPortability.dll
```

The script automatically walks up one folder from its own location and searches for the `ISE_DS` installation folder underneath it.

## Usage

1. Download this repository.
2. Copy the folder to `C:\Xilinx\` (or any subfolder of it).
3. Right-click `Sisoog ISE Win11 Fix.bat` → **Run as administrator**.
4. Press any key at the start screen.
5. Wait for the **SUCCESS** (green) or **FAILED** (red) result screen.

## Restoring the original files

Each patched folder keeps a `libPortability.dll.bak` copy of the original file it replaced. To undo the patch, rename `libPortability.dll.bak` back to `libPortability.dll` in each of the folders listed above.

## Disclaimer

This is an unofficial community workaround, not provided or endorsed by AMD/Xilinx. Use at your own risk.

## Author

**Abbas Ghalavandi**

## License

MIT
