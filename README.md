# Monorepo Template Generator 🚀

A single-file script that generates a complete modern monorepo with React, Astro, and shared components.

## 🎯 What it creates

- **React 18 + Vite** application (`/app`)
- **Astro 5** static site (`/www`) 
- **Shared component library** (`/packages/components`)
- **ESLint + TypeScript** configuration
- **Tailwind CSS** with Radix colors
- **Husky hooks** for code quality
- **npm workspaces** setup

## 🚀 Quick Start

```bash
# Download the script
curl -O https://raw.githubusercontent.com/YOUR_USERNAME/monorepo-template-generator/main/generate-monorepo.sh

# Make it executable
chmod +x generate-monorepo.sh

# Generate your monorepo
./generate-monorepo.sh my-awesome-project my-scope
```

## 📋 Usage

```bash
./generate-monorepo.sh [project-name] [package-scope]
```

**Parameters:**
- `project-name` (optional): Name of your project (default: "my-monorepo")
- `package-scope` (optional): npm scope for shared packages (default: "my")

**Examples:**
```bash
# Basic usage
./generate-monorepo.sh

# Custom project name
./generate-monorepo.sh awesome-app

# Custom project name and scope
./generate-monorepo.sh awesome-app awesome
```

## 🎁 Generated Structure

```
your-project/
├── app/                    # React + Vite application
├── www/                    # Astro static site
├── packages/
│   ├── components/         # @your-scope/ui component library
│   └── config/            # Shared Tailwind config
├── .husky/                # Git hooks
├── package.json           # Root workspace config
└── README.md              # Project documentation
```

## ⚡ After Generation

```bash
cd your-project
npm install
npm run dev --workspaces
```

Your apps will be available at:
- **React App**: http://localhost:5173
- **Astro Site**: http://localhost:4321

## 🛠️ Features

✅ **Modern Stack**: React 18, Astro 5, TypeScript, Vite  
✅ **Code Quality**: ESLint (Airbnb), Husky hooks, lint-staged  
✅ **Styling**: Tailwind CSS with Radix color system  
✅ **Monorepo**: npm workspaces with shared components  
✅ **Ready to Use**: Pre-configured build, dev, and lint scripts  

## 🤝 Contributing

Contributions welcome! This is a single-file generator to keep it simple.

## 📄 License

MIT - Use freely for your projects!

---

**Perfect for**: Agencies, product teams, or anyone who wants a solid monorepo foundation without the setup hassle.
