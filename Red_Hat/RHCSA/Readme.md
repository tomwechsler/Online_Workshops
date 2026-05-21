# 📢 Prüfungsvorbereitung RHCSA (EX200)
Praktische Prüfungsvorbereitung für die Red Hat Certified System Administrator (RHCSA, EX200)

## Kursleiter
mit Tom Wechsler (https://www.linkedin.com/in/tom-wechsler)

## Informationen
⏰ Dauer: 6 Nachmittage (jeweils 13:00 - 17:00 Uhr) einmal pro Woche  
🗓️ Startdatum:   
🗓️ Enddatum:   
💸 Preis pro TeilnehmerIn: Euro 1'600.- (für Anmeldungen aus der Schweiz - CHF 1'600.- exkl. MwSt.)  
📍 Plattform: Microsoft Teams (Online Kurs)  
➡️ Alle Kursnachmittage werden aufgezeichnet und stehen den TeilnehmerInnen online zur Verfügung  
🗓️ **Anmeldefrist:**

> Hinweis: Jede Teilnehmerin und jeder Teilnehmer erhalten eine Bestätigung der Kurs-Teilnahme.

Anmeldung: Schreiben Sie eine Email an training@videotrainer.ch mit dem Betreff "RHCSA".

## Beschreibung
Die Zertifizierung "RHCSA (EX200)" überprüft die praktischen Fähigkeiten von Systemadministrator:innen in Red Hat Enterprise Linux (RHEL). Die Prüfung ist performancebasiert (Lab) und erfordert, dass Aufgaben direkt auf einer Linux-Umgebung gelöst werden. In diesem Kurs erwerben die Teilnehmenden praxisnahe Kenntnisse in Installation, Konfiguration, Verwaltung von Diensten, Netzwerk, Storage, Sicherheit (SELinux) und Troubleshooting auf RHEL-basierten Systemen.

## Ziel der Prüfungsvorbereitung
Ziel ist es, Sie strukturiert und praxisorientiert auf die EX200-Prüfung vorzubereiten: Prüfungsrelevante Themen werden erklärt, typische Aufgaben in praktischen Übungen bearbeitet und Prüfungsstrategien vermittelt.

## Themenübersicht (Kursinhalte)
- Installation und Erstkonfiguration von RHEL (Partitionierung, Bootloader, Repositories)
- Paketmanagement mit `dnf`/`rpm` und Repositorien
- Systemd: Units, Service Management, Logs
- Dateisysteme & Storage: Partitionen, `xfs`, `ext4`, LVM, Mounts, `fstab`
- Netzwerkkonfiguration: IP, Bonding, Routing, DNS, `nmcli`, `ip`-Tools
- Firewall & Zugang: `firewalld`, SSH‑Härtung
- Benutzer- und Rechteverwaltung: Users/Groups, `sudo`, ACLs
- SELinux: Modes, Booleans, Troubleshooting mit `semanage/audit2why`
- Prozesse, Ressourcen und Scheduling: `cron`, `systemd` timers, Prozesskontrolle
- Basis Shell‑Scripting für Automatisierung und Prüfungsaufgaben
- Backup/Restore, Logs und Systemdiagnose (Boot‑Recovery, Rescue Mode)
- Troubleshooting von Alltagsproblemen und Prüfungsaufgaben


## Detailliertes 6‑Nachmittage‑Programm
Alle Sitzungen finden 13:00–17:00 Uhr statt. Jede Einheit kombiniert kurze Theorieabschnitte mit umfangreichen Hands‑On‑Aufgaben.

Nachmittag 1 — Einführung, Installation & Grundkonfiguration
- Kursziele, Prüfungsformat EX200 (Lab) und Prüfungsstrategie
- Installation/NetInstall, Partitionierung, Basis‑Bootloader (GRUB)
- Erste Systemkonfiguration: Hostname, Zeit, Repositories, `dnf` updates
- Hands‑On: Installation einer VM/Instanz, Basis‑Konfiguration

Nachmittag 2 — Paketverwaltung & Basissystemverwaltung
- Paketmanagement mit `dnf`/`rpm`, Repositorien konfigurieren
- Systemupdates, Rollbacks und Paket‑Troubleshooting
- Hands‑On: Repository einrichten und Pakete verwalten

Nachmittag 3 — Dienste, systemd & Prozesse
- `systemd` Units erstellen/anpassen, Unit‑Overrides, `journalctl`
- Service Management, Prozessüberwachung, `systemd` timers vs. `cron`
- Hands‑On: Eigene Unit erstellen, Logs analysieren

Nachmittag 4 — Storage, Dateisysteme & LVM
- Partitionierung, `mkfs`, UUIDs/Labels, `mount` und `fstab`
- LVM: PV/VG/LV anlegen, Resizing, Snapshots (konzeptionell)
- Hands‑On: LVM Setup, Resize und Mount‑Management

Nachmittag 5 — Netzwerk, Firewall & Remote‑Zugriff
- Netzwerkinitialisierung mit `nmcli`/`nm-connection-editor`, `ip`/`ss`
- `firewalld` Zonen, Rich Rules, Ports/Services öffnen
- SSH‑Konfiguration und Härtung, SCP/SFTP, Netzwerk‑Troubleshooting
- Hands‑On: Netzwerkanbindung und Firewall‑Szenario

Nachmittag 6 — Sicherheit (SELinux), Scripting, Backup & Prüfungsübungen
- SELinux Modi, Kontextverwaltung, Troubleshooting mit `audit2why`/`setsebool`
- Bash‑Scripting Basics für Prüfungsaufgaben (Variablen, Loops, Exit‑Status)
- Backup/Restore, Logs, Boot‑Recovery und Troubleshooting‑Strategien
- Prüfungsnahe Abschlussübungen (Labs), Prüfungsstrategie & Q&A

## Vorbereitung für Teilnehmende
- Vor dem ersten Nachmittag: VM‑Images oder ein RHEL/CentOS‑Stream/Rocky/AlmaLinux Image herunterladen. Red Hat bietet Test‑Subscriptions / Developer Subscriptions an.  
- Empfohlene Tools: VirtualBox, VMware, oder KVM/Libvirt (für performance‑nahe Tests).  
- Terminal/SSH‑Client und ein Editor (vim/nano/code)  
- Hardware: Mindestens 8–16 GB RAM, ≥50 GB freier Speicher; 16 GB+ wird für komfortables Arbeiten empfohlen.

## Voraussetzungen
- Grundkenntnisse in Linux und der Kommandozeile  
- Verständnis von Netzwerkgrundlagen  
- Grundlegende Erfahrung mit Virtualisierung/VMs ist von Vorteil

## Zielgruppe
Diese Prüfungsvorbereitung richtet sich an Systemadministratoren, IT‑Fachpersonen und alle, die die praktische RHCSA Zertifizierung (EX200) anstreben oder ihre RHEL‑Administration Kenntnisse vertiefen möchten.

## Kontaktinformationen
Wenn Sie Fragen haben, können Sie mich wie folgt erreichen:

- Email: training@videotrainer.ch
- X: @tomvideo2brain
- LinkedIn: https://www.linkedin.com/in/tom-wechsler

## Ressourcen
- Red Hat — Offizielle Seite: https://www.redhat.com/
- RHCSA Exam Overview (Red Hat): https://www.redhat.com/en/services/certification/rhcsa
- RHEL Dokumentation: https://access.redhat.com/documentation/
- firewalld: https://firewalld.org/
- SELinux Project: https://selinuxproject.org/
- Rocky Linux: https://rockylinux.org/
- AlmaLinux: https://almalinux.org/
- VirtualBox: https://www.virtualbox.org/
- YouTube Playlist - Linux Tipps: https://youtube.com/playlist?list=PLi0MTIjZai_x7Zh40R-78fqFrvjn6MCGS&si=yt2SgjPe1jb47hdj
- LinkedIn Learning Red Hat Enterprise Administration Teil 1 (https://de.linkedin.com/learning/red-hat-enterprise-administration-teil-1-grundlagen-und-systemkonfiguration-rhcsa)
- LinkedIn Learning Red Hat Enterprise Administration Teil 2 (https://de.linkedin.com/learning/red-hat-enterprise-administration-teil-2-management-von-netzwerken-gruppen-sicherheit-und-containern-rhcsa)
---

