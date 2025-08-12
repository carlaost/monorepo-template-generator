const preset = require("../packages/config/tailwind.preset.js");

/** @type {import('tailwindcss').Config} */
module.exports = {
  presets: [preset],
  content: [
    "./index.html",
    "./src/**/*.{ts,tsx}",
    "../packages/components/src/**/*.{ts,tsx}",
  ],
  safelist: [
    { pattern: /bg-mauve-(1[0-2]|[1-9])/ },
    { pattern: /text-mauve-(1[0-2]|[1-9])/ },
    { pattern: /border-mauve-(1[0-2]|[1-9])/ },
  ],
};


