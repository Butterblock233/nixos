我来帮你梳理一下 **`age`** 和 **`rage`** 对 `ssh-agent` 的支持情况，以及和带口令的 SSH key 的关系：

---

### 1. 背景

* `age` 是由 Filippo Valsorda 设计的现代文件加密工具，本身协议很简单，主要依赖 **age identity** (基于 X25519) 或 **SSH key**（RSA/Ed25519 等）。
* `rage` 是 `age` 的一个兼容实现（Rust 写的），功能覆盖 `age`，但实现细节略有不同，尤其是和 `ssh-agent` 的交互。

---

### 2. `ssh-agent` 支持现状

* **age (官方 Go 实现)**

  * 支持 `--identity` 指定 SSH 私钥解密。
  * 默认会尝试通过 `SSH_AUTH_SOCK` 与 `ssh-agent` 交互。
  * 如果私钥在 `ssh-agent` 里（已经解锁），那么解密时不会再询问口令。
  * 如果私钥没加载到 agent，或者 key 本身有 passphrase 没解锁，`age` 会失败。

* **rage (Rust 实现)**

  * 同样支持通过 `ssh-agent` 使用 SSH key。
  * 和 `age` 不同的是，它还支持 **多种 agent 协议**（例如 Pageant，适用于 Windows）。
  * 已解锁的 SSH key 可以透明使用；未解锁的 key 如果直接读文件，就会提示输入 passphrase（rage 内部调用 `rpassword`）。

---

### 3. 关于 **带口令的 SSH key**

* `ssh-agent` 的核心作用就是 **提前解锁有口令的 SSH key**，然后缓存解密后的私钥。
* 一旦 key 已经 `ssh-add` 到 agent 里，后续 `age`/`rage` 使用它时，不会再要求输入口令。
* 如果你直接在命令行 `age -d -i ~/.ssh/id_ed25519`，而这个 key 有 passphrase、又没放进 agent，那么就会卡在输入密码环节（`age`/`rage` 都是如此）。

---

### 4. 可能遇到的问题

* 如果你**习惯所有 key 都加 passphrase**，那么最好的做法就是：

  1. `ssh-add ~/.ssh/id_ed25519` （把 key 加入 agent，并解锁一次）
  2. 确认 `SSH_AUTH_SOCK` 环境变量已指向当前 agent
  3. 使用 `age`/`rage` 解密，加密时指定 recipient 为对应的 `ssh-ed25519 ...` 公钥

* **不会有“key 有口令 → ssh-agent 就失效”的问题**，只要你先解锁并放入 agent，后续使用都是无感的。

---

### 结论

* `age` 和 `rage` 都支持 `ssh-agent`。
* 带 passphrase 的 SSH key 不会导致出问题，只是需要先解锁（`ssh-add`），否则工具会提示你输入密码。
* `rage` 的 `ssh-agent` 支持比 `age` 更广（尤其在跨平台上）。

---

要不要我给你写一个 **最小示例**（含加密/解密命令），演示带口令的 `id_ed25519` 配合 `ssh-agent` 用在 `rage`/`age` 里的完整流程？
