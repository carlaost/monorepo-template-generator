What this is: a shared React component library (shadcn-style) used by both apps:

app/ (React)

www/ (Astro with React islands)

One Tailwind: both apps extend the same preset at packages/config/tailwind.preset.js.
Theme/tokens: CSS variables live in packages/components/src/theme.css (Radix mauve mapping). Change colors here anytime.

# Folder Map

```
packages/components
└─ src
   ├─ index.ts                 # root barrel (public API)
   ├─ theme.css                # tailwind layers + tokens (mauve)
   ├─ lib/
   │  └─ utils.ts              # cn()
   ├─ ui/                      # atomic shadcn components
   │  ├─ index.ts              # ui barrel
   │  └─ button.tsx
   └─ dataview/                # feature components (compose ui)
      └─ table/
         ├─ index.ts           # feature barrel
         └─ DataTable.tsx
```

**Import patterns from apps***
```
import { Button } from "@oshi/ui";                 // from root barrel
import { DataTable } from "@oshi/ui/dataview/table"; // feature subpath
```

# Using in apps (one time)
React app: import early in src/main.tsx

```import "@oshi/ui/src/theme.css";```

Astro site: import once in your base layout

```
---
import "@oshi/ui/src/theme.css";
---
```

# Adding new compoennts
## shadcn CLI
We skip `init` (Next-only) and use the CLI to add into this package.
Config is in `packages/components/components.json` (points `components` → `src/ui`, `utils` → `src/lib`, and Tailwind to the shared preset + `theme.css`).

From this folder:

```
cd packages/components
npx shadcn@latest add button   # or input, textarea, etc.
```

Ensure it’s exported:

```
// src/ui/index.ts
export { Button } from "./button";
```

(Optional) expose via the root barrel:

```
// src/index.ts
export * from "./ui";
```

You can change colors later by editing ```src/theme.css``` (no need to re-run CLI).

Add a new feature component (manual)
Create files under ```src/{featurename}/<feature>/...```

Compose UI components using relative imports (inside this package):

```
// src/dataview/table/DataTable.tsx
import { Button } from "../ui";        // or "../ui/button"
```

Use relative paths inside the package to avoid bundler duplications.

Export from the feature barrel:

```
// src/dataview/table/index.ts
export { DataTable } from "./DataTable";
```

Expose as a subpath (for clean app imports):

```
// packages/components/package.json
{
  "exports": {
    ".": "./src/index.ts",
    "./ui": "./src/ui/index.ts",
    "./dataview/table": "./src/dataview/table/index.ts" // add new paths here
  }
}
```
(Optional) re-export from the root barrel:

```
// src/index.ts
export * from "./dataview/table";
```


# Root barrel — what/why
`src/index.ts` is the public API. It re-exports from `ui` and feature barrels so apps can do:

```
import { Button } from "@oshi/ui";
```

Keep it curated. Anything you don’t export here can still be imported via explicit subpaths you define in `package.json` (`"./dataview/table"`).

# Colors (Radix mauve)
`src/theme.css` maps shadcn tokens (`--background`, `--primary`, etc.) to mauve HSLs.
Update them here any time; both apps pick up the change automatically. No CLI re-run required.