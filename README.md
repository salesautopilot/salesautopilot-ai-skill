# SalesAutopilot Plugin

A self-hosted Claude Code plugin marketplace for SalesAutopilot. Bundles:

- A reference to the live SalesAutopilot MCP server (`https://mcp.salesautopilot.com/mcp`) — the same server available as a standalone connector in the Claude Connectors Directory.
- The `salesautopilot-domain-knowledge` skill, which teaches Claude the product's domain model (lists, letters, forms, sends, actions, segments) and the exact scope of what the MCP server can and cannot do.

## Install (Claude Code)

```
/plugin marketplace add salesautopilot/-salesautopilot-ai-skill
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
```

## License

Proprietary — © SalesAutopilot. This repository is published so the plugin can be installed via Claude Code's self-hosted marketplace mechanism; it is not open source.
