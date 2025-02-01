# Revanced & Revanced Extended YouTube Module (rv.x)

**Current Version:** 19.47.53

This repository contains a module for patching YouTube using ReVanced and ReVanced Extended. It is designed to work with both Magisk, APatch and KernelSU environments by supporting two mounting methods:

- **susfs (KernelSU):** If the susfs binary exists (i.e. `/data/adb/ksu/bin/ksu_susfs`), the module will use susfs commands to bind‑mount the patched APK.
- **Dynamic Mount:** If susfs is not available, the module falls back to a dynamic mount method.

Additionally, the module automatically downgrades YouTube to the target version (if needed) before installation and includes an inbuilt detach function (`detachyt.sh`) that is executed on every boot.

---

## Features

- **Dual Mounting Support:**  
  - Uses susfs when KernelSU is available.
  - Falls back to dynamic mounting on non‑KernelSU devices.

- **Detach on Boot:**  
  - Executes the `detachyt.sh` function at every boot to ensure that the patched APK is properly detached from the stock app.

---

## Installation

1. **Prerequisites:**
   - Rooted by Magisk or APatch or KernelSu.
   - [Process monitor](https://github.com/HuskyDG/magic_proc_monitor/releases/tag/v2.3) for non Susfs users.

2. **Module Installation:**
   - Copy the desired module ZIP file (either `RevancedExtented-Youtube-rvx.zip` or `Revanced-Youtube-rv.zip`) to your device.
   - Open your Root Manager and select the option to install a module from the ZIP file.
   - After installation, reboot your device.

---

## How It Works

- **Boot-Time Checks:**  
  Upon boot, the `service.sh` script performs the following:
  - **susfs Detection:**  
    Checks if `/data/adb/ksu/bin/ksu_susfs` exists. If it does, the module uses susfs functions (`add_sus_kstat`, `update_sus_kstat`, and `add_sus_mount`) to overlay the patched APK.
  - **Fallback to Dynamic Mount:**  
    If susfs is not detected, the script falls back to a dynamic mounting method.
  - **APK Version Downgrade:**  
    The script compares the installed YouTube version with the target version. If they differ, it installs a base APK to downgrade YouTube before applying the mount.
  - **Detach Functionality:**  
    The module executes `detachyt.sh` on every boot to ensure that the patched APK remains detached from the stock app.

---

## Usage

- **For KernelSU Users:**  
  Make sure susfs is installed. The module will automatically detect it and use susfs for a seamless overlay of the patched APK.

- **For Non-KernelSU Users:**  
  The module will use the dynamic mount method. If you encounter issues (such as warnings about process monitoring), please follow any additional on‑screen prompts or recommendations.

---

## Disclaimer

> **Note:**  
> I am new to coding and module development, so this module is provided "as-is" without any guarantees. There may be bugs or issues that I have not yet encountered. Contributions, suggestions, and bug reports are welcome, but please understand that I am not an expert.

Always back up your data before installing any system-level modifications.

---

## License

This project is licensed under the [GPL-3.0 License](LICENSE).

---

## Credits

- **ReVanced Team:** For the original ReVanced patches and resources.
- **Various Revanced magisk module developers:** For inspiration of different inject methods, patches and resources.
- **APatch, KernelSU & especially Magisk Communities:** For inspiring a various approach to module development.
- **XDA Developers & Community Forums:** For continuous support and discussions.
- **You, the User:** For testing, feedback, and contributions.

---
