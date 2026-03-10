#!/usr/bin/env node

// Skill-Archive skill injector hook for Claude Code.
// Source: https://github.com/leesanghun/Skill-Archive
//
// Scans skill directories for SKILL.md files with `triggers:` in YAML
// frontmatter. When a user prompt matches trigger keywords, injects the
// skill content into context.
//
// Scan order:
//   1. {cwd}/.claude/skills/*/SKILL.md  — project-local skills
//   2. ~/.claude/skills/*/SKILL.md      — global skills (Skill-Archive installs here)
//   3. {cwd}/.claude/commands/*.md      — legacy commands (backward compat)
//
// Also scans flat .md files directly inside each skills/ directory.
//
// Hook event: UserPromptSubmit
// Stdin: { prompt, sessionId, cwd }
// Stdout: { continue: true, message?: string }

import { readFileSync, readdirSync, existsSync, statSync } from "fs";
import { join, resolve } from "path";
import { homedir } from "os";

const MAX_SKILLS = 5;

function readStdin() {
  try {
    return JSON.parse(readFileSync("/dev/stdin", "utf8"));
  } catch {
    return {};
  }
}

function parseYamlFrontmatter(content) {
  const match = content.match(/^---\n([\s\S]*?)\n---/);
  if (!match) return null;

  const yaml = match[1];
  const name = yaml.match(/^name:\s*(.+)$/m)?.[1]?.trim().replace(/^["']|["']$/g, "") || null;

  let triggers = [];
  const triggersMatch = yaml.match(/^triggers:\s*\n((?:\s+-\s+.+\n?)*)/m);
  if (triggersMatch) {
    triggers = triggersMatch[1]
      .split("\n")
      .map((line) => line.replace(/^\s+-\s+/, "").trim().replace(/^["']|["']$/g, "").toLowerCase())
      .filter(Boolean);
  }

  // Fallback: use name as trigger if no explicit triggers
  if (triggers.length === 0 && name) {
    triggers = ["/" + name.toLowerCase()];
  }

  if (triggers.length === 0) return null;

  const body = content.slice(match[0].length).trim();
  return { name, triggers, body };
}

function scanSkillsDir(dir, files, seen) {
  if (!existsSync(dir)) return;
  try {
    for (const entry of readdirSync(dir)) {
      const entryPath = join(dir, entry);
      try {
        if (statSync(entryPath).isDirectory()) {
          const skillFile = join(entryPath, "SKILL.md");
          if (existsSync(skillFile)) {
            const fullPath = resolve(skillFile);
            if (!seen.has(fullPath)) {
              seen.add(fullPath);
              files.push(fullPath);
            }
          }
        } else if (entry.endsWith(".md")) {
          const fullPath = resolve(entryPath);
          if (!seen.has(fullPath)) {
            seen.add(fullPath);
            files.push(fullPath);
          }
        }
      } catch {
        // skip unreadable entries
      }
    }
  } catch {
    // skip unreadable directories
  }
}

function findSkillFiles(cwd) {
  const files = [];
  const seen = new Set();

  // skills/*/SKILL.md (new standard) + skills/*.md (flat fallback)
  scanSkillsDir(join(cwd, ".claude", "skills"), files, seen);
  scanSkillsDir(join(homedir(), ".claude", "skills"), files, seen);

  // legacy commands/*.md support
  const commandsDir = join(cwd, ".claude", "commands");
  if (existsSync(commandsDir)) {
    try {
      for (const file of readdirSync(commandsDir)) {
        if (!file.endsWith(".md")) continue;
        const fullPath = resolve(join(commandsDir, file));
        if (!seen.has(fullPath)) {
          seen.add(fullPath);
          files.push(fullPath);
        }
      }
    } catch {
      // skip unreadable directories
    }
  }

  return files;
}

function matchSkills(promptLower, skillFiles) {
  const matches = [];

  for (const filePath of skillFiles) {
    try {
      const content = readFileSync(filePath, "utf8");
      const parsed = parseYamlFrontmatter(content);
      if (!parsed) continue;

      let score = 0;
      for (const trigger of parsed.triggers) {
        if (promptLower.includes(trigger)) {
          score += 10;
        }
      }

      if (score > 0) {
        matches.push({ ...parsed, filePath, score });
      }
    } catch {
      // skip unreadable files
    }
  }

  return matches.sort((a, b) => b.score - a.score).slice(0, MAX_SKILLS);
}

function buildMessage(skills) {
  const sections = skills.map(
    (s) => `### ${s.name || "Skill"}\n\n${s.body}`
  );

  return `<project-skills>\n\n## Matched Project Skills\n\n${sections.join("\n\n---\n\n")}\n\n</project-skills>`;
}

function main() {
  try {
    const input = readStdin();
    const prompt = (input.prompt || "").trim();

    if (!prompt) {
      process.stdout.write(JSON.stringify({ continue: true }));
      return;
    }

    const cwd = input.cwd || process.cwd();
    const promptLower = prompt.toLowerCase();
    const skillFiles = findSkillFiles(cwd);
    const matched = matchSkills(promptLower, skillFiles);

    if (matched.length === 0) {
      process.stdout.write(JSON.stringify({ continue: true }));
      return;
    }

    const message = buildMessage(matched);
    process.stdout.write(JSON.stringify({ continue: true, message }));
  } catch {
    process.stdout.write(JSON.stringify({ continue: true }));
  }
}

main();
