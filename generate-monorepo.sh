#!/bin/bash

# Monorepo Template Generator
# Creates a modern React + Astro monorepo with shared components
# Usage: ./generate-monorepo.sh [project-name] [scope]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
PROJECT_NAME=${1:-"my-monorepo"}
SCOPE=${2:-"my"}
TARGET_DIR="${PROJECT_NAME}"

echo -e "${BLUE}🚀 Monorepo Template Generator${NC}"
echo -e "${BLUE}================================${NC}"
echo ""
echo -e "📁 Project Name: ${GREEN}${PROJECT_NAME}${NC}"
echo -e "📦 Package Scope: ${GREEN}@${SCOPE}${NC}"
echo -e "📂 Target Directory: ${GREEN}${TARGET_DIR}${NC}"
echo ""

# Check if directory exists
if [ -d "$TARGET_DIR" ]; then
    echo -e "${RED}❌ Directory ${TARGET_DIR} already exists!${NC}"
    echo -e "${YELLOW}💡 Choose a different name or remove the existing directory${NC}"
    exit 1
fi

echo -e "${BLUE}📁 Creating project structure...${NC}"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# Initialize git
git init

# Create root package.json
cat > package.json << EOF
{
  "name": "${PROJECT_NAME}",
  "private": true,
  "workspaces": [
    "app",
    "www",
    "packages/*"
  ],
  "devDependencies": {
    "@typescript-eslint/eslint-plugin": "7.18.0",
    "@typescript-eslint/parser": "7.18.0",
    "autoprefixer": "^10.4.21",
    "eslint": "8.57.0",
    "eslint-config-airbnb": "^19.0.4",
    "eslint-config-airbnb-typescript": "^18.0.0",
    "eslint-import-resolver-typescript": "^3.10.1",
    "eslint-plugin-astro": "^1.3.1",
    "eslint-plugin-import": "^2.29.1",
    "eslint-plugin-jsx-a11y": "^6.8.0",
    "eslint-plugin-react": "^7.34.3",
    "eslint-plugin-react-hooks": "^4.6.2",
    "husky": "^9.1.7",
    "lint-staged": "^15.5.2",
    "postcss": "^8.5.6",
    "tailwindcss": "^3.4.17",
    "tailwindcss-animate": "^1.0.7"
  },
  "dependencies": {
    "@radix-ui/colors": "^3.0.0"
  },
  "scripts": {
    "lint": "eslint \"{app,www}/**/*.{js,jsx,ts,tsx,astro}\"",
    "lint:fix": "npm run lint -- --fix",
    "lint:strict": "npm run lint -- --max-warnings 0",
    "typecheck": "npm run -w app typecheck && npm run -w www typecheck",
    "prepare": "husky"
  },
  "lint-staged": {
    "**/*.{js,jsx,ts,tsx,astro}": [
      "eslint --fix"
    ]
  }
}
EOF

echo -e "${GREEN}✅ Root package.json created${NC}"

# Create React app
echo -e "${BLUE}⚛️  Creating React app...${NC}"
mkdir -p app/src/assets app/public
cat > app/package.json << EOF
{
  "name": "${PROJECT_NAME}-app",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "lint": "eslint .",
    "preview": "vite preview",
    "typecheck": "tsc -p tsconfig.json --noEmit"
  },
  "dependencies": {
    "@${SCOPE}/ui": "workspace:*",
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@types/react": "^18.3.3",
    "@types/react-dom": "^18.3.0",
    "@vitejs/plugin-react": "^4.3.1",
    "typescript": "^5.5.3",
    "vite": "^5.4.1"
  }
}
EOF

cat > app/index.html << 'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>React App</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

cat > app/src/main.tsx << 'EOF'
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import './index.css';
import App from './App';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
);
EOF

cat > app/src/App.tsx << EOF
import { ThemeToggle } from '@${SCOPE}/ui';
import './App.css';

export default function App() {
  return (
    <header className="p-4 flex items-center gap-3">
      <ThemeToggle />
      <div className="h-6 w-6 rounded bg-mauve-9" />
    </header>
  );
}
EOF

cat > app/src/App.css << 'EOF'
#root {
  max-width: 1280px;
  margin: 0 auto;
  padding: 2rem;
  text-align: center;
}
EOF

cat > app/src/index.css << 'EOF'
@import '@oshi/ui/theme.css';
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# Create Vite config
cat > app/vite.config.ts << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
})
EOF

# Create TypeScript configs for app
cat > app/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "isolatedModules": true,
    "moduleDetection": "force",
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"]
}
EOF

cat > app/tsconfig.eslint.json << 'EOF'
{
  "extends": "./tsconfig.json",
  "include": ["src", "vite.config.ts"]
}
EOF

# ESLint config for app
cat > app/.eslintrc.cjs << 'EOF'
module.exports = {
    root: true,
    extends: ["airbnb", "airbnb/hooks", "airbnb-typescript"],
    parserOptions: { 
      project: ["./tsconfig.eslint.json"], 
      tsconfigRootDir: __dirname,
      warnOnUnsupportedTypeScriptVersion: false
    },
    settings: { "import/resolver": { typescript: true } },
    rules: {
      // React 17+ / Vite: no need to import React
      "react/react-in-jsx-scope": "off",
  
      // Don't require .ts/.tsx extensions in imports
      "import/extensions": [
        "error",
        "ignorePackages",
        { ts: "never", tsx: "never", js: "never", jsx: "never" }
      ],
  
      // Allow config files to be devDependencies
      "import/no-extraneous-dependencies": ["error", {
        devDependencies: [
          "**/vite.config.{ts,js,mjs,cjs}",
          "**/*.config.{ts,js,cjs,mjs}",
          "**/eslint.config.js",
          "**/astro.config.mjs",
          "**/tailwind.config.cjs"
        ]
      }]
    },
    ignorePatterns: ["dist", "node_modules"]
  };
EOF

# Tailwind config for app
cat > app/tailwind.config.cjs << EOF
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
    "../packages/components/src/**/*.{js,ts,jsx,tsx}",
  ],
  presets: [require("../@${SCOPE}/config/tailwind.preset.js")],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

cat > app/postcss.config.cjs << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

echo -e "${GREEN}✅ React app created${NC}"

# Create Astro www site
echo -e "${BLUE}🚀 Creating Astro site...${NC}"
mkdir -p www/src/{components,layouts,pages,styles,assets} www/public

cat > www/package.json << EOF
{
  "name": "${PROJECT_NAME}-www",
  "type": "module",
  "version": "0.0.1",
  "scripts": {
    "dev": "astro dev",
    "start": "astro dev",
    "build": "astro check && astro build",
    "preview": "astro preview",
    "astro": "astro",
    "typecheck": "astro check"
  },
  "dependencies": {
    "@astrojs/check": "^0.9.4",
    "@astrojs/tailwind": "^5.1.2",
    "astro": "^5.12.9",
    "tailwindcss": "^3.4.17",
    "typescript": "^5.6.3"
  }
}
EOF

cat > www/astro.config.mjs << 'EOF'
import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  integrations: [tailwind()],
});
EOF

cat > www/src/pages/index.astro << 'EOF'
---
import Layout from '../layouts/Layout.astro';
import Welcome from '../components/Welcome.astro';
---

<Layout title="Welcome to Astro.">
	<main>
		<Welcome />
	</main>
</Layout>
EOF

cat > www/src/layouts/Layout.astro << 'EOF'
---
export interface Props {
	title: string;
}

const { title } = Astro.props;
---

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" />
		<meta name="description" content="Astro description" />
		<meta name="viewport" content="width=device-width" />
		<link rel="icon" type="image/svg+xml" href="/favicon.svg" />
		<meta name="generator" content={Astro.generator} />
		<title>{title}</title>
	</head>
	<body>
		<slot />
	</body>
</html>
<style is:global>
	html {
		font-family: system-ui, sans-serif;
	}
	code {
		font-family:
			Menlo,
			Monaco,
			Lucida Console,
			Liberation Mono,
			DejaVu Sans Mono,
			Bitstream Vera Sans Mono,
			Courier New,
			monospace;
	}
</style>
EOF

cat > www/src/components/Welcome.astro << 'EOF'
---
---

<div class="flex flex-col items-center gap-8 p-8">
  <h1 class="text-4xl font-bold text-center bg-gradient-to-r from-purple-600 to-blue-600 bg-clip-text text-transparent">
    Welcome to Your Monorepo!
  </h1>
  <p class="text-lg text-gray-600 text-center max-w-2xl">
    This is your Astro marketing site. Perfect for landing pages, documentation, and static content.
  </p>
  <div class="flex gap-4">
    <a href="/docs" class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
      Get Started
    </a>
    <a href="/app" class="px-6 py-3 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
      View App
    </a>
  </div>
</div>
EOF

cat > www/src/styles/global.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# TypeScript config for www
cat > www/tsconfig.json << 'EOF'
{
  "extends": "astro/tsconfigs/strict"
}
EOF

cat > www/tsconfig.eslint.json << 'EOF'
{
  "extends": "./tsconfig.json",
  "include": [
    "src/**/*",
    "astro.config.mjs",
    "tailwind.config.cjs"
  ]
}
EOF

# ESLint config for www
cat > www/.eslintrc.cjs << 'EOF'
module.exports = {
    root: true,
    extends: [
      // Base TS rules only (no React here)
      "airbnb-base",
      "airbnb-typescript/base",
      "plugin:astro/recommended"
    ],
    parserOptions: { 
      project: ["./tsconfig.eslint.json"], 
      tsconfigRootDir: __dirname,
      warnOnUnsupportedTypeScriptVersion: false
    },
    settings: { "import/resolver": { typescript: true } },
    overrides: [
      {
        files: ["**/*.astro"],
        parser: "astro-eslint-parser",
        parserOptions: {
          parser: "@typescript-eslint/parser",
          extraFileExtensions: [".astro"]
        },
        rules: {
            "no-tabs": "off",
            "@typescript-eslint/quotes": "off",
            "react/no-unknown-property": "off",
            "react/react-in-jsx-scope": "off",
            "react/jsx-filename-extension": "off",
            "react/jsx-indent": "off",
            "react/jsx-one-expression-per-line": "off"
          }          
      },
      {
        // Only apply React rules where React is actually used
        files: ["**/*.{tsx,jsx}"],
        extends: ["airbnb", "airbnb/hooks"],
        rules: {
          "react/react-in-jsx-scope": "off" // React 17+
        }
      }
    ],
    ignorePatterns: ["dist", "node_modules"]
  };
EOF

# Tailwind config for www
cat > www/tailwind.config.cjs << EOF
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  presets: [require("../@${SCOPE}/config/tailwind.preset.js")],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

cat > www/postcss.config.cjs << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

echo -e "${GREEN}✅ Astro site created${NC}"

# Create shared packages
echo -e "${BLUE}📦 Creating shared packages...${NC}"
mkdir -p packages/components/src/{components,ui,hooks,lib}
mkdir -p packages/config
mkdir -p packages/styles

# Components package
cat > packages/components/package.json << EOF
{
  "name": "@${SCOPE}/ui",
  "version": "0.0.1",
  "type": "module",
  "main": "./src/index.ts",
  "exports": {
    ".": "./src/index.ts",
    "./theme.css": "./src/theme.css"
  },
  "scripts": {
    "typecheck": "tsc --noEmit"
  },
  "peerDependencies": {
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  },
  "devDependencies": {
    "@types/react": "^18.3.3",
    "@types/react-dom": "^18.3.0",
    "typescript": "^5.5.3"
  },
  "dependencies": {
    "@radix-ui/colors": "^3.0.0",
    "tailwindcss": "^3.4.17"
  }
}
EOF

cat > packages/components/src/index.ts << 'EOF'
// UI Components
export * from './ui';

// Hooks
export * from './hooks';

// Utilities
export * from './lib/utils';
EOF

cat > packages/components/src/ui/index.ts << 'EOF'
export * from './button';
export * from './input';
export * from './textarea';
export * from './theme-toggle';
EOF

cat > packages/components/src/ui/button.tsx << 'EOF'
import { forwardRef } from 'react';

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'default' | 'outline' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className = '', variant = 'default', size = 'md', ...props }, ref) => {
    const baseClasses = 'inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50';
    
    const variants = {
      default: 'bg-blue-600 text-white hover:bg-blue-700',
      outline: 'border border-gray-300 bg-white hover:bg-gray-50',
      ghost: 'hover:bg-gray-100',
    };
    
    const sizes = {
      sm: 'px-3 py-1.5 text-sm',
      md: 'px-4 py-2',
      lg: 'px-6 py-3 text-lg',
    };

    return (
      <button
        ref={ref}
        className={`${baseClasses} ${variants[variant]} ${sizes[size]} ${className}`}
        {...props}
      />
    );
  }
);

Button.displayName = 'Button';
EOF

cat > packages/components/src/ui/theme-toggle.tsx << 'EOF'
import { useTheme } from '../hooks/useTheme';
import { Button } from './button';

export function ThemeToggle() {
  const { theme, toggleTheme } = useTheme();

  return (
    <Button
      variant="outline"
      size="sm"
      onClick={toggleTheme}
      className="w-10 h-10 p-0"
    >
      {theme === 'dark' ? '🌙' : '☀️'}
    </Button>
  );
}
EOF

cat > packages/components/src/hooks/index.ts << 'EOF'
export * from './useTheme';
EOF

cat > packages/components/src/hooks/useTheme.ts << 'EOF'
import { useState, useEffect } from 'react';

export function useTheme() {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');

  useEffect(() => {
    const savedTheme = localStorage.getItem('theme') as 'light' | 'dark' | null;
    if (savedTheme) {
      setTheme(savedTheme);
      document.documentElement.classList.toggle('dark', savedTheme === 'dark');
    }
  }, []);

  const toggleTheme = () => {
    const newTheme = theme === 'light' ? 'dark' : 'light';
    setTheme(newTheme);
    localStorage.setItem('theme', newTheme);
    document.documentElement.classList.toggle('dark', newTheme === 'dark');
  };

  return { theme, toggleTheme };
}
EOF

cat > packages/components/src/lib/utils.ts << 'EOF'
export function cn(...classes: (string | undefined | null | false)[]): string {
  return classes.filter(Boolean).join(' ');
}

export function formatDate(date: Date): string {
  return new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  }).format(date);
}
EOF

cat > packages/components/src/theme.css << 'EOF'
@import '@radix-ui/colors/mauve.css';
@import '@radix-ui/colors/blue.css';
@import '@radix-ui/colors/red.css';
@import '@radix-ui/colors/green.css';

@import '@radix-ui/colors/mauve-dark.css';
@import '@radix-ui/colors/blue-dark.css';
@import '@radix-ui/colors/red-dark.css';
@import '@radix-ui/colors/green-dark.css';

:root {
  --background: var(--mauve-1);
  --foreground: var(--mauve-12);
  --primary: var(--blue-9);
  --primary-foreground: white;
  --border: var(--mauve-6);
  --ring: var(--blue-7);
}

.dark {
  --background: var(--mauve-dark-1);
  --foreground: var(--mauve-dark-12);
  --primary: var(--blue-dark-9);
  --primary-foreground: white;
  --border: var(--mauve-dark-6);
  --ring: var(--blue-dark-7);
}

* {
  border-color: var(--border);
}

body {
  background-color: var(--background);
  color: var(--foreground);
}
EOF

cat > packages/components/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"]
}
EOF

# Config package
cat > packages/config/package.json << EOF
{
  "name": "@${SCOPE}/config",
  "version": "0.0.1",
  "main": "./tailwind.preset.js",
  "files": ["tailwind.preset.js"]
}
EOF

cat > packages/config/tailwind.preset.js << 'EOF'
const { mauve, blue, red, green } = require('@radix-ui/colors');

/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    extend: {
      colors: {
        ...mauve,
        ...blue,
        ...red,
        ...green,
      },
      animation: {
        'fade-in': 'fadeIn 0.5s ease-in-out',
        'slide-up': 'slideUp 0.3s ease-out',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
      },
    },
  },
  plugins: [],
};
EOF

echo -e "${GREEN}✅ Shared packages created${NC}"

# Create Husky hooks
echo -e "${BLUE}🪝 Setting up Git hooks...${NC}"
mkdir -p .husky

cat > .husky/pre-commit << 'EOF'
npx lint-staged
EOF

cat > .husky/pre-push << 'EOF'
npm run lint:strict && npm run typecheck
EOF

chmod +x .husky/pre-commit .husky/pre-push

# Create gitignore
cat > .gitignore << 'EOF'
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

node_modules
dist
dist-ssr
*.local

# Editor directories and files
.vscode/*
!.vscode/extensions.json
.idea
.DS_Store
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# Astro
.astro/

# Environment variables
.env
.env.local
.env.*.local

# Build outputs
build/
public/build/

# Dependencies
/node_modules/
/.pnp
.pnp.js

# Testing
/coverage/

# Production
/build

# Misc
.DS_Store
.env.local
.env.development.local
.env.test.local
.env.production.local

npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOF

# Create README
cat > README.md << EOF
# ${PROJECT_NAME}

A modern monorepo containing multiple web applications and shared components.

## 🏗️ Repository Structure

\`\`\`
${PROJECT_NAME}/
├── app/                    # React + Vite web application
├── www/                    # Astro static site/marketing site
├── packages/               # Shared packages and components
│   ├── components/         # Shared UI components (@${SCOPE}/ui)
│   ├── config/            # Shared configuration files
│   └── styles/            # Shared styling utilities
└── api/                   # Backend functions (planned)
\`\`\`

## 🚀 Getting Started

### Installation

\`\`\`bash
# Install dependencies for all workspaces
npm install
\`\`\`

### Development

\`\`\`bash
# Start all development servers
npm run dev --workspaces

# Start specific application
npm run dev --workspace=app      # React app on http://localhost:5173
npm run dev --workspace=www      # Astro site on http://localhost:4321
\`\`\`

### Building

\`\`\`bash
# Build all applications
npm run build --workspaces

# Build specific application
npm run build --workspace=app
npm run build --workspace=www
\`\`\`

## 🔧 Development Tools

### Linting & Code Quality

\`\`\`bash
# Lint all code
npm run lint

# Lint and auto-fix issues
npm run lint:fix

# Strict linting (fail on warnings)
npm run lint:strict

# Type checking
npm run typecheck
\`\`\`

## 📦 Applications & Packages

### /app - React Application
- **Framework**: React 18 + TypeScript
- **Build Tool**: Vite
- **Styling**: Tailwind CSS
- **Purpose**: Main web application interface

### /www - Marketing Site
- **Framework**: Astro 5 + TypeScript
- **Styling**: Tailwind CSS
- **Purpose**: Static marketing site and documentation

### /packages/components - Shared UI Library
- **Package Name**: \`@${SCOPE}/ui\`
- **Framework**: React + TypeScript
- **Styling**: Tailwind CSS with Radix Colors
- **Purpose**: Shared components across applications

## 🛠️ Technology Stack

| Layer | Technologies |
|-------|-------------|
| **Frontend Frameworks** | React 18, Astro 5 |
| **Build Tools** | Vite, Astro |
| **Languages** | TypeScript, JavaScript |
| **Styling** | Tailwind CSS, Radix Colors |
| **Code Quality** | ESLint (Airbnb), TypeScript |
| **Package Management** | npm workspaces |
| **Version Control** | Git with Husky hooks |

## 📁 Workspace Commands

\`\`\`bash
# Add dependency to specific workspace
npm install <package> --workspace=app
npm install <package> --workspace=www
npm install <package> --workspace=@${SCOPE}/ui

# Run scripts in specific workspace
npm run build --workspace=app
npm run dev --workspace=www
\`\`\`

---

Generated by **Monorepo Template Generator** 🚀
EOF

echo ""
echo -e "${GREEN}✅ Monorepo template generated successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Next steps:${NC}"
echo -e "  1. ${YELLOW}cd ${TARGET_DIR}${NC}"
echo -e "  2. ${YELLOW}npm install${NC}"
echo -e "  3. ${YELLOW}npm run dev --workspaces${NC}"
echo ""
echo -e "${BLUE}🚀 Your applications will be available at:${NC}"
echo -e "  • React App: ${GREEN}http://localhost:5173${NC}"
echo -e "  • Astro Site: ${GREEN}http://localhost:4321${NC}"
echo ""
echo -e "${BLUE}🎯 What's included:${NC}"
echo -e "  ✅ Modern React + Astro monorepo"
echo -e "  ✅ Shared component library (@${SCOPE}/ui)"
echo -e "  ✅ ESLint + TypeScript configuration"
echo -e "  ✅ Tailwind CSS with Radix colors"
echo -e "  ✅ Pre-commit hooks with Husky"
echo -e "  ✅ Workspace-based development"
echo ""
echo -e "${GREEN}🎉 Happy coding!${NC}"
