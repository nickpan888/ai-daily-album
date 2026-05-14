@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

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

:: 提取日期 (如 AI画册_20260515.html → 20260515)
set VERSION=%LATEST:AI画册_=%
set VERSION=%VERSION:.html=%

echo 版本: %VERSION%

:: 复制为 index.html（最新版）
copy /y "%SOURCE_DIR%\%LATEST%" "%REPO_DIR%\index.html"

:: 同时保存历史版本
copy /y "%SOURCE_DIR%\%LATEST%" "%REPO_DIR%\%VERSION%.html"

cd /d "%REPO_DIR%"

:: 更新 archive.html：检查是否有新版本号
if not exist "%VERSION%.html" (
    echo 警告: 版本文件未创建
)

git add index.html %VERSION%.html archive.html
git commit -m "Update daily album - %VERSION%"
git push
echo 部署完成! 版本 %VERSION% 已保存
echo 在线访问: https://nickpan888.github.io/ai-daily-album/
