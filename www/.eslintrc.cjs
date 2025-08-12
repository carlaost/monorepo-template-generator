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
  