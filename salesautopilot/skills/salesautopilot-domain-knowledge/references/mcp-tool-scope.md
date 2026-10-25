# SalesAutopilot MCP server — verified tool scope

This is the authoritative, verified list of what the SalesAutopilot MCP server exposes (87 live tools, cross-checked against `mcp_server/tools.py` in the `mcp` repo — not the in-product AI Agent, which has a different, larger toolset). Grouped the same way the tools are documented; each group notes what's covered and, importantly, what's conspicuously *not* covered even though it exists as a product feature.

## Campaign & Stats (5)
`list_campaigns`, `get_campaign`, `search`, `fetch`, `echo_test`

Read-only. `search`/`fetch` exist specifically for ChatGPT's connector-discovery convention (same data as `get_campaign`/`list_campaigns`).

## Letters (5)
`list_letters`, `get_letter`, `create_letter`, `update_letter`, `list_tracking_domains`

**No `delete_letter`** — the underlying capability exists in the codebase but is deliberately not exposed via MCP (irreversible). If a user wants a letter gone, tell them to do it in the UI.

`list_tracking_domains` is read-only: it returns the account's verified custom link-tracking domains plus the default domain `track.t.emesz.com`; pass one of the returned `domain` values as `link_tracking_domain` to `create_letter`/`update_letter` when link tracking is enabled.

## Folders — project folders and letter folders (4)
`list_folders`, `list_project_folders`, `create_folder`, `update_folder`

`list_project_folders` (optionally filtered by name) returns the top-level project folders; use its IDs as `project_folder_id` in `create_list`. `list_folders`/`create_folder`/`update_folder` are about *letter* folders inside a project folder. There is no tool to create or edit project folders themselves.

**No `delete_folder`.**

## Sends / Timings (7)
`list_sends`, `create_send`, `get_send`, `update_send`, `send_test_emails`, `activate_send`, `copy_send_targeting`

`copy_send_targeting` copies the custom conditions and/or the segment filter of one send onto another send of the same list, overwriting the target's own — `get_send`/`update_send` alone cannot do this (they expose no conditions and drop segment negation).

**No `delete_send`. No `deactivate_send`.** This second gap matters a lot: the in-product AI Agent has `deactivate_send` and is explicitly told "activation is NOT irreversible, you can always deactivate" — that's not true through MCP. Once a send is activated via this MCP server, there is no MCP-side way to stop it; only the SalesAutopilot UI can. This is exactly why `activate_send`'s tool description opens with "IRREVERSIBLE" and mandates asking the user for explicit confirmation (with a fixed confirmation sentence) before calling it. Its annotations are `destructiveHint: false` (activation adds a send, it doesn't delete or overwrite data) and `openWorldHint: true` (it emails real recipients), so the client's own destructive-action prompt may not fire — the description's confirmation rule is the safeguard — treat that requirement as load-bearing, not boilerplate.

## Lists (7)
`list_lists`, `list_list_fields`, `get_list_field`, `create_list_field`, `create_list`, `get_list_integrations`, `copy_openai_integration`

`get_list_integrations` only tells whether a list has its OpenAI integration (API key) set up and links the list's integrations screen — it never returns a key. Integration credentials themselves are entered only in the SalesAutopilot UI, never through MCP or the chat; `copy_openai_integration` copies an existing OpenAI key from another list of the account server side (ask the user to confirm first).

`create_list` takes a `project_folder_id` (0 = default folder); no tool moves a list between project folders. For ORDER lists it can copy the integration settings of another order list (`copy_integrations_from_list_id`).

## Subscribers (5)
`list_subscribers`, `add_subscriber`, `get_subscriber`, `update_subscriber`, `send_letter_to_subscriber`

**No `delete_subscriber`.** `send_letter_to_subscriber` fires an immediate, real send to one subscriber, bypassing the send's own schedule/active-state — irreversible in effect (a real email goes out), hence its own confirmation requirement.

## Forms (8)
`list_forms`, `list_form_templates`, `create_form`, `update_form`, `get_form`, `get_form_fields`, `add_form_fields`, `delete_form_field`

`list_form_templates` resolves a template the user names ("my Black Friday template") to the `template_id` that `create_form`/`update_form` take; filter with `search` (name fragment) or `category` (`own`, `modern`, `multi-block`, `legacy`), and ask the user when several match. The same ID is shown on every template card in the app, so users may also give it directly. `get_form` returns the form's `templateId`, so an existing form's design can be reused.

`delete_form_field` only removes a field from a form's *layout* — it does not delete the underlying list field or any subscriber data already collected. The only downstream effect is that future submissions through that form won't collect that field's value until it's re-added.

## Actions (14)
`create_action_subscribe`, `create_action_unsubscribe`, `create_action_update`, `create_action_external`, `create_action_delete`, `create_action_ai_prompt`, `update_action_subscribe`, `update_action_unsubscribe`, `update_action_update`, `update_action_external`, `update_action_delete`, `update_action_ai_prompt`, `list_actions`, `get_action`

AI Prompt actions (`create_action_ai_prompt` / `update_action_ai_prompt`) are buildable through MCP; the one part that stays in the UI is entering the OpenAI API key on the source list's integrations screen (see SKILL.md, "AI Prompt actions"). The other action types of the editor screen (tasks, tickets, recurring-payment and ElevenLabs actions) are still UI-only.

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

## Products (13)
`list_products`, `get_product`, `create_product`, `update_product`, `list_product_categories`, `create_product_category`, `update_product_category`, `list_tax_classes`, `create_tax_class`, `update_tax_class`, `list_tax_rates`, `create_tax_rate`, `update_tax_rate`

No delete tool for products, categories, tax classes or tax rates. Per-country VAT workflow: `create_tax_class` -> `create_tax_rate` (first rate becomes the default) -> `create_product(vat_type='tax_class')`; a tax class needs at least one rate and a default rate. `update_product` returns `labelReviewForms` (forms whose label was not renamed) to review with the user.

## Feature catalog (1)
`get_feature_catalog`

Read-only, account-independent: the official feature list from salesautopilot.hu with package availability, optionally filtered by `group`, `package` or `query`. It is the always-current source behind the salesautopilot-feature-catalog skill — prefer it over the skill's bundled snapshot. It says what the product offers, not what this MCP server can do; this file remains the reference for that.

## Feedback (2)
`request_feedback`, `submit_feedback`

Meta tools for the AI session's own feedback loop, not a SalesAutopilot product feature — call `request_feedback` once after finishing a task, and `submit_feedback` only if the user gives feedback in free text rather than clicking a UI card.

## Not reachable through MCP at all

These are real SalesAutopilot capabilities with zero MCP tool coverage — say so plainly if asked, rather than attempting a workaround that only approximates the feature:

- **The Automation Builder** (multi-step chained workflows, including creating from a template) — see SKILL.md.
- **Dashboard widgets.**
- **Global variables.**
- **Webshop catalog sync** (syncing a connected webshop's catalog). Products themselves, product categories, tax classes and tax rates ARE manageable through MCP — see "Products" above.
- **CRM messages, tasks, and events.**
- **Moving an existing list to a different project folder.**
- Deleting: letters, letter folders, sends, subscribers, actions, segments (permanently — archiving is the closest available operation for segments only), lists.
