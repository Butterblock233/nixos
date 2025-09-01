# Agenix 使用指南

## 概述
Agenix 是一个用于在 NixOS 配置中管理加密秘密的工具，使用 SSH 密钥进行加密。

## 安装

### 在 Flake 中配置
你的 `flake.nix` 已经正确配置了 agenix:

```nix
inputs = {
  agenix.url = "github:ryantm/agenix";
};

modules = [
  agenix.nixosModules.default
];
```

### 安装客户端工具
```bash
# 临时使用
nix run github:ryantm/agenix -- --help

# 或添加到系统包
environment.systemPackages = [ inputs.agenix.packages."${system}".default ];
```

## 配置

### 密钥配置 (`secrets.nix`)
在项目根目录创建 `secrets.nix` 文件：

```nix
let
  users = {
    nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICG5m3EP0r/ndk2A+7gA1gSbge3CVM+B3fXEKZWG3fVT Voltage15312@outlook.com";
  };
  systems = {
    wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICG5m3EP0r/ndk2A+7gA1gSbge3CVM+B3fXEKZWG3fVT Voltage15312@outlook.com";
  };
in
{
  "anthropic.env.age".publicKeys = [users.nixos systems.wsl];
  "github-token.age".publicKeys = [users.nixos systems.wsl];
  "database-password.age".publicKeys = [users.nixos systems.wsl];
}
```

## 使用方法

### 创建/编辑加密文件
这会调用`$env.EDITOR`来编辑文本
```bash
# 从项目根目录运行
RULES=./secrets.nix nix run github:ryantm/agenix -- -e anthropic.env.age

# 或者进入 secrets 目录
cd secrets
RULES=../secrets.nix nix run github:ryantm/agenix -- -e anthropic.env.age
```

### 解密文件查看内容
```bash
RULES=./secrets.nix nix run github:ryantm/agenix -- -d anthropic.env.age
```

### 重新加密所有文件（密钥更改时）
```bash
RULES=./secrets.nix nix run github:ryantm/agenix -- -r
```

## 在 NixOS 配置中使用

### 基本用法
```nix
{ config, ... }: {
  age.secrets.anthropic-env = {
    file = ../secrets/anthropic.env.age;
    owner = "nixos";
    group = "users";
    mode = "600";
  };

  environment.variables = {
    ANTHROPIC_AUTH_TOKEN_FILE = config.age.secrets.anthropic-env.path;
  };
}
```

### 文件权限选项
- `owner`: 文件所有者
- `group`: 文件所属组  
- `mode`: 文件权限 (如 "600" 表示仅所有者可读写)
- `path`: 自定义文件路径（可选）

## 示例：API 密钥管理

### 1. 创建加密文件
```bash
RULES=./secrets.nix nix run github:ryantm/agenix -- -e anthropic.env.age
```

在编辑器中输入：
```
ANTHROPIC_API_KEY=your_actual_api_key_here
```

### 2. 在配置中使用
```nix
age.secrets.anthropic-env = {
  file = ../secrets/anthropic.env.age;
  owner = "nixos";
  mode = "600";
};

environment.sessionVariables = {
  ANTHROPIC_API_KEY_FILE = config.age.secrets.anthropic-env.path;
};
```

### 3. 应用程序中使用
应用程序应该从 `ANTHROPIC_API_KEY_FILE` 环境变量指定的文件中读取密钥。

## 故障排除

### 常见错误
1. **"Error to find config"**: 确保 `secrets.nix` 文件存在且路径正确
2. **"malformed SSH recipient"**: SSH 公钥格式错误，检查密钥是否正确复制
3. **文件未找到**: 确保在正确的目录运行命令

### 调试技巧
```bash
# 检查 secrets.nix 语法
nix eval -f secrets.nix

# 查看 agenix 帮助
nix run github:ryantm/agenix -- --help
```

## 最佳实践

1. **密钥管理**: 使用不同的 SSH 密钥对用于不同环境
2. **备份**: 定期备份加密的秘密文件
3. **权限**: 设置严格的文件权限 (600)
4. **版本控制**: 加密文件可以安全地提交到版本控制
5. **多环境**: 为开发、测试、生产环境使用不同的密钥

## 参考链接
- [Agenix GitHub](https://github.com/ryantm/agenix)
- [NixOS Wiki: Agenix](https://wiki.nixos.org/wiki/Agenix)
- [Age Encryption](https://github.com/FiloSottile/age)