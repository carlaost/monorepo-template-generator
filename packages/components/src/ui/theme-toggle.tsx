import * as React from "react";
import { useTheme } from "../hooks/useTheme";
import { Button } from "./button";

export function ThemeToggle() {
  const { theme, toggle } = useTheme();
  return (
    <Button onClick={toggle} variant="ghost" size="sm" aria-label="Toggle theme">
      {theme === "dark" ? "🌙" : "☀️"}
    </Button>
  );
}
