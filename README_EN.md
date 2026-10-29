# Sisoog — Xilinx ISE Windows 11 Compatibility Patch

**English** | [فارسی](README.md)

A small batch script that automatically applies the `libPortability.dll` files required to run **Xilinx ISE Design Suite 14.7** on **Windows 11**, without doing the file copying by hand. It also fixes **ISim getting stuck on "Elaborating"**.

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
ISE_DS\.xinstall\bin\nt64
```

**32-bit (`nt`) file is copied to:**

```
ISE_DS\.xinstall\bin\nt
ISE_DS\common\lib\nt
ISE_DS\EDK\lib\nt
ISE_DS\ISE\lib\nt
ISE_DS\ISE\sysgen\bin\nt
```

Before overwriting any file, the script backs up the original as `libPortability.dll.bak` in the same folder (only on the first run, so re-running the script never overwrites a good backup). Read-only, hidden and system attributes are cleared before copying, so files such as the ones under `.xinstall` do not fail with "Access is denied".

### ISim fix (`libPortabilityNOSH.dll`)

When you run **Simulate Behavioral Model**, ISim's `fuse` copies `libPortabilityNOSH.dll` from the ISE installation into the project's `isim\<name>.exe.sim\` folder under the name `libPortability.dll`. If that file is not patched, ISim stays stuck on "Elaborating". To fix this, the script also overwrites these two files (with a `.bak` backup):

```
ISE_DS\ISE\lib\nt64\libPortabilityNOSH.dll
ISE_DS\ISE\lib\nt\libPortabilityNOSH.dll
```

New projects then get the patched DLL automatically. If a project was simulated **before** applying the patch, delete its `isim` folder once so it is rebuilt.

## Folder structure

Place the script in any folder under `C:\Xilinx`, alongside the patched DLLs:

```
C:\Xilinx\
    ├── 14.7
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
3. Close ISE and ISim (including any leftover `isimgui.exe` in Task Manager).
4. Right-click `Sisoog ISE Win11 Fix.bat` → **Run as administrator**.
5. Press any key at the start screen.
6. Wait for the **SUCCESS** (green) or **FAILED** (red) result screen.

## Restoring the original files

Each patched folder keeps a `libPortability.dll.bak` copy of the original file it replaced (and `libPortabilityNOSH.dll.bak` for the ISim fix). To undo the patch, rename each `.bak` file back to its original name in each of the folders listed above.

## Disclaimer

This is an unofficial community workaround, not provided or endorsed by AMD/Xilinx. Use at your own risk.

## Author

**Abbas Ghalavandi**

## License

MIT
