@echo off
Title Gerador de Update - RF Online
color 0A

echo ==================================================
echo       GERADOR DE PATCH AUTOMATICO - NEW WAR
echo ==================================================
echo.

:: 1. Pede a nova versao para o administrador
set /p "newver=Digite a nova versao do cliente (ex: 1.2): "
echo %newver% > version.txt
echo [OK] version.txt atualizado para a versao %newver%

echo.
echo Lendo arquivos e calculando seguranca MD5...
echo Isso pode demorar alguns segundos dependendo da quantidade.
echo.

:: 2. Cria um script PowerShell invisivel para fazer o trabalho pesado
echo $ErrorActionPreference = 'SilentlyContinue' > temp_gen.ps1
echo $baseUrl = 'https://raw.githubusercontent.com/RFNewW/update-server-newwar/main/version' >> temp_gen.ps1
echo $folderPath = 'version' >> temp_gen.ps1
echo $files = Get-ChildItem -Path $folderPath -Recurse -File >> temp_gen.ps1
echo $lines = @() >> temp_gen.ps1
echo foreach ($f in $files) { >> temp_gen.ps1
echo     $relativePath = $f.FullName.Substring((Get-Item $folderPath).FullName.Length + 1).Replace('\', '/') >> temp_gen.ps1
echo     $hash = (Get-FileHash $f.FullName -Algorithm MD5).Hash >> temp_gen.ps1
echo     $downloadUrl = "$baseUrl/$relativePath" >> temp_gen.ps1
echo     $lines += "$relativePath|$downloadUrl|$hash" >> temp_gen.ps1
echo } >> temp_gen.ps1
echo [IO.File]::WriteAllLines('patchlist.txt', $lines) >> temp_gen.ps1

:: 3. Executa o script usando o caminho EXATO do Windows e depois apaga
%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '.\temp_gen.ps1'"
del temp_gen.ps1

echo ==================================================
echo [SUCESSO] patchlist.txt gerado com perfeicao!
echo ==================================================
echo.
echo O que fazer agora?
echo 1. Abra o GitHub Desktop.
echo 2. Coloque um nome no "Summary" (ex: Update de Itens).
echo 3. Clique em "Commit to main".
echo 4. Clique em "Push origin" la em cima.
echo.
pause