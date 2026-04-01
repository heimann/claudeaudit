#!/usr/bin/env node

import { readFileSync, readdirSync, mkdirSync, writeFileSync, existsSync } from "fs";
import { dirname, join, resolve } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const skillDir = join(__dirname, "..", "skill");
const targetDir = resolve(process.cwd(), ".claude", "skills", "claudeaudit");

mkdirSync(targetDir, { recursive: true });

const files = readdirSync(skillDir).filter((f) => f.endsWith(".md"));
for (const file of files) {
  writeFileSync(join(targetDir, file), readFileSync(join(skillDir, file), "utf-8"));
}

const relative = targetDir.replace(process.cwd() + "/", "");
console.log(`\n  claudeaudit installed → ${relative}/ (${files.length} files)\n`);

if (!existsSync(resolve(process.cwd(), ".claude", "settings.json"))) {
  console.log(`  note: no .claude/settings.json found — you may want one\n`);
}
