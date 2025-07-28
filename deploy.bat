@echo off
chcp 65001 >nul
title Hexo 稳定部署脚本 - 无 clean 命令版

echo === [1] 强制删除 db.json（防止锁定）===
if exist db.json (
    del /f /q db.json >nul 2>nul
    echo 已强制删除 db.json
) else (
    echo db.json 不存在，无需删除
)

echo.
echo === [2] 强制删除 public 文件夹（替代 hexo clean）===
if exist public (
    rmdir /s /q public
    echo 已强制删除 public 文件夹
) else (
    echo public 不存在，无需清理
)

echo.
echo === [3] 执行 hexo generate ===
call hexo generate

echo.
echo === [4] 执行 hexo deploy ===
call hexo deploy

echo.
echo ✅ 所有流程已执行完成，按任意键退出...
pause >nul
