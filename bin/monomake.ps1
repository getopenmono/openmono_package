#Requires -Version 2

$VERSION="1.0"
$APPNAME="monomake"
$ScriptPath = $MyInvocation.MyCommand.Definition
$ScriptDir = Split-Path (Split-Path $ScriptPath)

.$ScriptDir/Configuration.ps1

$PROJECT_FILES = "$TEMPLATE_DIR/app_controller.h", "$TEMPLATE_DIR/app_controller.cpp"

function showhelp
{
    Write-Host "OpenMono project utility, creating new projects and access to monoprog"
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "$APPNAME COMMAND [options]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  project [name]  Create a new project folder. Default name is: new_mono_project"
    Write-Host "  bootldr         See if a mono is connected and in bootloader"
    Write-Host "  monoprog [...]  Shortcut to access the MonoProg USB programmer"
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
    echo "# Makefile created by $APPNAME, $DATE" | Out-File $fileName
    echo "# Project: $projectName" | Out-File $fileName -Append
    echo "MONO_PATH=`"$ScriptDir`"" | Out-File $fileName -Append
    echo "TARGET=$projectName" | Out-File $fileName -Append
    echo "" | Out-File $fileName -Append
	echo 'include $(MONO_PATH)/mono.mk' | Out-File $fileName -Append
}

function printVersion {
    echo "$APPNAME version $VERSION"
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

    for ($i=0; $i -lt $PROJECT_FILES.Count; $i++) {
        Copy-Item $PROJECT_FILES[$i] -Destination "$projectName/."
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
ElseIf ($command -eq "help") {
    showhelp
}
ElseIf ($command -eq "version") {
    printVersion
}
ElseIf ($command -eq "path") {
    printMonoPath
}
Else {
    Write-Host "Unkown command: $command"
}