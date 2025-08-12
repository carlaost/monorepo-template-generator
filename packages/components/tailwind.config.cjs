const preset = require("../config/tailwind.preset.js");
/** @type {import('tailwindcss').Config} */
module.exports = {
  presets: [preset],
  content: ["./src/**/*.{ts,tsx}"]
};
