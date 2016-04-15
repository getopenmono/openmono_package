#Requires -Version 2
Add-Type -AssemblyName System.IO

$VERSION="1.0"
$APPNAME="monomake"
$ScriptPath = $MyInvocation.MyCommand.Definition
$CWD = Get-Location
$ScriptDir = Split-Path (Split-Path $ScriptPath)

.$ScriptDir/Configuration.ps1

$PROJECT_FILES = "$TEMPLATE_DIR/app_controller.h", "$TEMPLATE_DIR/app_controller.cpp"

function showhelp
{
    Write-Host "OpenMono project PowerShell utility, creating new projects and access to monoprog"
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "$APPNAME COMMAND [options]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  project [name]  Create a new project folder. Default name is: new_mono_project"
    #Write-Host "  bootldr         See if a mono is connected and in bootloader"
    Write-Host "  monoprog [...]  Shortcut to access the MonoProg USB programmer"
    Write-Host "  -p ELF_FILE     Upload an application to mono"
    Write-Host "  reboot          Send Reboot command to Mono, using the Arduino DTR method"
    Write-Host "  version         Display the current version of $APPNAME"
    Write-Host "  path            Display the path to the Mono Environment installation dir"
    Write-Host ""
}

function showArgError {
    Write-Error "ERR: No command argument given! You must provide a command"
    showhelp
}

function writeMakefile($projectName, $fileName) {
    $DATE=Get-Date
    $Content = "`n# Makefile created by $APPNAME, $DATE`n"
    $Content = "${Content}# Project: $projectName`n"
    $Content = "${Content}MONO_PATH=`$(subst \,/,$ScriptDir)`n"
    $Content = "${Content}include `$(MONO_PATH)/predefines.mk`n`n"
    $Content = "${Content}TARGET=$projectName`n"
    $Content = "${Content}`n"
	$Content = "${Content}include `$(MONO_PATH)/mono.mk`n"
    Write-Host "$CWD\$fileName"
    [System.IO.File]::WriteAllLines("$CWD\$fileName", $Content)
}

function printVersion {
    echo "$APPNAME version $VERSION"
}

function runMonoprog($p1, $p2, $p3, $p4)
{
    .$MONOPROG_DIR $p1 $p2 $p3 $p4
}

function programElf($elfFile)
{
    .$MONOPROG_DIR -p $elfFile
}

function rebootMonoDtr
{
    .$ScriptDir\reset.exe
}

function createProjectFolder($projectName)
{
    if ([string]::IsNullOrEmpty($projectName))
    {
        Write-Error "No project name given"
        return
    }
    ElseIf (Test-Path $projectName)
    {
        Write-Error "Project target directory already exists"
        return
    }

    Write-Host "Creating new mono project: $projectName..."

    md $projectName | Out-Null

    foreach ($file in $PROJECT_FILES) {
        echo $ScriptDir/$file
        Copy-Item $ScriptDir/$file -Destination "$projectName/."
    }
    
    writeMakefile $projectName "$projectName/Makefile"
}

function printMonoPath {
    echo "Mono Environment Path: $ScriptDir"
}

function projectCommand($projectName = "new_mono_project") {
    

    If ([String]::IsNullOrEmpty($projectName))
    {
        createProjectFolder("new_mono_project")
    }
    Else
    {
        createProjectFolder($projectName)
    }
    
}

if ($args.Count -eq 0) {
    showhelp
}

$command = $args[0]

if ($command -eq "project") {
    projectCommand($args[1])
}
ElseIf ($command -eq "monoprog") {
    runMonoprog($args[1], $args[2], $args[3], $args[4])
}
ElseIf ($command -eq "help") {
    showhelp
}
ElseIf ($command -eq "version") {
    printVersion
}
ElseIf ($command -eq "path") {
    printMonoPath
}
ElseIf ($command -eq "-p") {
    programElf $args[1]
}
ElseIf ($command -eq "reboot") {
    rebootMonoDtr
}
ElseIf ($command -eq "writemake") {
    writeMakefile $args[1] "Makefile"
}
Else {
    Write-Host "Unkown command: $command"
}