# 📸 How to Export Architecture Diagrams

**Quick Guide for Assignment Submission**

---

## ✅ All Diagrams Created

The file `ARCHITECTURE_DIAGRAMS.md` contains **10 comprehensive Mermaid diagrams** that fulfill all assignment requirements.

---

## 🎨 Method 1: Export via Mermaid Live Editor (RECOMMENDED)

### Steps:

1. **Open Mermaid Live Editor**
   - Go to: https://mermaid.live/

2. **Copy Diagram Code**
   - Open `ARCHITECTURE_DIAGRAMS.md`
   - Find the diagram you want (e.g., "System Architecture Overview")
   - Copy the entire mermaid code block (everything between ```mermaid and ```)

3. **Paste in Editor**
   - Paste the code into the left panel of mermaid.live
   - Preview appears on the right

4. **Export as Image**
   - Click **"Actions"** dropdown (top right)
   - Select **"PNG"** or **"SVG"** 
   - Image downloads automatically

5. **Rename File**
   - Rename to match assignment requirements:
     - `diagram_01_system_architecture.png`
     - `diagram_02_microservices.png`
     - etc.

---

## 🖥️ Method 2: GitHub Rendering (Easiest)

### Steps:

1. **Push to GitHub**
   ```powershell
   git add ARCHITECTURE_DIAGRAMS.md
   git commit -m "Add architecture diagrams"
   git push origin main
   ```

2. **View on GitHub**
   - Open the file on GitHub
   - Diagrams render automatically
   - Right-click → "Save Image As"

3. **Screenshot**
   - Take screenshots of rendered diagrams
   - Use Windows Snipping Tool (Win + Shift + S)

---

## 🔧 Method 3: VS Code Extension

### Steps:

1. **Install Extension**
   ```
   Markdown Preview Mermaid Support
   ```
   Extension ID: `bierner.markdown-mermaid`

2. **Preview**
   - Open `ARCHITECTURE_DIAGRAMS.md`
   - Press `Ctrl + Shift + V` (Preview)
   - Diagrams render in preview pane

3. **Export**
   - Right-click diagram → "Copy Image"
   - Paste into image editor
   - Save as PNG

---

## 📋 Diagram List for Assignment

| # | Diagram Name | File Name | Purpose |
|---|--------------|-----------|---------|
| 1 | System Architecture Overview | `diagram_01_system_architecture.png` | Shows complete system with all layers |
| 2 | Microservices Communication | `diagram_02_microservices.png` | Inter-service communication patterns |
| 3 | Docker Deployment | `diagram_03_docker_deployment.png` | Docker containerization architecture |
| 4 | Kubernetes Deployment | `diagram_04_kubernetes.png` | K8s pods, services, deployments |
| 5 | Database Schema | `diagram_05_database_schema.png` | MongoDB collections ER diagram |
| 6 | Authentication Flow | `diagram_06_auth_flow.png` | Login, signup, password reset |
| 7 | Order Processing | `diagram_07_order_processing.png` | Complete order lifecycle |
| 8 | CI/CD Pipeline | `diagram_08_cicd_pipeline.png` | GitHub Actions workflow |
| 9 | Network Architecture | `diagram_09_network.png` | Docker/K8s networking |
| 10 | Monitoring Stack | `diagram_10_monitoring.png` | Observability architecture |

---

## 🎯 Quick Export Commands

### Export ALL diagrams at once:

1. Go to https://mermaid.live/
2. Open `ARCHITECTURE_DIAGRAMS.md`
3. For each diagram:
   - Copy mermaid code
   - Paste in mermaid.live
   - Click "Actions" → "PNG"
   - Rename downloaded file

### Batch Export (Advanced):

Install mermaid-cli:
```powershell
npm install -g @mermaid-js/mermaid-cli
```

Extract diagrams and convert:
```powershell
# This will convert all diagrams (requires Node.js)
mmdc -i ARCHITECTURE_DIAGRAMS.md -o diagrams/
```

---

## 📁 Recommended Folder Structure

```
AutoMernate/
├── ARCHITECTURE_DIAGRAMS.md     # Source file
└── diagrams/                     # Exported images
    ├── diagram_01_system_architecture.png
    ├── diagram_02_microservices.png
    ├── diagram_03_docker_deployment.png
    ├── diagram_04_kubernetes.png
    ├── diagram_05_database_schema.png
    ├── diagram_06_auth_flow.png
    ├── diagram_07_order_processing.png
    ├── diagram_08_cicd_pipeline.png
    ├── diagram_09_network.png
    └── diagram_10_monitoring.png
```

---

## ✨ Pro Tips

1. **High Resolution**: Export as SVG for scalable quality
2. **Dark Mode**: Mermaid Live has dark theme option
3. **Color Customization**: Edit the `classDef` lines in code
4. **GitHub Auto-Render**: Diagrams show automatically in README
5. **Print to PDF**: Open in browser, print as PDF

---

## 🚀 For Your Report

### In your Markdown report:

```markdown
## System Architecture

The following diagram shows our microservices architecture:

![System Architecture](./diagrams/diagram_01_system_architecture.png)

### Description:
- Frontend layer with React
- API Gateway for routing
- 5 independent microservices
- MongoDB for persistence
- External services integration
```

### In Word/PDF:

1. Export diagrams as PNG (high resolution)
2. Insert → Picture
3. Add caption: "Figure 1: System Architecture"
4. Reference in text

---

## ⚡ Need Help?

- **Mermaid Syntax**: https://mermaid.js.org/intro/
- **Live Editor**: https://mermaid.live/
- **VS Code Extension**: Search "Mermaid" in extensions
- **GitHub Docs**: Automatically rendered in `.md` files

---

**All diagrams are ready to use! Just export and include in your assignment submission.**
