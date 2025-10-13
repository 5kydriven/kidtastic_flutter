[Setup]
AppName=Kidtastic Game
AppVersion=1.0.0
DefaultDirName={autopf}\Kidtastic
DefaultGroupName=Kidtastic
OutputBaseFilename=KidtasticSetup
Compression=lzma
SolidCompression=yes
SetupIconFile=windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\kidtastic_flutter.exe

PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog
DisableProgramGroupPage=yes
WizardStyle=modern

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\Kidtastic"; Filename: "{app}\kidtastic_flutter.exe"
Name: "{commondesktop}\Kidtastic"; Filename: "{app}\kidtastic_flutter.exe"

[Run]
Filename: "{app}\kidtastic_flutter.exe"; Description: "Launch Kidtastic"; \
Flags: shellexec postinstall runascurrentuser skipifsilent nowait
