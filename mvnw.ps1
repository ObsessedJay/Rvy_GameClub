# Maven Wrapper PowerShell script
$env:JAVA_HOME = 'D:\JDK'
$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
& "$projectDir\mvnw.cmd" $args
