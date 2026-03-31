#!/usr/bin/env node

import { readFileSync, mkdirSync, writeFileSync, existsSync } from "fs";
import { dirname, join, resolve } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const skillSource = join(__dirname, "..", "skill", "SKILL.md");
const targetDir = resolve(process.cwd(), ".claude", "skills", "claudeaudit");
const targetFile = join(targetDir, "SKILL.md");

const skill = readFileSync(skillSource, "utf-8");

mkdirSync(targetDir, { recursive: true });
writeFileSync(targetFile, skill);

const relative = targetFile.replace(process.cwd() + "/", "");
console.log(`\n  claudeaudit installed → ${relative}\n`);

if (!existsSync(resolve(process.cwd(), ".claude", "settings.json"))) {
  console.log(`  note: no .claude/settings.json found — you may want one\n`);
}
