#define MyAppName "سامانه منابع انسانی قائم‌شهر"
#define MyAppNameEn "Qaemshahr"
#define MyAppVersion "2.3.12"
#ifndef LightBuild
#define LightBuild "0"
#endif
#define MyAppPublisher "شرکت گاز قائم‌شهر"
#define MyAppExeName "Qaemshahr.exe"
#define MyAppId "{{8F3C2A91-6B47-4E1D-9A70-1B2C3D4E5F60}}"

[Setup]
AppId={#MyAppId}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf32}\GAZ\Qaemshahr
DefaultGroupName={#MyAppNameEn}
DisableProgramGroupPage=yes
OutputDir=..\dist
OutputBaseFilename=QaemshahrSetup_{#MyAppVersion}
Compression=lzma2
SolidCompression=yes
WizardStyle=classic
PrivilegesRequired=admin
ArchitecturesAllowed=x86compatible
ArchitecturesInstallIn64BitMode=
MinVersion=6.1sp1
UsePreviousAppDir=yes
UsePreviousGroup=yes
CloseApplications=yes
RestartApplications=no
AppMutex=Global\ir.gaz.qaemshahr.hrms
SetupMutex=Global\ir.gaz.qaemshahr.hrms.setup
UninstallDisplayName={#MyAppName}
VersionInfoVersion={#MyAppVersion}
VersionInfoProductName={#MyAppName}
DisableWelcomePage=no
AllowNoIcons=yes
SetupIconFile=..\src\Qaemshahr.App\Assets\app.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
; Data lives in {commonappdata}\GAZ\Qaemshahr — never listed here, never deleted.

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
WindowsVersionNotSupported=این برنامه روی ویندوز ۷ Service Pack 1 و جدیدتر نصب می‌شود.%nاگر ویندوز ۷ بدون SP1 دارید، ابتدا SP1 را نصب کنید.
OnlyOnTheseArchitectures=این نصب‌کننده برای برنامه ۳۲بیتی است و روی این معماری سیستم اجرا نمی‌شود.

[Tasks]
Name: "desktopicon"; Description: "میانبر میز کار"; GroupDescription: "میانبرها:"

[Files]
Source: "..\dist\app\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
#if LightBuild == "0"
; داخل ستاپ هم کپی می‌شوند تا اگر پوشه redist جدا نبود، از {tmp} استفاده شود
Source: "redist\ndp48-x86-x64-AllOS-ENU.exe"; DestDir: "{tmp}\redist"; Flags: deleteafterinstall skipifsourcedoesntexist
Source: "redist\vc_redist.x86.exe"; DestDir: "{tmp}\redist"; Flags: deleteafterinstall skipifsourcedoesntexist
Source: "redist\windows6.1-kb4490628-x86.msu"; DestDir: "{tmp}\redist"; Flags: deleteafterinstall skipifsourcedoesntexist
Source: "redist\windows6.1-kb4490628-x64.msu"; DestDir: "{tmp}\redist"; Flags: deleteafterinstall skipifsourcedoesntexist
Source: "redist\windows6.1-kb4474419-v3-x86.msu"; DestDir: "{tmp}\redist"; Flags: deleteafterinstall skipifsourcedoesntexist
Source: "redist\windows6.1-kb4474419-v3-x64.msu"; DestDir: "{tmp}\redist"; Flags: deleteafterinstall skipifsourcedoesntexist
#endif

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "اجرای برنامه"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Intentionally empty: ProgramData is preserved.

[Code]
var
  NeedRebootAfterPrereq: Boolean;

function IsWindows7(): Boolean;
begin
  { 6.1 = Windows 7 / Server 2008 R2 }
  Result := (GetWindowsVersion shr 16) = $0601;
end;

function IsDotNet48(): Boolean;
var
  Release: Cardinal;
begin
  Result := False;
  if RegQueryDWordValue(HKLM, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full', 'Release', Release) then
    Result := Release >= 528040;
  if (not Result) and IsWin64 then
  begin
    if RegQueryDWordValue(HKLM32, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full', 'Release', Release) then
      Result := Release >= 528040;
  end;
end;

function IsVcRedistOk(): Boolean;
var
  Major: Cardinal;
begin
  Result := False;
  { VC++ 2015-2022 x86 runtime }
  if RegQueryDWordValue(HKLM32, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x86', 'Major', Major) then
    Result := Major >= 14;
  if not Result then
  begin
    if RegQueryDWordValue(HKLM, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x86', 'Major', Major) then
      Result := Major >= 14;
  end;
end;

function FindRedist(const FileName: String): String;
var
  P: String;
begin
  Result := '';
  P := ExpandConstant('{src}\redist\') + FileName;
  if FileExists(P) then
  begin
    Result := P;
    Exit;
  end;
  P := ExpandConstant('{tmp}\redist\') + FileName;
  if FileExists(P) then
  begin
    Result := P;
    Exit;
  end;
  P := ExpandConstant('{tmp}\') + FileName;
  if FileExists(P) then
    Result := P;
end;

function RunQuiet(const Exe, Params: String; var ResultCode: Integer): Boolean;
begin
  Result := Exec(Exe, Params, '', SW_SHOW, ewWaitUntilTerminated, ResultCode);
end;

function InstallMsu(const FileName, Title: String): Boolean;
var
  Path: String;
  ResultCode: Integer;
  Cmd: String;
begin
  Result := True;
  Path := FindRedist(FileName);
  if Path = '' then
  begin
    Log('Missing MSU: ' + FileName);
    Exit;
  end;
  WizardForm.StatusLabel.Caption := Title;
  WizardForm.Refresh;
  Cmd := '"' + Path + '" /quiet /norestart';
  if not RunQuiet('wusa.exe', Cmd, ResultCode) then
  begin
    MsgBox('اجرای به‌روزرسانی ناموفق بود:' #13#10 + FileName, mbError, MB_OK);
    Result := False;
    Exit;
  end;
  { 3010 = reboot required, 2359302 = already installed }
  if (ResultCode = 3010) or (ResultCode = 1641) then
    NeedRebootAfterPrereq := True;
  if (ResultCode <> 0) and (ResultCode <> 3010) and (ResultCode <> 1641) and (ResultCode <> 2359302) then
    Log(Format('MSU %s exit code %d (may already be installed)', [FileName, ResultCode]));
end;

function InstallExe(const FileName, Args, Title: String; Required: Boolean): Boolean;
var
  Path: String;
  ResultCode: Integer;
begin
  Result := True;
  Path := FindRedist(FileName);
  if Path = '' then
  begin
    if Required then
    begin
      MsgBox('فایل پیش‌نیاز پیدا نشد:' #13#10 + FileName + #13#10#13#10
        + 'پوشه redist را کنار فایل نصب قرار دهید.', mbError, MB_OK);
      Result := False;
    end;
    Exit;
  end;
  WizardForm.StatusLabel.Caption := Title;
  WizardForm.Refresh;
  if not RunQuiet(Path, Args, ResultCode) then
  begin
    if Required then
    begin
      MsgBox('نصب پیش‌نیاز ناموفق بود:' #13#10 + FileName, mbError, MB_OK);
      Result := False;
    end;
    Exit;
  end;
  if (ResultCode = 3010) or (ResultCode = 1641) then
    NeedRebootAfterPrereq := True;
  if Required and (ResultCode <> 0) and (ResultCode <> 3010) and (ResultCode <> 1641) then
  begin
    { 1638 = already installed newer }
    if ResultCode = 1638 then
      Exit;
    MsgBox(Format('نصب %s با کد خطا %d پایان یافت.', [FileName, ResultCode]), mbError, MB_OK);
    Result := False;
  end;
end;

function InstallWin7Prereqs(): Boolean;
begin
  Result := True;
  if IsWin64 then
  begin
    if not InstallMsu('windows6.1-kb4490628-x64.msu', 'نصب Servicing Stack (KB4490628)...') then
    begin
      Result := False;
      Exit;
    end;
    if not InstallMsu('windows6.1-kb4474419-v3-x64.msu', 'نصب پشتیبانی SHA-2 (KB4474419)...') then
    begin
      Result := False;
      Exit;
    end;
  end
  else
  begin
    if not InstallMsu('windows6.1-kb4490628-x86.msu', 'نصب Servicing Stack (KB4490628)...') then
    begin
      Result := False;
      Exit;
    end;
    if not InstallMsu('windows6.1-kb4474419-v3-x86.msu', 'نصب پشتیبانی SHA-2 (KB4474419)...') then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

function InitializeSetup(): Boolean;
begin
  Result := True;
  NeedRebootAfterPrereq := False;
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  Ok: Boolean;
begin
  Result := '';
  NeedsRestart := False;
  WizardForm.StatusLabel.Caption := 'بررسی و نصب پیش‌نیازها...';
  WizardForm.Refresh;

  if IsWindows7() then
  begin
    if not InstallWin7Prereqs() then
    begin
      Result := 'نصب به‌روزرسانی‌های ویندوز ۷ ناموفق بود. پوشه redist کنار فایل نصب را بررسی کنید.';
      Exit;
    end;
  end;

  if not IsVcRedistOk() then
  begin
    if not InstallExe('vc_redist.x86.exe', '/install /quiet /norestart',
      'نصب Visual C++ Redistributable...', False) then
    begin
      { non-fatal if missing on newer Windows that already has runtimes }
      Log('VC redist skipped or failed');
    end;
  end;

  if not IsDotNet48() then
  begin
    Ok := InstallExe('ndp48-x86-x64-AllOS-ENU.exe', '/q /norestart',
      'نصب .NET Framework 4.8...', True);
    if not Ok then
    begin
      Result := '.NET Framework 4.8 نصب نشد. فایل ndp48 را در پوشه redist کنار نصب‌کننده بگذارید و دوباره تلاش کنید.';
      Exit;
    end;
    if not IsDotNet48() then
    begin
      { sometimes needs reboot before registry updates }
      NeedRebootAfterPrereq := True;
    end;
  end;

  if NeedRebootAfterPrereq then
    NeedsRestart := True;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  DataDir: String;
begin
  if CurUninstallStep = usPostUninstall then
  begin
    DataDir := ExpandConstant('{commonappdata}\GAZ\Qaemshahr');
    if DirExists(DataDir) then
    begin
      if MsgBox('برنامه حذف شد. آیا پرونده‌ها و پایگاه داده هم پاک شوند؟' #13#10
        + DataDir + #13#10#13#10
        + 'اگر نسخهٔ جدید نصب می‌کنید، «خیر» را بزنید.', mbConfirmation, MB_YESNO) = IDYES then
      begin
        DelTree(DataDir, True, True, True);
      end;
    end;
  end;
end;
