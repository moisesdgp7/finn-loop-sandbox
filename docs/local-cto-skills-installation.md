# Local CTO skills installation

## Source

Versioned source:

`C:\Users\Moises Gale\OneDrive\Documentos\CTO\finn-loop-sandbox\skills`

Core CTO/Finn-loop skills:

- `cto-spec`
- `cto-build`
- `cto-review`
- `cto-loop`

Optional post-loop executor:

- `cto-merge`

`cto-merge` is never called automatically by `cto-loop` and still requires
explicit human authorization.

## Destination

Install each source folder into:

`C:\Users\Moises Gale\.codex\skills\<skill-name>`

Copy only:

- `SKILL.md`
- `agents\openai.yaml`

The legacy `cto-finn-loop` skill is retired because it duplicates the core
skills. Keep the original `finn-spec`, `finn-build`, and `finn-review` skills
installed as the upstream reference.

## CTO Loop Lite contract

- `cto-spec` follows Finn Spec and adds optional Linear Project assignment as
  metadata.
- `cto-build` follows Finn Build without plugin dependencies.
- `cto-review` follows Finn Review without CodeRabbit requirements.
- `cto-loop` repeats either Build or Review in bounded passes; it does not mix
  the two modes.
- `cto-merge` remains outside the core and executes only an explicitly
  authorized merge.

Engineering Guardrails, Superpowers, and CodeRabbit are not dependencies of
the core loop. They may be used later in a separate release-level workflow.

## Validation

```powershell
$validator = "C:\Users\Moises Gale\.codex\skills\.system\skill-creator\scripts\quick_validate.py"

python $validator "C:\Users\Moises Gale\.codex\skills\cto-spec"
python $validator "C:\Users\Moises Gale\.codex\skills\cto-build"
python $validator "C:\Users\Moises Gale\.codex\skills\cto-review"
python $validator "C:\Users\Moises Gale\.codex\skills\cto-loop"
python $validator "C:\Users\Moises Gale\.codex\skills\cto-merge"
```

After copying, compare SHA-256 hashes between source and destination for every
installed file.
