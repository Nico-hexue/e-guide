# 旅游景区文学文本翻译系统

一个功能强大的多语言翻译和图片识别系统，支持一带一路沿线国家语言翻译。

## 🌟 功能特色

### 文本翻译
- 支持20+种语言互译
- 实时语音识别翻译
- 自动翻译功能

### 图片识别
- 文字识别（OCR）
- 物品识别（使用火山引擎AI）
- 拍照识别功能

### 多语言支持
- 主流语言：中文、英语（多国变体）、法语、德语、日语、韩语等
- 东盟语言：马来语、泰语、越南语、印尼语、菲律宾语、柬埔寨语、老挝语、缅甸语、泰米尔语、文莱语

## 🚀 快速开始

### 本地运行
```bash
# 启动本地服务器
python -m http.server 8080
# 或使用PowerShell脚本
powershell -ExecutionPolicy Bypass -File .\start-http-server.ps1
```

访问：http://localhost:8080

### 部署到GitHub Pages
1. 将代码上传到GitHub仓库
2. 在仓库设置中启用GitHub Pages
3. 访问：https://[用户名].github.io/[仓库名]

## 📄 文件结构

```
├── index.html          # 主页面
├── README.md           # 说明文档
├── start-http-server.ps1 # 本地服务器脚本
└── simple-server.ps1   # 备用服务器脚本
```

## 🔧 技术栈

- **前端**: HTML5, CSS3, JavaScript (ES6+)
- **AI服务**: 火山引擎API, DeepSeek翻译API
- **OCR**: Tesseract.js
- **语音**: Web Speech API
- **图像处理**: Canvas API, WebRTC

## 🌐 支持的API

- **翻译服务**: DeepSeek API
- **图像识别**: 火山引擎豆包视觉模型
- **文字识别**: Tesseract OCR

## 📱 使用说明

1. **文本翻译**: 输入文本，选择语言，点击翻译
2. **语音翻译**: 点击语音按钮，开始说话
3. **图片识别**: 上传图片或拍照，识别文字或物品
4. **多语言选择**: 支持一带一路沿线国家语言

## 🔒 注意事项

- 摄像头功能需要在HTTPS环境下使用
- 部分API需要网络连接
- 建议使用Chrome、Edge等现代浏览器

## 📞 联系信息

如有问题或建议，欢迎联系开发者。