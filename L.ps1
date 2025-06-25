### PowerShell Reverse Shell – Plain English Breakdown
### I cannot provide the powershell script for obvious reasons, if i provided the entire script it will be flagged.

### But i will be providing steps so that you can write it yourself.

<#⚠️ Disclaimer
This project is intended solely for educational and ethical research purposes.
It is designed to help cybersecurity students, red teamers, and penetration testers understand how reverse shells operate in controlled environments.

Do not use this code on any system or network that you do not own or have explicit written permission to test. Unauthorized use of these techniques may be illegal and unethical.

The author(s) of this repository do not condone or support any form of malicious activity and assume no liability for misuse of this content.
#>

<#
1. **Set the IP address of the attacker's machine** — this is the system that will receive the reverse shell connection.

2. **Pick a port number** that the attacker is listening on — for example, port 1111.

3. **Try to open a network connection** (a TCP client) from the victim's machine to the attacker's IP and port.

4. Once the connection is open:

   * Start reading and writing messages over the connection.
   * Get ready to send text to the attacker.
   * Also prepare to read text (commands) from the attacker.

5. **Send a message back** to the attacker to confirm that the reverse shell is connected successfully.

6. Enter a loop that runs forever:

   * Wait for a command to come in from the attacker.
   * If the command is missing or says "exit", break the loop and stop everything.
   * Otherwise, try to run the command using PowerShell on the victim's machine.

     * If the command runs successfully, capture the output.
     * If there's an error, capture the error message instead.
   * Send whatever output or error you got back to the attacker's machine.

7. If the original connection fails for any reason, show an error saying the connection didn’t work.

8. When everything is done or something goes wrong, close:

   * The writer (sending messages),
   * The reader (receiving commands),
   * The network stream,
   * And the client connection itself — to clean up resources.

#>
