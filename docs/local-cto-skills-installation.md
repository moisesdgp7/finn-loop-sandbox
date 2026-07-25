# Local CTO skills installation

Linear issue: TEAM-8

Date: 2026-07-24

## Source

- Repository: `C:\Users\Moises Gale\OneDrive\Documentos\CTO\finn-loop-sandbox`
- Source commit: `8cabcd3448e8bd6914b21ea11e90a5e16b9d8f20`
- Source skill folders:
  - `skills/cto-spec`
  - `skills/cto-build`
  - `skills/cto-review`
  - `skills/cto-merge` from source commit `34f9cea3e0f5aa99e033e8a77456335b5d96a9e5`
  - `skills/cto-spec` refreshed from source commit `372c70f66e323cef2e1cd65da3db3412410d0c09`

## Destination

- `C:\Users\Moises Gale\.codex\skills\cto-spec`
- `C:\Users\Moises Gale\.codex\skills\cto-build`
- `C:\Users\Moises Gale\.codex\skills\cto-review`
- `C:\Users\Moises Gale\.codex\skills\cto-merge`

Installed files for each skill:

- `SKILL.md`
- `agents\openai.yaml`

## Installation method

The installation copied only explicit files from each versioned source folder into the matching local Codex skill folder:

- `skills\cto-spec\SKILL.md` -> `C:\Users\Moises Gale\.codex\skills\cto-spec\SKILL.md`
- `skills\cto-spec\agents\openai.yaml` -> `C:\Users\Moises Gale\.codex\skills\cto-spec\agents\openai.yaml`
- `skills\cto-build\SKILL.md` -> `C:\Users\Moises Gale\.codex\skills\cto-build\SKILL.md`
- `skills\cto-build\agents\openai.yaml` -> `C:\Users\Moises Gale\.codex\skills\cto-build\agents\openai.yaml`
- `skills\cto-review\SKILL.md` -> `C:\Users\Moises Gale\.codex\skills\cto-review\SKILL.md`
- `skills\cto-review\agents\openai.yaml` -> `C:\Users\Moises Gale\.codex\skills\cto-review\agents\openai.yaml`
- `skills\cto-merge\SKILL.md` -> `C:\Users\Moises Gale\.codex\skills\cto-merge\SKILL.md`
- `skills\cto-merge\agents\openai.yaml` -> `C:\Users\Moises Gale\.codex\skills\cto-merge\agents\openai.yaml`

No recursive delete was used during the successful installation path.

## Validation commands

```powershell
python "C:\Users\Moises Gale\.codex\skills\.system\skill-creator\scripts\quick_validate.py" "C:\Users\Moises Gale\.codex\skills\cto-spec"
python "C:\Users\Moises Gale\.codex\skills\.system\skill-creator\scripts\quick_validate.py" "C:\Users\Moises Gale\.codex\skills\cto-build"
python "C:\Users\Moises Gale\.codex\skills\.system\skill-creator\scripts\quick_validate.py" "C:\Users\Moises Gale\.codex\skills\cto-review"
python "C:\Users\Moises Gale\.codex\skills\.system\skill-creator\scripts\quick_validate.py" "C:\Users\Moises Gale\.codex\skills\cto-merge"
```

## Validation results

- `cto-spec`: `Skill is valid!`
- `cto-build`: `Skill is valid!`
- `cto-review`: `Skill is valid!`
- `cto-merge`: `Skill is valid!`
- `cto-spec` refreshed from source commit `372c70f66e323cef2e1cd65da3db3412410d0c09`: `Skill is valid!`

## Source match results

The installed local files were compared against the repository source files with SHA-256 file hashes.

- `cto-spec` `SKILL.md`: match
- `cto-spec` `agents\openai.yaml`: match
- `cto-build` `SKILL.md`: match
- `cto-build` `agents\openai.yaml`: match
- `cto-review` `SKILL.md`: match
- `cto-review` `agents\openai.yaml`: match
- `cto-merge` `SKILL.md`: match
- `cto-merge` `agents\openai.yaml`: match
- `cto-spec` refreshed `SKILL.md`: match

## Preserved installed skills

The following installed skills were not modified:

- `C:\Users\Moises Gale\.codex\skills\finn-spec`
- `C:\Users\Moises Gale\.codex\skills\finn-build`
- `C:\Users\Moises Gale\.codex\skills\finn-review`
- `C:\Users\Moises Gale\.codex\skills\cto-finn-loop`

## Installed skill names

- `cto-spec`
- `cto-build`
- `cto-review`
- `cto-merge`
