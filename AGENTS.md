# Skill-Archive Codex/OMX Guidance

This repository stores Codex skills for hiring preparation, document review, interview prep, and feedback workflows.

## Project Layout

```
skills/
  hiring-sim-resume-review/SKILL.md
  hiring-sim-portfolio-review/SKILL.md
  hiring-sim-coding-test/SKILL.md
  hiring-sim-interview/SKILL.md
  hiring-sim-pipeline/SKILL.md
  hiring-prep-doc-feedback/SKILL.md
  hiring-prep-interview/SKILL.md
  writing-prep-cover-letter/SKILL.md
  hiring-common/
  hiring-index.md
  kevin-feedback/
```

## Codex/OMX Skill Rules

- Install runnable skills under `~/.codex/skills/`.
- Invoke skills with `$skill-name` in Codex/OMX, for example `$hiring-sim-resume-review`.
- Keep every user-invocable skill in a flat `skills/<name>/SKILL.md` directory so it can be copied directly into `~/.codex/skills/<name>/`.
- Shared references live under `skills/hiring-common/` and may be installed as `~/.codex/skills/hiring-common/`.
- Prefer Codex native subagents for independent parallel research or review work. Use `researcher` for external research, `explore` for repository lookup, and `executor` for implementation work.
- Legacy `.claude/` and `.omc/` files are migration references only. New runtime state should use `.codex/` or `.omx/` as appropriate.

## Runtime Outputs

- Pipeline state is generated under `.hiring-pipeline/`.
- OMX runtime state is generated under `.omx/`.
- Local Codex configuration is generated under `.codex/`.
- Do not commit generated runtime state, local tool configuration, resumes, cover letters, interview prep files, or environment files.

## Safety

- Never inspect secret environment files such as `.env`, `.env.*`, or `*.env`.
- Use `.env.example` or `.env.sample` only when configuration examples are needed.
