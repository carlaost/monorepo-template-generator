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
  
      // Don’t require .ts/.tsx extensions in imports
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
  