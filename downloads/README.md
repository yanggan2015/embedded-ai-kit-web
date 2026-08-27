# 下载目录（仅可执行包）

本目录用于对外发布 **Windows 可执行包**，**不要**放入源码。

## 发布步骤

1. 将 `relay-c-windows-<version>.zip` / `ssh-bridge-c-windows-<version>.zip` 放到本目录
2. 编辑 `manifest.json`，填写 `file` / `version` / `filename`
3. 运行 `..\deploy.ps1` 同步到服务器

## manifest.json 示例

```json
{
  "updated": "2026-08-27",
  "packages": [
    {
      "id": "relay-c",
      "name": "relay-c",
      "version": "20260827-120000",
      "file": "relay-c-windows-20260827-120000.zip",
      "filename": "relay-c-windows-20260827-120000.zip"
    },
    {
      "id": "ssh-bridge-c",
      "name": "ssh-bridge-c",
      "version": "20260827-120000",
      "file": "ssh-bridge-c-windows-20260827-120000.zip",
      "filename": "ssh-bridge-c-windows-20260827-120000.zip"
    }
  ]
}
```
