# PlantUML MCP 配置指南

## 已安装的 MCP 包

- **包名**: `@brainstack/plantuml-mcp`
- **版本**: 1.0.6
- **安装路径**: `C:\Users\25174\AppData\Roaming\npm\node_modules\@brainstack\plantuml-mcp`
- **入口文件**: `dist\index.js`
- **命令**: `plantuml-mcp`

## ✅ 已验证

PlantUML MCP 服务器已成功安装并可以正常运行！

测试结果：
```
Starting PlantUML MCP server with stdio
PlantUML MCP server is ready to receive tool calls via stdio
```

## Trae IDE 配置方法

### 方法一：通过 Trae 设置界面配置

1. 打开 Trae IDE
2. 进入 **设置** → **MCP** 或 **Extensions** → **MCP Servers**
3. 点击 **Add MCP Server** 或 **添加 MCP Server**
4. 填写配置信息：
   - **Name**: `plantuml`
   - **Command**: `node`
   - **Arguments**: `C:\Users\25174\AppData\Roaming\npm\node_modules\@brainstack\plantuml-mcp\dist\index.js`
   - **Environment Variables**: （留空）

### 方法二：使用项目配置文件

已在项目中创建配置文件：
- **配置文件位置**: [`.mcp/plantuml-mcp.json`](.mcp/plantuml-mcp.json)

### 方法三：命令行快速测试

在终端中测试 MCP 服务器：

```bash
node "C:\Users\25174\AppData\Roaming\npm\node_modules\@brainstack\plantuml-mcp\dist\index.js"
```

应该看到输出：
```
Starting PlantUML MCP server with stdio
PlantUML MCP server is ready to receive tool calls via stdio
```

## PlantUML MCP 功能

安装并配置成功后，AI 可以：

### 1. 生成 PlantUML 图表
- **时序图** (Sequence Diagram)
- **类图** (Class Diagram)
- **活动图** (Activity Diagram)
- **用例图** (Use Case Diagram)
- **组件图** (Component Diagram)
- **状态图** (State Diagram)
- **部署图** (Deployment Diagram)

### 2. 图表输出格式
- PlantUML 文本格式 (`.puml`)
- PNG 图片格式
- SVG 矢量图格式

### 3. 实时渲染
- AI 可以直接渲染图表为图片
- 支持在线渲染（PlantUML 官方服务器）
- 支持本地渲染（需要安装 PlantUML + Java）

## 依赖要求

PlantUML MCP 可能需要以下依赖（用于图片渲染）：

### 1. Java JDK（必需）
- **下载地址**: https://adoptium.net/
- **验证**: 运行 `java -version` 确认已安装
- PlantUML 核心渲染需要 Java 环境

### 2. Graphviz（可选，用于某些图表类型）
- **下载地址**: https://graphviz.org/download/
- **验证**: 运行 `dot -V` 确认已安装
- 用于生成复杂图表的布局

## 快速使用示例

配置完成后，可以这样使用：

### 示例 1：生成时序图
```
请用 PlantUML 生成一个用户登录的时序图，包含用户、前端、后端、数据库四个参与者
```

### 示例 2：生成类图
```
请为用户模块生成一个类图，包含 User、Role、Permission 三个类及其关系
```

### 示例 3：生成活动图
```
请生成 GameClub 工会申请流程的活动图
```

### 示例 4：直接生成图片
```
请生成一个用户注册的活动图，并输出为 PNG 图片
```

## 配置文件内容

```json
{
  "mcpServers": {
    "plantuml": {
      "command": "node",
      "args": ["C:\\Users\\25174\\AppData\\Roaming\\npm\\node_modules\\@brainstack\\plantuml-mcp\\dist\\index.js"],
      "env": {}
    }
  }
}
```

## 验证配置

配置完成后，可以尝试以下操作：

1. **重启 Trae IDE**
2. **打开命令面板** (Ctrl+Shift+P 或 Cmd+Shift+P)
3. **输入**: `MCP: Check Status` 或 `MCP: List Servers`
4. **确认**: `plantuml` 服务器状态为 Running

或者让 AI 帮你生成一个简单的图表来验证：

```
请用 PlantUML 生成一个 hello world 的时序图
```

## 故障排除

### 问题 1：MCP 服务器无法启动

**解决方案**：
1. 确认 Node.js 已安装：`node -v`
2. 确认包已安装：`npm list -g @brainstack/plantuml-mcp`
3. 检查路径是否正确

### 问题 2：图表无法渲染为图片

**解决方案**：
1. 安装 Java JDK：https://adoptium.net/
2. 设置 JAVA_HOME 环境变量
3. 安装 Graphviz：https://graphviz.org/

### 问题 3：Trae 无法识别 MCP

**解决方案**：
1. 检查 Trae 版本（需要支持 MCP）
2. 在 Trae 设置中启用 MCP 功能
3. 重启 Trae IDE

---

**恭喜！** PlantUML MCP 已成功配置。现在你可以让 AI 帮你生成各种 UML 图表了！