# Nix 语言学习笔记 - WSL 配置分析

## 1. 模块系统 (Module System)

### 模块导入模式
```nix
# wsl/init.nix:5-11
imports = [
  ../common/neovim.nix    # Neovim 配置模块
  ../common/packages.nix  # 系统包管理模块
  ../common/env.nix       # 环境变量模块
  ../common/remote.nix    # 远程访问模块
  ./networking.nix        # 网络配置模块
];
```

**Nix 知识点**:
- `imports` 是 NixOS 模块系统的核心属性
- 允许将配置分解为可重用的模块
- 模块按顺序合并，后导入的模块可以覆盖前面的配置

### 模块函数签名
```nix
# 典型模块结构
{ config, lib, pkgs, ... }:
{
  # 配置属性
}
```

**参数说明**:
- `config`: 当前累积的配置状态
- `lib`: Nixpkgs 库函数
- `pkgs`: 包集合
- `...`: 其他可能传入的参数

## 2. SpecialArgs 高级用法

### home-manager.extraSpecialArgs 分析
```nix
# flake.nix:55-61
home-manager.extraSpecialArgs = {
  unstablePkgs = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
};
```

**Nix 语言特性**:
1. **`import` 表达式**: 动态导入另一个 Nix 文件或 flake input
2. **参数化导入**: 向导入的模块传递参数
3. **属性集构造**: `{ system = "x86_64-linux"; config.allowUnfree = true; }`

**实际作用**:
- 创建了一个名为 `unstablePkgs` 的包集合
- 使用 nixpkgs-unstable 通道（最新软件包）
- 允许安装非自由软件
- 这个变量可以在 `home.nix` 中通过参数访问

## 3. 包管理模式

### 系统级包管理
```nix
# packages.nix:9-30
environment.systemPackages = with pkgs; [
  git      # 版本控制
  neovim   # 编辑器
  fish     # shell
  age      # 加密工具
  just     # 任务运行器
];
```

**Nix 知识点**:
- `with pkgs;`: 将 pkgs 属性集的属性引入当前作用域
- 列表语法: `[item1 item2 item3]`
- 包引用: 直接使用包名（如 `git`, `neovim`）

### 用户级包管理 (Home Manager)
```nix
# home.nix 中可以通过参数访问 unstablePkgs
{ config, lib, pkgs, unstablePkgs, ... }:
{
  home.packages = with unstablePkgs; [
    # 使用不稳定通道的包
  ];
}
```

## 4. 环境变量配置

### 静态环境变量
```nix
# env.nix:26-31
environment.variables = {
  ANTHROPIC_BASE_URL = "https://api.deepseek.com/anthropic";
  ANTHROPIC_MODEL = "deepseek-chat";
};
```

### 动态环境变量（从加密文件读取）
```nix
# env.nix:28
ANTHROPIC_AUTH_TOKEN = builtins.readFile config.age.secrets.anthropic-env.path;
```

**Nix 内置函数**:
- `builtins.readFile`: 读取文件内容
- `config.age.secrets.anthropic-env.path`: 访问配置系统中计算出的路径

## 5. 秘密管理 (agenix)

```nix
# env.nix:19-24
age.secrets.anthropic-env = {
  file = ../secrets/anthropic.env.age;  # 加密文件路径
  owner = "nixos";                     # 文件所有者
  group = "users";                     # 文件所属组
  mode = "600";                        # 文件权限
};
```

## 6. 函数式编程模式

### Lambda 函数
```nix
# 模块都是函数
{ config, lib, pkgs, ... }: {
  # 函数体返回属性集
}
```

### 局部变量绑定 (let...in)
```nix
# networking.nix:6-15
networking.proxy =
  let
    proxy = "http://127.0.0.1:2080";  # 局部变量
  in
  {
    httpsProxy = proxy;
    httpProxy = proxy;
  };
```

## 7. 类型系统实践

### 布尔值配置
```nix
programs.nix-ld.enable = true;     # 启用 nix-ld
programs.neovim.enable = true;     # 启用 neovim
networking.firewall.enable = false; # 禁用防火墙
```

### 列表配置
```nix
nix.settings.experimental-features = [
  "nix-command"  # 字符串列表
  "flakes"
];
```

### 属性集配置
```nix
programs.zoxide = {
  enable = true;
  enableFishIntegration = true;
  enableBashIntegration = true;
};
```

## 8. 重要的 Nix 概念总结

1. **声明式配置**: 描述期望状态，而不是执行步骤
2. **纯函数式**: 配置是无副作用的表达式
3. **不可变数据**: 一旦定义就不能修改
4. **延迟求值**: 只在需要时计算值
5. **模块化**: 通过组合小型模块构建复杂系统

## 9. 学习建议

1. **从简单模块开始**: 先理解单个模块的结构
2. **掌握 with 表达式**: 减少重复输入 pkgs. 前缀
3. **理解 import 机制**: 如何导入和参数化其他模块
4. **练习 let...in**: 局部变量绑定的使用
5. **熟悉常用内置函数**: readFile, toString, 等

这个配置展示了 Nix 语言的核心特性，非常适合学习模块化配置、函数式编程和声明式系统管理。