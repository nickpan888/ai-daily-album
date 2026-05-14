@echo off
chcp 65001 >nul
setlocal

set SOURCE_DIR=%USERPROFILE%\Desktop
set REPO_DIR=%USERPROFILE%\ai-daily-album

:: 找最新的 AI画册_*.html
for /f "delims=" %%i in ('dir "%SOURCE_DIR%\AI画册_*.html" /b /o-d 2^>nul') do (
    set LATEST=%%i
    goto :found
)
echo 未找到 AI画册_*.html 文件
exit /b 1

:found
echo 找到: %LATEST%
copy /y "%SOURCE_DIR%\%LATEST%" "%REPO_DIR%\index.html"

cd /d "%REPO_DIR%"
git add index.html
git commit -m "Update daily album"
git push
echo 部署完成!
