# Tools for PenTest Container

Ur host OS could keep wordlist txt files, lin, win, and exe's like Winpeas, ligolo agents, etc in the /opt/Utils folder which the container could then mount so as to share.
But you would want the below tools installed so you could use them from the container.

The goal is to keep the environment easy to move between machines while still giving you a repeatable toolbox.

# Ideal tools for the container:

## Main Pentesting Tools:

## Network
snmp-mibs-downloader\
snmpwalk\
onesixtyone\
nmap\
nmap scripts\
rpcclient\
nslookup\
mount\
ctfr-python\
dig, ftp, telnet

## AD
nxc\
nmap\
impacket\
bloodyAD\
evil-winrm\
xfreerdp3\
certipy\

## Windows Priv Esc
msfvenom\
metasploit

## Web
## Passive Recon
go\
amass\
spiderfoot\
hakrawler\
reconspider\
waybackurls\
subfinder\
puredns\
sourcefinder\
csprecon

## Active Recon
ffuf\
sqlmap\
feroxbuster\
alterx\
nikto for v old web\
gitdumper\
nuclei\
wpscan\

## Cloud
AWS cli\
Windows VM\
InternalsAllTheThings\
AADInternals\
