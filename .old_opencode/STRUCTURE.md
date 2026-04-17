# .opencode - Estructura Modular

**Última actualización:** Febrero 20, 2025
**Status:** Reorganización local (NO en git)

## 📊 Estructura de Directorios

```
.opencode/
├── config/                    Configuración centralizada
│   ├── opencode.json         CLI commands + module references
│   ├── package.json          Dependencies (@opencode-ai/plugin, js-yaml)
│   ├── tsconfig.json         TypeScript configuration
│   └── bun.lock              Dependency lock file
│
├── modules/                  4 agentes independientes
│   ├── gitops-adapter/       GitOps deployment agent
│   │   ├── agent.md          Agent definition (609 líneas)
│   │   └── tools/            7 TypeScript tools
│   │       ├── analyze-compose.ts
│   │       ├── analyze-dockerfile.ts
│   │       ├── detect-project-type.ts
│   │       ├── detect-health-endpoint.ts
│   │       ├── generate-onechart-values.ts
│   │       ├── create-gitops-structure.ts
│   │       └── validate-gitops-config.ts
│   │
│   ├── terraform-specialist/ Terraform debugging & refactoring
│   │   ├── agent.md          Agent definition (736 líneas)
│   │   └── tools/            (empty - uses shared/)
│   │
│   ├── github-pr-reviewer/   PR analysis & Spanish explanations
│   │   ├── agent.md          Agent definition (195 líneas)
│   │   └── tools/            2 JavaScript tools
│   │       ├── github-pr-fetcher.js
│   │       └── comment-explainer.js
│   │
│   └── solution-proposer/    Solution proposals from PRs
│       ├── agent.md          Agent definition (205 líneas)
│       └── tools/            1 JavaScript tool
│           └── report-generator.js
│
├── shared/                   Shared tools & schemas
│   ├── tools/
│   │   ├── pr-state-validator.js       (104 líneas)
│   │   └── code-contextualizer.js      (187 líneas)
│   └── schemas/
│       └── pr-analysis-schema.json     (117 líneas)
│
├── output/                   Analysis results (NOT tracked)
│   ├── analysis.json         PR analysis output
│   ├── solutions.json        Solution proposals
│   └── *.log                 Analysis logs
│
├── .gitignore                Updated: contains "output/"
└── node_modules/             Auto-managed by bun
```

## 🤖 Módulos

### 1. gitops-adapter
- **Purpose:** Adapt Docker/Docker-Compose projects to GitOps standard
- **Tools:** 7 TypeScript tools for analysis and generation
- **Agent Type:** Full-featured

### 2. terraform-specialist
- **Purpose:** Debug and refactor Terraform infrastructure
- **Tools:** None (inherits from shared/)
- **Agent Type:** Diagnostic

### 3. github-pr-reviewer
- **Purpose:** Analyze GitHub PRs with Spanish explanations
- **Tools:** 2 JavaScript tools (fetcher + explainer)
- **Agent Type:** Analysis + Translation

### 4. solution-proposer
- **Purpose:** Propose solutions for PR findings
- **Tools:** 1 JavaScript tool (report generator)
- **Agent Type:** Synthesis

## 🔧 Shared Resources

### Tools
- `pr-state-validator.js` - Validates PR analysis state for incremental updates
- `code-contextualizer.js` - Provides Spanish context for code suggestions

### Schemas
- `pr-analysis-schema.json` - Validates JSON output from PR analysis

## 📁 Paths

### Config Access
- `config/opencode.json` - Referenced in OpenCode config
- `config/package.json` - All dependencies
- `config/tsconfig.json` - TypeScript compilation

### Instructions
- `modules/gitops-adapter/agent.md`
- `modules/terraform-specialist/agent.md`
- `modules/github-pr-reviewer/agent.md`
- `modules/solution-proposer/agent.md`

## 🚀 Adding New Agents

To add a new agent:

```bash
# 1. Create module structure
mkdir -p modules/my-agent/tools

# 2. Create agent definition
touch modules/my-agent/agent.md

# 3. Add tools if needed
touch modules/my-agent/tools/my-tool.ts

# 4. Update config/opencode.json
# Add to "instructions" array:
# "modules/my-agent/agent.md"
```

## ⚙️ Configuration

### opencode.json Instructions
Points to 4 module agents:
- `modules/gitops-adapter/agent.md`
- `modules/terraform-specialist/agent.md`
- `modules/github-pr-reviewer/agent.md`
- `modules/solution-proposer/agent.md`

### .gitignore
- `node_modules/` - Dependencies
- `bun.lockb` - Bun lock file
- `*.log` - Log files
- `.DS_Store` - macOS
- `output/` - Analysis results (NOT tracked)

## 📊 Statistics

- **Total modules:** 4
- **Total tools:** 12 (7 TypeScript + 5 JavaScript)
- **Total lines of agent docs:** 1,945
- **Shared tools:** 2
- **Config files:** 4

## ✅ Local Only

**IMPORTANTE:** This reorganization is LOCAL ONLY
- ❌ No commits
- ❌ No pushes
- ❌ Workspace structure only

Use as-is for better organization and development workflow.
