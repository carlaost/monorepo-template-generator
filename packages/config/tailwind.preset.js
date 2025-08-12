/** @type {import('tailwindcss').Config} */
module.exports = {
    darkMode: ["class"],
    theme: {
      extend: {
        colors: {
          mauve: {
            1: "var(--mauve-1)",
            2: "var(--mauve-2)",
            3: "var(--mauve-3)",
            4: "var(--mauve-4)",
            5: "var(--mauve-5)",
            6: "var(--mauve-6)",
            7: "var(--mauve-7)",
            8: "var(--mauve-8)",
            9: "var(--mauve-9)",
            10: "var(--mauve-10)",
            11: "var(--mauve-11)",
            12: "var(--mauve-12)"
          },
          border: "var(--border)",
          input: "var(--input)",
          ring: "var(--ring)",
          background: "var(--background)",
          foreground: "var(--foreground)",
          primary: { DEFAULT: "var(--primary)", foreground: "var(--primary-foreground)" },
          secondary:{ DEFAULT:"var(--secondary)", foreground:"var(--secondary-foreground)"},
          destructive:{ DEFAULT:"var(--destructive, hsl(0 84% 60%))", foreground:"var(--destructive-foreground, hsl(0 0% 100%))"},
          muted: { DEFAULT:"var(--muted)", foreground:"var(--muted-foreground)"},
          accent:{ DEFAULT:"var(--accent)", foreground:"var(--accent-foreground)"},
          popover:{ DEFAULT:"var(--popover)", foreground:"var(--popover-foreground)"},
          card:{ DEFAULT:"var(--card)", foreground:"var(--card-foreground)"}
        },
        borderRadius: {
          lg: "var(--radius)",
          md: "calc(var(--radius) - 2px)",
          sm: "calc(var(--radius) - 4px)"
        },
        keyframes: {
          "accordion-down": { from: { height: 0 }, to: { height: "var(--radix-accordion-content-height)" } },
          "accordion-up":   { from: { height: "var(--radix-accordion-content-height)" }, to: { height: 0 } }
        },
        animation: {
          "accordion-down": "accordion-down 0.2s ease-out",
          "accordion-up": "accordion-up 0.2s ease-out"
        }
      }
    },
    plugins: [require("tailwindcss-animate")]
  };
  