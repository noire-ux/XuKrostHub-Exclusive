XUKROST HUB - ROBLOX SCRIPT HUB
By noirexe (Enhanced + Tabs + Search + Manual Tab Position + Mini Control Bar + Bubble Minimize + Dividers + Console + Teleport Manager)

================================================================================
OVERVIEW
================================================================================
XuKrost Hub adalah script hub lengkap untuk Roblox yang menyediakan berbagai
fitur dan script eksklusif. Interface dibuat dengan UI yang modern dan user-friendly.

FITUR UTAMA:
✅ Enhanced GUI dengan design modern
✅ System tabs dengan posisi manual
✅ Search functionality untuk filtering script
✅ Mini control bar (minimize/close)
✅ Bubble minimize button
✅ Dividers untuk pemisah visual
✅ Console output real-time
✅ Teleport Manager dengan save/load system
✅ Movement controls (WalkSpeed, JumpPower, Infinity Jump)
✅ Network Pause remover

================================================================================
STRUKTUR KODE
================================================================================

1. KONFIGURASI AWAL
   - Nama hub dan creator text
   - Data scripts terorganisir dalam tabel:
     * Main Scripts: Script utama untuk berbagai map
     * Extra Tools: Movement controls, Fly, Remove Network Pause
     * Own Script: Teleport Manager
     * Console: Output console real-time
     * Credits: Info creator dan contributor

2. SERVICES & VARIABLES
   - Roblox services (Players, TweenService, StarterGui, dll)
   - Movement controls variables
   - Teleport Manager variables dengan system save/load
   - Original frame size constant untuk konsistensi UI

3. UTILITY FUNCTIONS
   - notify(): System notifikasi
   - httpGet() & fetchAndRun(): HTTP requests dan execution
   - copyToClipboard(): Clipboard operations
   - Teleport functions: save/load data, position management

4. MOVEMENT CONTROLS SYSTEM
   - WalkSpeed dan JumpPower adjustment
   - Infinity jump toggle
   - Presets (Default & Ngibrits)
   - Real-time character updates

5. TELEPORT MANAGER
   - Save current position dengan nama custom
   - Load/save data ke file
   - Teleport ke saved locations
   - Delete management
   - Auto-refresh list

6. UI BUILD SYSTEM
   - Main frame dengan dragging capability
   - Header dengan title dan creator info
   - Mini control bar (minimize/close)
   - Tab system dengan posisi manual
   - Search box untuk filtering
   - Content frames untuk setiap tab

7. TAB SPECIFIC IMPLEMENTATIONS
   - Main Scripts: Scrolling frame dengan search filter
   - Extra Tools: Dropdown movement controls + tools
   - Own Script: Teleport Manager UI lengkap
   - Console: Scrolling text output dengan auto-scroll
   - Credits: Info creator dengan copy functionality

8. BUBBLE MINIMIZE SYSTEM
   - Minimize ke bubble button
   - Restore dari bubble ke full UI
   - Smooth animations dengan TweenService

================================================================================
FUNGSIONALITAS SPESIFIK
================================================================================

A. MOVEMENT CONTROLS:
   - Adjust WalkSpeed (16 default)
   - Adjust JumpPower (50 default) 
   - Infinity Jump toggle
   - Preset configurations
   - Real-time application ke character

B. TELEPORT MANAGER:
   - Save position dengan nama custom
   - Data persistence dengan file saving
   - Teleport ke saved locations
   - Delete individual locations
   - Clear all data
   - Auto-load pada startup

C. SEARCH SYSTEM:
   - Real-time filtering di Main Scripts
   - Case-insensitive search
   - Dynamic UI updating

D. CONSOLE SYSTEM:
   - Real-time output logging
   - Auto-scroll ke bottom
   - Scrolling frame untuk content panjang

E. NETWORK PAUSE REMOVER:
   - Remove network pause dialog
   - CoreGui modification

================================================================================
KEAMANAN & ERROR HANDLING
================================================================================

- Extensive use of pcall() untuk error handling
- Safe HTTP requests dengan status checking
- Validation untuk user input
- Proper cleanup dan memory management

================================================================================
PENGGUNAAN
================================================================================

1. Script akan auto-load saat di-execute
2. GUI muncul di top-left screen
3. Gunakan tabs untuk navigasi fitur:
   - Main Scripts: Pilih map dan execute script
   - Extra Tools: Movement controls dan utilities  
   - Own Script: Teleport Manager
   - Console: Lihat execution logs
   - Credits: Info developer

4. Gunakan bubble button (XHUB) untuk minimize/restore
5. Drag main frame atau bubble untuk reposition

================================================================================
CATATAN TEKNIS
================================================================================

- Menggunakan Roblox CoreGui untuk notifications
- File saving untuk teleport data persistence
- Smooth animations dengan TweenService
- Responsive design dengan dynamic sizing
- Comprehensive error handling throughout

================================================================================
KREDIT
================================================================================

Creator: noirexe
YouTube: XuKrost OFC
TikTok: noiree  
Instagram: @snn2ndd_

Contributor: Natsyn
Instagram: https://www.instagram.com/env.example?igsh=bThpNWM3dXJjc2hr

Discord: https://discord.gg/RpYcMdzzwd
