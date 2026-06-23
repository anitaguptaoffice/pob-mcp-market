---
name: pob-docker-mcp
description: Use when analyzing, comparing, editing, or optimizing Path of Building builds through the PoB Docker MCP server, including Claude CLI, Codex, and CodeBuddy workflows.
---

# PoB Docker MCP

Use this skill when the user wants Path of Building help and the `pob` MCP server is available or should be started through Docker.

## Runtime

The plugin provides a stdio MCP server named `pob`.

Default command:

```bash
./scripts/pob-mcp-docker.sh
```

The command pulls the published Docker image on first run, then runs `pob-mcp-server` with:

- `POB_LUA_ENABLED=true`
- `POB_FORK_PATH=/opt/PathOfBuilding/src`
- `POB_DIRECTORY=/builds`
- host builds mounted from `POB_BUILDS_DIR`, defaulting to `~/Documents/Path of Building/Builds`

## Recommended Workflow

1. Confirm the user has a PoB XML file or a build in the mounted builds directory.
2. Use `list_builds` when the user refers to a saved build by name.
3. Use Lua-backed tools whenever available because they use real PoB calculations:
   - `lua_load_build`
   - `lua_get_build_info`
   - `lua_get_stats`
   - `lua_get_tree`
   - `lua_set_tree`
   - `lua_update_tree_delta`
   - `lua_get_items`
   - `lua_get_skills`
4. Use non-Lua tools for broader analysis and reports:
   - `analyze_build`
   - `compare_builds`
   - `validate_build`
   - `suggest_skill_gems`
   - `suggest_crafting`
5. Explain changes in PoB terms: DPS, effective hit pool, resistances, ailment mitigation, tree pathing, gem links, flask uptime, and cost.

## Guardrails

- Do not claim a DPS or defensive number unless it came from a PoB/Lua tool result or an explicitly provided build export.
- Before suggesting tree edits, check current tree version and allocated nodes.
- Before mutating a build, summarize the intended change and prefer snapshot/export tools when available.
- Treat trade and poe.ninja data as live external data; if the MCP has trade disabled, state that price guidance is approximate.
- If the Docker runtime is unavailable, ask the user to start Docker and rerun the MCP command.

## Common Failures

**Docker image missing:** the script pulls it automatically. First run can take several minutes.

**Build not found:** confirm `POB_BUILDS_DIR` points to the directory containing `.xml` files.

**Lua bridge not enabled:** set `POB_LUA_ENABLED=true`.

**LuaJIT startup failure in container:** pull the latest image or pin a known-good tag:

```bash
POB_DOCKER_IMAGE=ghcr.io/anitaguptaoffice/pob-mcp:latest ./scripts/pob-mcp-docker.sh
```

**PoB data version mismatch:** prefer the latest published image from the `pob-mcp` repository after `api-stdio` is synced.

## Response Style

Keep answers build-focused. Lead with the concrete finding, then list the exact PoB changes to try. When results depend on budget, ask for the budget before recommending market purchases.
