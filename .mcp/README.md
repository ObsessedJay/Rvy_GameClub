# PlantUML MCP 快速入门

## ✅ 配置状态

PlantUML MCP 已成功安装和配置！

**MCP 服务器**: `plantuml-mcp` (v1.0.6)  
**状态**: ✅ 已验证可用  
**位置**: `.mcp/plantuml-mcp.json`

## 🎯 下一步操作

### 1. 在 Trae IDE 中添加 MCP Server

1. 打开 Trae IDE
2. 进入 **设置** → **MCP** → **Servers**
3. 点击 **Add Server**
4. 填写：
   - **Name**: `plantuml`
   - **Command**: `node`
   - **Arguments**: `C:\Users\25174\AppData\Roaming\npm\node_modules\@brainstack\plantuml-mcp\dist\index.js`
5. 保存并重启 Trae

### 2. 测试 MCP 功能

在 Trae 中尝试让 AI 生成图表：

```
请用 PlantUML 生成一个简单的用户登录时序图
```

## 📊 可生成的图表类型

| 类型 | 命令示例 |
|------|----------|
| 时序图 | 生成用户登录时序图 |
| 类图 | 生成用户管理类图 |
| 活动图 | 生成订单处理活动图 |
| 用例图 | 生成论坛用例图 |
| 组件图 | 生成微服务组件图 |
| 状态图 | 生成订单状态图 |

## 📁 相关文件

- **配置文件**: [`.mcp/plantuml-mcp.json`](.mcp/plantuml-mcp.json)
- **详细指南**: [`.mcp/PLANTUML_MCP配置指南.md`](.mcp/PLANTUML_MCP配置指南.md)
- **PlantUML 示例**: [`docs/GameClub活动图.puml`](docs/GameClub活动图.puml)
- **Mermaid 示例**: [`docs/GameClub_Mermaid活动图.md`](docs/GameClub_Mermaid活动图.md)

## ⚡ 快速命令

### 查看 MCP 状态
```bash
node "C:\Users\25174\AppData\Roaming\npm\node_modules\@brainstack\plantuml-mcp\dist\index.js"
```

### 生成 PlantUML 代码
直接在对话中告诉 AI 需要什么图表，例如：

```
"帮我生成一个描述用户注册流程的PlantUML活动图"
```

### 生成图片（需要 Java）
AI 可以直接渲染 PlantUML 为 PNG/SVG 图片

## 🆘 如果遇到问题

1. **MCP 未识别**: 重启 Trae IDE
2. **图片无法渲染**: 安装 Java JDK (https://adoptium.net/)
3. **图表不完整**: 安装 Graphviz (https://graphviz.org/)

---

**提示**: 完整的配置说明请查看 [PLANTUML_MCP配置指南.md](.mcp/PLANTUML_MCP配置指南.md)