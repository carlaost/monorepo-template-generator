import { ThemeToggle } from '@oshi/ui';
import './App.css';

export default function App() {
  return (
    <header className="p-4 flex items-center gap-3">
      <ThemeToggle />
      <div className="h-6 w-6 rounded bg-mauve-9" />
    </header>
  );
}
