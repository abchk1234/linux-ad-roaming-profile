1. Configure DNS to set address of server and one fallback (192.168.1.191, 8.8.8.8). Alternatively, set DNS of server in router itself to apply for all clients.

2. Install PBIS Open using repo https://repo.pbis.beyondtrust.com/

 `sudo apt-get install pbis-open`

3. Leave Old Domain (if enabled).

4. Join domain

 `sudo domainjoin-cli join --disable ssh server.lan`

5. Install utils for folder mounting

 `sudo apt-get install libpam-mount cifs-utils`

5.a Edit _/etc/security/pam_mount.conf.xml_ for user mount (provided).

6. Sudo for the user (if needed):

6.a. Editing sudoers file to allow admin users for sudo.

6.b. Editing pam_mount template (provided) and regenarating config (sudo pam-auth-update).

7. Install osync for syncing (https://github.com/deajan/osync).

7.a. Copy provided sync related scripts to /usr/local/bin

8. Copy lightdm config (provided).

9. Copy /etc/rc.local (provided).

10. RESTART before logging in!

11. Login as user (DOMAIN\username)

12. Add .xprofile (provided) and other home folder files:

13. Logout and login to check if sync starts working.

14. Testing same user on another system to verify if roaming profile is working.


### Things to consider

* Change /etc/NetworkManager/NetworkManager.conf to disable dnsmasq for reliability.

### Links

* https://linoxide.com/ubuntu-how-to/configure-pbis-join-ubuntu-windows-ad/
* https://github.com/BeyondTrust/pbis-open/wiki/Documentation
* https://askubuntu.com/questions/137037/networkmanager-not-populating-resolv-conf
