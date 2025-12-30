---
title: Electron实战——从HTML到桌面应用(1)
date: 2025-12-28 21:02:17
tags:
- 前端
- 示例
categories: 杂项
description: 本文章通过了一个小示例，介绍了如何使用 Electron 从 HTML 到桌面应用的基本过程。
---
## 事前准备
我们准备好HTML、CSS、JavaScript文件，并保证其可以在浏览器环境中正常运行。   
如果您还没有现成的HTML文件，可以访问我的[GitHub仓库](https://github.com/thirdh6o/hyq_works)获取示例代码。  
本例子中我准备了一个简单的界面
{% asset_img 1.png %}
结构也很简单：
{% asset_img 2.png %}
Electron 不会动这些文件，它只是：
-创建一个“桌面窗口”
-把其中一个html文件当作入口页面加载  
>这和我们直接在浏览器打开html文件是一样的。  
## 最小可运行的 Electron 结构
```text
project/
├─ electron/
│  └─ main.js          ← Electron 主进程
├─ pages/
├─ assets/
├─ package.json
└─ node_modules/
```
## 初始化 Electron 项目
我们在项目根目录执行：

```bash
npm init -y
```
然后安装 Electron：
```bash
npm install --save-dev electron
```
如果这一步进行很慢，强烈推荐使用：
```bash
npm config set registry https://registry.npmmirror.com
```
然后我们再来进行一次确认：
```bash
npm config get registry
```
确认输出是https://registry.npmmirror.com 后再装：
```bash
npm install --save-dev electron
```
如果还是慢：给 Electron 二进制也指定镜像
```bash
$env:ELECTRON_MIRROR="https://npmmirror.com/mirrors/electron/"; npm install --save-dev electron
```
到这里，Electron 基本就顺利安装了  
## 创建 Electron 主进程

### 创建目录结构
在项目根目录下新建 electron/main.js  
填写以下内容：
```javascript
const { app, BrowserWindow } = require('electron');
const path = require('path');

function createWindow() {
  const win = new BrowserWindow({
    width: 1000,
    height: 700,
    webPreferences: {
      contextIsolation: true
    }
  });

  win.loadFile(
    path.join(__dirname, '../index.html')
  );
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
```
这里注意其中的 
```javascript
path.join(__dirname, '../index.html')
```
这决定了程序启动时加载的入口页面，根据上面我们的项目结构，入口页面是index.html
### 配置 package.json
在根目录下的 package.json 确保包含下面这些关键字段：
```json
{
  "name": "pixelate-tool",
  "version": "1.0.0",
  "main": "electron/main.js",
  "scripts": {
    "start": "electron ."
  },
  "devDependencies": {
    "electron": "^30.0.0"
  }
}
```
这里要留意
```json
"main": "electron/main.js",
```
这里指定了 Electron 应用的入口文件，当你运行 `electron .` 时，Electron 会加载这个文件。本例中为我们在上一步新建的 electron/main.js。默认的程序入口是根目录中的index.js，你也可以使用默认的配置，将electron/main.js的文件内容复制到根目录中的index.js中。  
不将其放在默认的根目录中，是为了将 Electron 相关代码和前端文件分离开来，保持项目结构的清晰。
## 运行桌面版
在项目根目录执行：
```bash
npm start
```
以我这个小工具为例，运行后会弹出一个窗口：
{% asset_img 3.png %}
图标的设置后面我们会进行更改  
现在，你已经到达了Electron 第一里程碑。下面我们会将其打包成可执行文件。
## 产出安装包
### 安装 electron-builder
在项目根目录执行：
```bash
npm install --save-dev electron-builder
```
修改package.json：
```json
{
  "name": "try1",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "electron .",
    "build": "electron-builder"
  },
  "devDependencies": {
    "electron": "^39.2.7",
    "electron-builder": "^24.13.3"
  },
  "build": {
    "appId": "com.example.try1",
    "productName": "Pixelate Tool",
    "files": [
      "**/*"
    ],
    "win": {
      "target": "nsis"
    }
  }
}
```
我们来解释一下部分配置：
```json
"appId": "com.example.try1"
```
这是应用的唯一ID，Windows 安装、缓存、注册表会用到，可以直接写一个反域名。
```json
"productName": "Pixelate Tool"
```
这是安装包显示的名字、桌面快捷方式的名字。
```json
"files": [
  "**/*"
]
```
这是告诉electron-builder，整个项目要一起打包进去。
```json
"win": {
  "target": "nsis"
}
```
NSIS为Windows的安装器，它会生成：xxx Setup.exe
### 正式打包
在项目根目录执行：
```bash
npm run build
```
这会在项目根目录生成 dist 文件夹，里面包含了安装包，这就是完整过程，双击 xxx Setup.exe 即可安装。
这期间会在控制台滚动一堆日志，如果出现了error，请参考下文一些笔者出现的问题以及解决方案。
### 可能出现的问题：
#### 报错：'electron-builder' 不是内部或外部命令。
```text
'electron-builder' 不是内部或外部命令，也不是可运行的程序 或批处理文件。
```
这个报错的核心意思是：系统找不到 electron-builder 这个命令，可以在项目中执行
```bash
npm ls electron-builder
```
如果输出为：
```bash
Debugger attached. try1@1.0.0 E:\1otherworks\try1 
└── (empty)
```
在根目录执行：
```bash
npm install --save-dev electron-builder
```
#### 解压时报 “Cannot create symbolic link… 权限不够”：
打开 Windows 开发者模式
- 打开设置
- 进入隐私和安全性 → 开发者选项
- 打开开发人员模式（Developer Mode）
- 关闭终端再重新打开 PowerShell
- 重新打包
#### 还在从 GitHub 下载 winCodeSign：
报错为：
```bash
Get "https://github.com/electron-userland/electron-builder-binaries/...": connect timeout
```
除了ELECTRON_MIRROR（只管 Electron），你还需要给 electron-builder的二进制工具设置镜像。
运行下面三行：
```bash
$env:ELECTRON_MIRROR="https://npmmirror.com/mirrors/electron/"
$env:ELECTRON_BUILDER_BINARIES_MIRROR="https://npmmirror.com/mirrors/electron-builder-binaries/"
npm run build
```
## 继续优化
### 优化图标
在上文的图片中，你会发现笔者的图标已经不是默认的Electron图标，更换为了笔者的头像。这是如何实现的？  
Windows 的图标格式为.ico，如果你有一张JPG格式的图片，你可以使用在线工具将其转换为.ico格式。
这里笔者推荐先使用 [好运气工具箱](https://thirdh6o.github.io/hyq_works/tools/pixelate.html) 将其转换为png格式，  
再使用 [png转icon](https://www.aconvert.com/cn/icon/png-to-ico/) 将其转换为.ico格式。  
请注意，需要包含：16 / 32 / 48 / 64 / 128 / 256 多尺寸，推荐将其放置在：
```text
assets/
└─ icons/
   └─ app.ico
```
并在 package.json 中添加：
```json
{
  "build": {
    "appId": "com.example.try1",
    "productName": "Pixelate Tool",
    "icon": "assets/icons/app.ico",
    "win": {
      "target": "nsis"
    }
  }
}
```
这一行的作用 
```json
"icon": "assets/icons/app.ico"
```
它会被用作exe 图标、桌面快捷方式图标以及任务管理器图标。  

接下来设置“窗口左上角图标”  
在 Electron 主进程（index.js 或 electron/main.js）里找到这一段，加入图标信息：
```javascript
const win = new BrowserWindow({
  width: 1000,
  height: 700,
  icon: path.join(__dirname, 'assets/icons/app.ico'),
  webPreferences: {
    contextIsolation: true
  }
});
```
记得注意路径。 
### 安装器自定义
现在的问题是当你双击 Setup.exe 的时候，程序自动安装到：C:\Users\<用户名>\AppData\Local\Programs\<productName>  
用户无法选择路径。  
所以我们要开启 NSIS 的“自定义安装目录”
在 package.json 的 build.win 下加入 nsis 配置：
```json
{
  "build": {
    "appId": "com.example.try1",
    "productName": "Pixelate Tool",
    "icon": "assets/icons/app.ico",
    "win": {
      "target": "nsis"
    },
    "nsis": {
      "oneClick": false,
      "allowToChangeInstallationDirectory": true
    }
  }
}
```
你可以顺手把这三条也加上：
```json
"nsis": {
  "oneClick": false,
  "allowToChangeInstallationDirectory": true,
  "createDesktopShortcut": true,
  "createStartMenuShortcut": true,
  "shortcutName": "Pixelate Tool"
}
```
createDesktopShortcut： 安装后创建桌面快捷方式  
createStartMenuShortcut：创建开始菜单项  
shortcutName：快捷方式显示名  
## 总结
本期我们实战了如何从HTML到桌面应用的完整过程，包括：
- 项目结构
- 配置文件
- 打包过程
- 优化图标
- 安装器自定义