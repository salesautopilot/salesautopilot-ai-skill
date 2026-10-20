# SalesAutopilot for Claude

Connects Claude to your [SalesAutopilot](https://www.salesautopilot.hu) account and teaches it how SalesAutopilot works, so you can plan, build and analyse your email, SMS and DM marketing in plain language — and ask Claude what you could get out of your account that you are not using yet.

## What's included

- **SalesAutopilot MCP connector** (`.mcp.json`) — a reference to SalesAutopilot's hosted remote MCP server at `https://mcp.salesautopilot.com/mcp`. Through it Claude can read and manage your lists, subscribers, letters, sends, forms, actions, segments, landing pages, products and campaign statistics. You sign in with your own SalesAutopilot account (OAuth) the first time a tool is used; Claude only ever reaches the account you authorised.
- **`salesautopilot-domain-knowledge` skill** — how SalesAutopilot's building blocks (lists, letters, forms, sends, actions, automations, segments, landing pages) fit together, which of them the MCP server can change and which only the SalesAutopilot interface can, letter merge tags, and deliverability rules.
- **`salesautopilot-feature-catalog` skill** — the full, official SalesAutopilot feature list with the subscription packages that include each feature, so Claude can recommend the next features to use based on what you already use and what your package allows. It is generated weekly from the public feature list on [salesautopilot.hu](https://www.salesautopilot.hu/funkciok-osszehasonlitasa).

## What it runs, sends and fetches

- The skills are Markdown instructions and reference text only. They contain no scripts, hooks or executable code, and send nothing anywhere.
- The only network connection the plugin defines is the remote MCP server above, operated by SalesAutopilot Kft. Data you ask Claude to read or change in your SalesAutopilot account goes through that server, under your own authorisation. Nothing is sent to any other destination.
- Data handling for the MCP connection: [privacy notice for the MCP integration (Hungarian)](https://support.salesautopilot.com/hu/articles/17027545-adatkezelesi-tajekoztato-mcp-integracio-ai-asszisztens-csatlakoztatasahoz).

## Requirements

A SalesAutopilot account. The MCP integration's availability depends on your SalesAutopilot package; see [MCP – AI assistant integration](https://support.salesautopilot.com/hu/articles/15434947-mcp-ai-asszisztens-integracio-a-salesautopilotban).

## Try it

- "How should I use SalesAutopilot to get the most out of my account?"
- "Is A/B testing included in my package?"
- "Show my five best campaigns of the last 30 days by open rate."
- "Set up a welcome email for new subscribers of my newsletter list."

## Support

Installation guide: [SalesAutopilot skill telepítése Claude-hoz és ChatGPT-hez](https://support.salesautopilot.com/hu/articles/17673064-salesautopilot-skill-telepitese-claude-hoz-es-chatgpt-hez). Questions: [support.salesautopilot.com](https://support.salesautopilot.com).
