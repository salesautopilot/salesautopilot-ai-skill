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

## Install (claude.ai / Claude desktop app)

Download the skill zips (always the latest version):

- [salesautopilot-feature-catalog.zip](https://github.com/salesautopilot/salesautopilot-ai-skill/releases/latest/download/salesautopilot-feature-catalog.zip)
- [salesautopilot-domain-knowledge.zip](https://github.com/salesautopilot/salesautopilot-ai-skill/releases/latest/download/salesautopilot-domain-knowledge.zip)

Then in Claude: **Settings → Capabilities → Skills → Upload skill**, once per zip ("Code execution and file creation" must be enabled). Also enable the **SalesAutopilot** connector under **Settings → Connectors** — the skills use it to look at your account.

Uploaded skills don't update themselves: download and upload again to get a newer feature catalog. With the SalesAutopilot connector enabled, the skill reads the always-current catalog through the connector's `get_feature_catalog` tool instead, so an outdated upload only matters without the connector.

**Team / Enterprise admins** can instead upload the whole plugin for the organization: [salesautopilot-plugin.zip](https://github.com/salesautopilot/salesautopilot-ai-skill/releases/latest/download/salesautopilot-plugin.zip).

## What's in here

```
.claude-plugin/marketplace.json   — marketplace manifest
salesautopilot/
  .claude-plugin/plugin.json      — plugin manifest
  README.md, LICENSE              — required by the Claude plugin directory (plugin folder is what gets listed)
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
scripts/build-zips.sh             — builds the plugin and per-skill zips into dist/
.github/workflows/
  sync-feature-catalog.yml        — weekly catalog sync, commits to main
  release.yml                     — publishes the zips as release v<plugin version>
```

## Updating the feature catalog

`feature-catalog.md` is generated from the "Funkciók" collection of the salesautopilot.hu Webflow CMS. Edit the features in Webflow, never the file.

- **Automatically:** the `Sync feature catalog` GitHub Action runs every Monday (or on demand from the Actions tab), and when something changed it commits the regenerated file and a plugin patch version bump straight to `main`, then publishes new release zips. It needs the `WEBFLOW_API_TOKEN` repository secret (Webflow site token, `cms:read` scope).
- **Locally:** `WEBFLOW_API_TOKEN=... node scripts/sync-feature-catalog.mjs` (Node 20+, no dependencies).

Any other change under `salesautopilot/` pushed to `main` also refreshes the release zips (bump the version in `plugin.json` to publish it as a new release). Only published CMS items are included, and the internal "Háttérinformációk" field is never exported.

## License

Proprietary — © SalesAutopilot. This repository is published so the plugin can be installed via Claude Code's self-hosted marketplace mechanism; it is not open source.
