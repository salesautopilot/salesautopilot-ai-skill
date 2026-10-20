---
name: salesautopilot-feature-catalog
description: The full, official SalesAutopilot feature list (the same one shown on salesautopilot.hu/arak and /funkciok-osszehasonlitasa) with which subscription package includes each feature. Use this whenever a user asks what SalesAutopilot can do, what they are not using yet, how to get more out of their account, which package includes a feature or whether they need to upgrade, or wants ideas for what to build next — e.g. "how should I use SalesAutopilot to get the most out of my account?", "can SalesAutopilot do X?", "what else could I automate?", "is A/B testing in my package?". Hungarian phrasings (HU) — mire és hogyan használjam a SAPI-t, kihasználni a fiókom, milyen funkciók vannak, benne van-e a csomagomban, mit tud még a SalesAutopilot, csomagváltás.
---

# SalesAutopilot Feature Catalog

## Where to read the catalog

**Prefer the `get_feature_catalog` tool of the SalesAutopilot MCP server whenever it is connected.** It serves the same list, always current (the bundled file below is only a snapshot from when this skill was installed), and filters it so you don't have to load the whole file:

- No arguments → package codes, the "Áttekintés" overview and the list of feature groups (~4 KB). Start here.
- `group` (part of a `## ` heading, accents optional, e.g. `"webshop"`), `package` (`ING`/`EM`/`AUT`/`ECO`/`FULL`) and/or `query` (words that must all occur in a feature's name or description) → the matching features with description and link.

Fall back to `references/feature-catalog.md` only when the MCP server isn't connected (or the tool fails), and then say the list may be slightly out of date.

## What the catalog contains

`references/feature-catalog.md` is the complete public feature list of SalesAutopilot, generated from the website's CMS. It is in Hungarian, grouped into ~23 feature groups (`## ` headings), and every feature carries:

- **Csomag** — the packages that include it (`ING` Ingyenes, `EM` Email Marketing, `AUT` Automatizálás, `ECO` Ecommerce, `FULL` Mindent Bele), plus per-package notes such as a trial period, an API-call quota or an extra fee.
- A short marketing description of what it does and why it's useful.
- Sometimes a **Bővebben** link to a longer article on salesautopilot.hu.

The file is large (~85 KB). Start with the "Áttekintés" table at the top and the list of `## ` headings, then read only the groups relevant to the user's business instead of loading everything — with the MCP tool, call it once without arguments, then with `group` for the relevant groups.

## "How do I get the most out of my account?"

Answer with a short, prioritized, personal plan — not a dump of the catalog. A useful answer needs three inputs:

1. **The user's business and goal.** Ask in one question if it isn't clear: what they sell (webshop, services, courses/events, B2B), and what they want more of (leads, sales, retention, less manual work). This decides which feature groups matter — e.g. a webshop → "Webshop marketingautomatizálás" and "Marketingautomatizálás használati esetek"; an event organizer → "Rendezvények hatékony lebonyolítása"; a consultancy → "Árajánlat készítés" and "Ügyféladatbázis (CRM)".
2. **Their package.** Ask which package they have, or infer it from `list_invoices` if the SalesAutopilot MCP server is connected. Only recommend features their package includes; when the best next step needs a higher package, say so explicitly as an upgrade option rather than presenting it as available.
3. **What they already use.** If the SalesAutopilot MCP server is connected, take a quick read-only inventory: `list_lists`, `list_forms`, `list_sends`, `list_letters`, `list_segments`, `list_actions`, `list_landing_pages`, `list_products`, `list_campaigns`. Gaps are the opportunities: no segments → segmentation; sends but no actions → engagement-based follow-ups; an order list without upsell products → order bumps/upsells; no landing pages → landing pages; and so on. Without MCP, ask the user what they use today.

Then recommend **3–5 concrete next steps**, highest impact first. For each: the feature (name as in the catalog), why it fits *their* situation, and how to set it up in a few steps. Offer to build the ones that can be done through the MCP server.

## Before promising or building anything

- Read the **salesautopilot-domain-knowledge** skill for how lists, letters, forms, sends, actions, automations and segments fit together — the catalog says *what* exists, that skill says *how* to build it.
- Check that skill's `references/mcp-tool-scope.md` before offering to do something yourself: many catalog features (the Automation Builder, CRM, affiliate, dashboards, integrations, membership) are UI-only. For those, give the user clear steps to follow in the SalesAutopilot interface.
- The catalog is marketing copy. Don't quote prices, quotas or limits beyond what it states, and point the user to support (or the linked article) for details.
- Reply in the user's language; translate feature names when answering in English, but keep the Hungarian name in parentheses so the user can find it in the UI.
