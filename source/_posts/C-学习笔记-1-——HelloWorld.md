---
title: C#学习笔记(1)——HelloWorld
date: 2025-12-29 13:31:24
tags: 
- C#
categories:
- 学习笔记
description: 这是C#学习笔记的第一篇，介绍了如何安装Visual Studio并创建一个简单的HelloWorld项目。
---

## 安装Visual Studio
开始使用C#最简单的方法是使用IDE,我们使用Visual Studio Community来编写C#程序。 [下载Visual Studio Community](https://visualstudio.microsoft.com/vs/community/)  
下载并安装Visual Studio安装程序后，选择.NET工作负载。下载好后，启动Visual Studio。  
## 创建并运行HelloWorld项目
在开始窗口中，选择创建新项目Create a new project，从列表中选择"Console App (.NET Core)"  
输入项目名称为HelloWorld，点击创建。  
模板会自动为我们生成如下程序：
```csharp
// See https://aka.ms/new-console-template for more information
Console.WriteLine("Hello, World!");
```
这时我们点击运行，控制台就会输出"Hello, World!"  


