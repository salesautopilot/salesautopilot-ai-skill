# SalesAutopilot Plugin

A self-hosted Claude Code plugin marketplace for SalesAutopilot. Bundles:

- A reference to the live SalesAutopilot MCP server (`https://mcp.salesautopilot.com/mcp`) — the same server available as a standalone connector in the Claude Connectors Directory.
- The `salesautopilot-domain-knowledge` skill, which teaches Claude the product's domain model (lists, letters, forms, sends, actions, segments) and the exact scope of what the MCP server can and cannot do.
- The `salesautopilot-feature-catalog` skill: the full feature list from salesautopilot.hu with package availability, so Claude can answer "how do I get the most out of my SalesAutopilot account?" with a personal, prioritized plan.

## Install (Claude Code)

```
/plugin marketplace add salesautopilot/salesautopilot-ai-skill
/plugin install salesautopilot@salesautopilot-ai-skill
```

Restart Claude Code afterward so the bundled MCP server connects. You'll be prompted to sign in with your SalesAutopilot account (OAuth) on first use, same as the standalone connector.

## What's in here

```
.claude-plugin/marketplace.json   — marketplace manifest
salesautopilot/
  .claude-plugin/plugin.json      — plugin manifest
  .mcp.json                       — points at the live MCP server
  skills/salesautopilot-domain-knowledge/
    SKILL.md
    references/mcp-tool-scope.md
    references/letter-mergetags.md
    references/deliverability-best-practices.md
  skills/salesautopilot-feature-catalog/
    SKILL.md
    references/feature-catalog.md   — GENERATED, do not edit by hand
scripts/sync-feature-catalog.mjs  — regenerates feature-catalog.md from the Webflow CMS
```

## Updating the feature catalog

`feature-catalog.md` is generated from the "Funkciók" collection of the salesautopilot.hu Webflow CMS. Edit the features in Webflow, never the file.

- **Automatically:** the `Sync feature catalog` GitHub Action runs every Monday (or on demand from the Actions tab), and opens a PR with the regenerated file and a plugin patch version bump when something changed. It needs the `WEBFLOW_API_TOKEN` repository secret (Webflow site token, `cms:read` scope) and "Allow GitHub Actions to create and approve pull requests" enabled.
- **Locally:** `WEBFLOW_API_TOKEN=... node scripts/sync-feature-catalog.mjs` (Node 20+, no dependencies).

Only published CMS items are included, and the internal "Háttérinformációk" field is never exported.

## License

Proprietary — © SalesAutopilot. This repository is published so the plugin can be installed via Claude Code's self-hosted marketplace mechanism; it is not open source.
