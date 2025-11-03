[Setup]
AppName=Kidtastic Game
AppVersion=1.0.0
DefaultDirName={autopf}\Kidtastic
DefaultGroupName=Kidtastic
OutputBaseFilename=KidtasticSetup
Compression=lzma
SolidCompression=yes

; Your app icon
SetupIconFile=windows\runner\resources\logo.ico
UninstallDisplayIcon={app}\kidtastic_flutter.exe

PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog
DisableProgramGroupPage=yes
WizardStyle=modern

; --- Create user data folder (AppData) for database ---
[Dirs]
Name: "{localappdata}\Kidtastic"; Flags: uninsalwaysuninstall

; --- Copy app binaries ---
[Files]
Source: "windows\runner\resources\logo.ico"; DestDir: "{app}\windows\runner\resources"
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion


; --- Shortcuts ---
[Icons]
Name: "{group}\Kidtastic"; Filename: "{app}\kidtastic_flutter.exe"; IconFilename: "{app}\windows\runner\resources\logo.ico"
Name: "{commondesktop}\Kidtastic"; Filename: "{app}\kidtastic_flutter.exe"; IconFilename: "{app}\windows\runner\resources\logo.ico"

; --- Run app after install ---
[Run]
Filename: "{app}\kidtastic_flutter.exe"; Description: "Launch Kidtastic"; \
    Flags: shellexec postinstall runascurrentuser skipifsilent nowait

; --- Uninstaller cleanup (optional) ---
[UninstallDelete]
; Remove user data folder during uninstall (optional; comment out to preserve data)
; Type: filesandordirs; Name: "{localappdata}\Kidtastic"
