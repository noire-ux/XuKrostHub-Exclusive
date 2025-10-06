🌀 XUKROST HUB – ROBLOX SCRIPT HUB

By noirexe
(Enhanced + Tabs + Search + Manual Tab Position + Mini Control Bar + Bubble Minimize + Dividers + Console + Teleport Manager)


---

🔰 OVERVIEW

XuKrost Hub adalah Roblox Script Hub lengkap dan modern yang dirancang untuk memberikan pengalaman scripting yang cepat, fleksibel, dan interaktif.
Dilengkapi dengan sistem tab dinamis, kontrol movement, console log real-time, hingga Teleport Manager dengan penyimpanan otomatis.

UI dibangun dengan tampilan clean, draggable, dan responsive, disertai animasi halus dari TweenService.


---

⚙️ FITUR UTAMA

✅ Enhanced GUI dengan desain modern & drag support
✅ System Tabs dengan posisi manual
✅ Search Box untuk filter script secara real-time
✅ Mini Control Bar (minimize & close)
✅ Bubble Button untuk minimize cepat
✅ Visual Dividers antar elemen
✅ Console Output real-time
✅ Teleport Manager dengan sistem save/load otomatis
✅ Movement Controls (WalkSpeed, JumpPower, Infinity Jump)
✅ Network Pause Remover (auto-disable Roblox pause)


---

🧩 STRUKTUR KODE

1. Konfigurasi Awal

Inisialisasi:

HubName, CreatorText

Tabel scripts berisi:

Main Scripts – Script map utama

Extra Tools – Tools tambahan & movement

Own Script – Teleport Manager

Console – Real-time log viewer

Credits – Info creator




2. Services & Variables

Roblox Services: Players, TweenService, StarterGui, dll

Variabel movement & teleport

Original frame constants untuk UI konsisten


3. Utility Functions

notify() → sistem notifikasi

httpGet() & fetchAndRun() → ambil & jalankan script

copyToClipboard() → menyalin teks

TeleportManager → save/load data posisi


4. Movement Controls

Atur WalkSpeed & JumpPower

Infinity Jump toggle

Presets: Default & Ngibrits

Update real-time ke karakter


5. Teleport Manager

Save posisi dengan nama custom

Auto-load & auto-save data lokal

Teleport ke lokasi tersimpan

Delete individual / clear all

Auto-refresh list UI


6. UI Build System

Main frame draggable

Header: title + creator text

Mini control bar (minimize / close)

Tab system manual position

Search bar filter scripts

Content frame untuk tiap tab


7. Tab Implementations

Main Scripts: Scroll + search

Extra Tools: Dropdown + toggles

Own Script: Teleport Manager

Console: Auto-scroll log output

Credits: Info creator & copy buttons


8. Bubble Minimize System

Tombol XHUB bubble

Klik → restore UI

Animasi halus (TweenService)



---

⚡ FUNGSIONALITAS SPESIFIK

A. Movement Controls

Ubah WalkSpeed (default: 16)

Ubah JumpPower (default: 50)

Aktifkan Infinity Jump

Preset cepat (Default / Ngibrits)


B. Teleport Manager

Save posisi custom

Persistent save (auto-load file)

Teleport langsung ke lokasi tersimpan

Delete individual / Clear All


C. Search System

Filter real-time di Main Scripts

Case-insensitive

Dynamic UI update


D. Console System

Output logging real-time

Auto-scroll ke bawah

Scrolling frame


E. Network Pause Remover

Hapus dialog Roblox “Network Pause”

Gunakan CoreGui bypass dengan aman



---

🧠 KEAMANAN & ERROR HANDLING

Penggunaan pcall() di semua fungsi penting

Validasi input user

Safe HTTP request (status checking)

Memory management & cleanup UI

Logging error di console



---

🚀 PENGGUNAAN

1. Jalankan script, GUI akan muncul otomatis di top-left.


2. Navigasi lewat tab:

Main Scripts: Pilih & execute map

Extra Tools: Pengaturan movement

Own Script: Teleport Manager

Console: Lihat logs

Credits: Info creator



3. Gunakan bubble button (XHUB) untuk minimize/restore.


4. Drag main frame atau bubble untuk memindahkan posisi.




---

🧩 CATATAN TEKNIS

Gunakan CoreGui untuk notifications

File saving system dengan writefile() & readfile()

Animasi halus TweenService

Dynamic resizing untuk resolusi berbeda

GUI modular dengan pembagian komponen



---

🧑‍💻 KREDIT

Creator: noirexe

YouTube: XuKrost OFC

TikTok: @noiree

Instagram: @snn2ndd_


Contributor: Natsyn

Instagram: @env.example


Discord: Join XuKrost Community


---

🧾 VERSI

Build: 2.0 (Enhanced Edition)

Last Updated: Oktober 2025

Status: Stable
