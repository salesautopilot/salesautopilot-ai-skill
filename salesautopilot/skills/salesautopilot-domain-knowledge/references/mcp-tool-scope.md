# SalesAutopilot MCP server — verified tool scope

This is the authoritative, verified list of what the SalesAutopilot MCP server exposes (57 live tools, cross-checked against `mcp_server/tools.py` in the `mcp` repo — not the in-product AI Agent, which has a different, larger toolset). Grouped the same way the tools are documented; each group notes what's covered and, importantly, what's conspicuously *not* covered even though it exists as a product feature.

## Campaign & Stats (5)
`list_campaigns`, `get_campaign`, `search`, `fetch`, `echo_test`

Read-only. `search`/`fetch` exist specifically for ChatGPT's connector-discovery convention (same data as `get_campaign`/`list_campaigns`).

## Letters (4)
`list_letters`, `get_letter`, `create_letter`, `update_letter`

**No `delete_letter`** — the underlying capability exists in the codebase but is deliberately not exposed via MCP (irreversible). If a user wants a letter gone, tell them to do it in the UI.

## Folders — letter folders (3)
`list_folders`, `create_folder`, `update_folder`

**No `delete_folder`.**

## Sends / Timings (6)
`list_sends`, `create_send`, `get_send`, `update_send`, `send_test_emails`, `activate_send`

**No `delete_send`. No `deactivate_send`.** This second gap matters a lot: the in-product AI Agent has `deactivate_send` and is explicitly told "activation is NOT irreversible, you can always deactivate" — that's not true through MCP. Once a send is activated via this MCP server, there is no MCP-side way to stop it; only the SalesAutopilot UI can. This is exactly why `activate_send` carries `destructiveHint: true` and its tool description mandates asking the user for explicit confirmation before calling it — treat that requirement as load-bearing, not boilerplate.

## Lists (5)
`list_lists`, `list_list_fields`, `get_list_field`, `create_list_field`, `create_list`

`create_list` always creates in the default project folder (`pf_id=0`); no tool moves a list between project folders.

## Subscribers (5)
`list_subscribers`, `add_subscriber`, `get_subscriber`, `update_subscriber`, `send_letter_to_subscriber`

**No `delete_subscriber`.** `send_letter_to_subscriber` fires an immediate, real send to one subscriber, bypassing the send's own schedule/active-state — irreversible in effect (a real email goes out), hence its own confirmation requirement.

## Forms (7)
`list_forms`, `create_form`, `update_form`, `get_form`, `get_form_fields`, `add_form_fields`, `delete_form_field`

`delete_form_field` only removes a field from a form's *layout* — it does not delete the underlying list field or any subscriber data already collected. The only downstream effect is that future submissions through that form won't collect that field's value until it's re-added.

## Actions (4)
`create_action`, `list_actions`, `get_action`, `update_action`

Actions only — see the SKILL.md section on Action vs. Automation. **No `delete_action`** (no archive path for Actions either, unlike Segments) — the only way to remove one is through the UI.

## Segments (7)
`list_segment_groups`, `list_segments`, `get_segment`, `create_segment`, `update_segment`, `archive_segment`, `copy_segment`

**No `delete_segment`** — `archive_segment` (a reversible soft-delete) is the closest available operation, and is the one to reach for when a user asks to "delete" a segment.

## Invoices (2)
`list_invoices`, `get_invoice`

Read-only, billing history for the account's own subscription to SalesAutopilot (not customer/end-buyer invoices from an order form).

## Shipping methods (1)
`list_shipping_methods`

Read-only, needed to resolve IDs for `create_form`'s `shipping_method_ids` on order forms.

## Landing pages (6)
`list_landing_pages`, `get_landing_page`, `create_landing_page`, `update_landing_page`, `list_landing_page_folders`, `create_landing_page_folder`

No delete tool for landing pages or landing page folders either.

## Feedback (2)
`request_feedback`, `submit_feedback`

Meta tools for the AI session's own feedback loop, not a SalesAutopilot product feature — call `request_feedback` once after finishing a task, and `submit_feedback` only if the user gives feedback in free text rather than clicking a UI card.

## Not reachable through MCP at all

These are real SalesAutopilot capabilities with zero MCP tool coverage — say so plainly if asked, rather than attempting a workaround that only approximates the feature:

- **The Automation Builder** (multi-step chained workflows, including creating from a template) — see SKILL.md.
- **Dashboard widgets.**
- **Global variables.**
- **Product catalog management / webshop sync** (creating products, syncing a connected webshop's catalog).
- **CRM messages, tasks, and events.**
- **Moving an existing list to a different project folder.**
- Deleting: letters, letter folders, sends, subscribers, actions, segments (permanently — archiving is the closest available operation for segments only), lists.
