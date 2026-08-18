# Using nix repl to explore NixOS options

Always use the nix repl to find options, never guess attribute paths.

## Workflow

1. Start repl and load flake:
```bash
nix repl --command ':lf .'
```

2. Explore from the root up:
```
nixosConfigurations.<machine>
nixosConfigurations.<machine>.options
nixosConfigurations.<machine>.options.services
nixosConfigurations.<machine>.options.services.<service>
```

3. Check option details:
- `.example` - example value
- `.description` - documentation
- `.type` - value type

4. Quit with `:q`

## One-liner format

```bash
echo ':lf .
nixosConfigurations.<machine>.options.services.<service>
:q' | nix repl
```

## Never do

- Guess option paths (e.g. `services.llama-cpp.models`)
- Use `find` to search nix store for module files
- Assume option names from other services
