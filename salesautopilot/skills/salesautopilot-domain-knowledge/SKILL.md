---
name: salesautopilot-domain-knowledge
description: Explains how SalesAutopilot's core building blocks (subscriber lists, letters, forms, sends/timings, actions, automations, segments, landing pages) relate to each other, and which of them the SalesAutopilot MCP server can actually touch. Use this whenever a request involves SalesAutopilot planning or troubleshooting — setting up a list, letter, form, send, segment, action, automation, or landing page; asking how these pieces fit together; or a result that looks wrong because of a mixed-up concept (e.g. "Action" vs "Automation", "why can't I delete this", "why didn't my email go out") — even when the user doesn't name a specific tool or use the word "SalesAutopilot" explicitly (e.g. "set up a welcome email sequence for new signups", "why is this automated email still sending after I stopped it").
---

# SalesAutopilot Domain Knowledge

SalesAutopilot is an email/SMS/DM marketing automation platform. Its data model has a small number of building blocks that combine in consistent, predictable ways — most confusion comes from conflating two similarly-named concepts (Action vs. Automation) or assuming a capability exists through MCP when it's only available in the SalesAutopilot UI. This skill exists to prevent both kinds of mistakes.

**Read this skill fully before making multi-step plans involving SalesAutopilot** (e.g. "set up an onboarding sequence") — the building blocks below determine what order things need to happen in, and the MCP-scope notes determine what you can actually do versus what you need to tell the user to do themselves.

## The building blocks

| Block (HU term) | What it is |
|---|---|
| **List** (*Lista*) | Where subscribers live. Every send targets exactly one list. Keep separate lists for separate communication purposes (e.g. one per lead magnet, one per order flow) rather than cramming everything into one. |
| **Letter** (*Levél*) | The content to be sent — Email, SMS, or DM (a PDF letter). A letter is reusable across multiple sends. |
| **Form** (*Űrlap*) | The entry point subscribers/orders come in through, and also how existing subscribers update their own data. Always belongs to exactly one list. Three kinds: signup, data-update, order. Data-update forms only work when opened in a context already tied to a specific subscriber — see "Data-update forms" below. |
| **Send / Timing** (*Időzítés*) | Configuration that says which list, which letter, what filter (optional), and when. See "Send types" below — "when" varies a lot. |
| **Landing page** | Tied to one list. Can show that list's subscriber data back to them via a personalized link, or work as a plain standalone page (e.g. with an embedded signup form). |
| **Action** (*Művelet*) | A single triggered step: on letter open/click, or on form submission (or personal landing-page-link click), do ONE of 5 things — see "Action types" below. **Not the same as Automation — see next section.** |
| **Automation** (*Automatizmus*, Visual Automation Builder) | A multi-step chained process (Email → Wait → SMS → Event → ... ) triggered by a form submission or a date field. Built from templates or from scratch in a dedicated visual editor. **Not reachable through the SalesAutopilot MCP server at all — see MCP scope below.** |
| **Segment** | A saved filter on a list's subscribers (by field values, engagement, or — for order-type lists — purchase history). Used to scope a send or a segment-conditioned Action. |

## The most common confusion: Action vs. Automation

These are two unrelated features that happen to sound alike in English (and in Hungarian, "Művelet" vs. "Automatizmus" are more clearly distinct, which is part of why English-speaking users mix them up more):

- **Action** = one single step, configured directly on a letter or a form, no visual builder, no multi-step sequencing.
- **Automation** = a whole chained, multi-step visual workflow, built in a separate part of the product.

If a user asks for "an automated welcome sequence" or "a chain of emails after signup," they mean **Automation**, not Action — and **the MCP server cannot build, edit, or trigger Automations at all**. It can only create/read/update **Actions**, which is a single step, not a sequence. Don't try to fake a multi-step sequence by chaining several Actions together — that's not how Actions work, and users need to be told this rather than shown a workaround that doesn't actually reproduce Automation behavior. Tell them plainly that the Automation Builder is UI-only for now, and — if it fits their case — that several ready-made templates exist there (welcome series, cart abandonment, event reminders, double opt-in, etc.), which they'd need to activate themselves in the product.

The one thing Actions and multi-step sequencing *can* jointly achieve through MCP: a `SUBSCRIPTION`- or `DATA_UPDATE`-type **Send** already behaves like a trigger (see Send types below), so "send this letter when someone joins this list" is directly buildable with `create_send`, no Action needed. What you *cannot* build through MCP is a chain of several timed steps after that trigger — that's genuinely Automation-only territory.

## Action types

An Action (`create_action`/`update_action`) does exactly one of five things, set via `action_type`:

| Type | What it does | Extra required fields |
|---|---|---|
| `subscribe` | Adds the contact to `target_list_id` | — |
| `unsubscribe` | Unsubscribes the contact from `target_list_id` (status change — the record stays, marked inactive on that list) | — |
| `update` | Sets field values on the contact | `fields` (JSON) |
| `external` | Calls a webhook at a caller-supplied URL — the only type that does *not* need `target_list_id` | `external_url` (optionally `external_username`/`external_password` for HTTP Basic Auth to that endpoint) |
| `delete` | Removes the contact from `target_list_id` (record-level removal, not just a status change — distinct from `unsubscribe`) | — |

Two more things every Action needs regardless of type:
- **Trigger**: for a letter-attached Action, `letter_trigger` is required — `on_open`, `on_any_click`, or `on_link_click` (the last one also needs `link_urls`, specific URLs from that letter). A form-attached Action triggers on submission instead, no separate trigger field.
- **`source_list_id`** (optional): which list the Action reads the contact's data *from* — omit/`0` for automatic, or fix it to a specific list.

`subscribe`/`update`/`external` are safe, additive configuration. `unsubscribe` and `delete` configure something that will remove or unsubscribe a contact automatically, later, whenever the trigger fires — with no further confirmation at that moment. Since one Action can only be one type and a user might ask to change it later, don't assume a `create_action`/`update_action` call is automatically low-risk just because it "just sets something up" — check which `action_type` is actually being configured.

## Structural hierarchy — project folders

The top-level organizing unit is the **project folder** (`pf_id`, default `0`). Lists, letters, and landing pages all belong to a project folder — directly, not through some other container:

- **Lists** belong directly to a project folder. There is no separate "list folder" concept — a list *is* a direct member of its project folder.
- **Letters** belong directly to a project folder, and can *additionally* sit in an optional **letter folder** within that project folder.
- **Landing pages** belong to a project folder *through their parent list* (a landing page has no `pf_id` of its own — it inherits its list's), and can *additionally* sit in an optional **landing page folder**.

So: `project folder → (list | letter | landing page)`, with `letter → optional letter folder` and `landing page → optional landing page folder`, but never `list → subfolder`. Don't describe lists as "not organized into project folders" — every list has one, it just has no further subdivision beneath it.

**MCP limitation**: `create_list` always creates the new list in the default (`pf_id=0`) project folder, and there's no MCP tool to move an existing list to a different project folder. If a user wants a list in a specific non-default project folder, say so plainly — they'll need to move it themselves in the UI afterward.

## Send types

| Type | Fires when | Required fields |
|---|---|---|
| `ABSOLUTE` | Fixed date/time | `sendAtDateTime` |
| `SMART_SEND` | Optimized send time within a chosen day | `sendAtDate` |
| `RELATIVE_AFTER_DATE` | N days/hours after a subscriber's date field | `referenceField`, `relativeDays` |
| `RELATIVE_AFTER_MINUTES` | N hours/minutes after a subscriber's date field | `referenceField`, `relativeHoursNumber` |
| `SUBSCRIPTION` | Immediately when someone subscribes via a given form | `formId` |
| `DATA_UPDATE` | Immediately when a subscriber's data is updated via a given form | `formId` |

`SUBSCRIPTION`/`DATA_UPDATE` sends are the event-triggered kind — this is the mechanism for "email someone right after they sign up," achievable directly with `create_send`, no Action or Automation required.

## New accounts already have a starting list

Every newly registered SalesAutopilot account automatically gets one default subscriber list, already containing one subscriber: the person who registered, with their own name and email. **This list has no form attached to it yet.** Don't suggest "first, create a list" as a first step for a brand-new account — it already has one. The actual first gap is usually a form to attach to it.

## Data-update forms only work in a subscriber-specific context

A data-update form (`method="update"`) cannot simply be opened generically the way a signup form can — it has to be opened from somewhere that already knows *which* subscriber is updating their data. Opening the bare form URL anonymously doesn't work. Valid entry points are:

- the subscriber's own record/profile screen in the SalesAutopilot UI,
- a link inside an email actually sent to that subscriber (a merge-tagged link, not a generic one pasted elsewhere),
- a personalized landing page link generated for that subscriber,
- a form's thank-you page shown right after that subscriber submitted another form.

If a user wants to "let people update their own data," don't just hand them the form's bare URL the way you would for a signup form — walk them toward one of the above (most commonly: link to it from an email send, so the merge-tagged personal link resolves correctly), or they'll get a form that doesn't know whose data to update.

## Segments: check for groups before creating one

Before calling `create_segment`, always call `list_segment_groups` first:
- No groups exist → proceed without a `segment_group_id`.
- Groups exist → ask the user which group the new segment belongs to, don't guess.

Segment filter conditions have a fairly rich operator syntax (per field type: VARCHAR, INTEGER, DATETIME absolute/relative, options, checkbox) — the full reference with exact operator strings and examples is embedded directly in the `create_segment`/`update_segment` MCP tool descriptions themselves; read those at call time rather than guessing an operator name.

For order-based segmentation (e.g. "customers who bought product X," "spent over Y total") — this is a real, existing capability (`conditions` with `type: 1` in `create_segment`), but the exact technical field names for these purchase-history relations (ordered/not-ordered, paid/not-paid, order count thresholds, total-spend thresholds, last-order-date) are not reliably documented anywhere accessible to this skill. **Don't invent a field name for these** — tell the user this specific configuration needs to be done carefully (ideally checked against the segment editor's own UI, which has the authoritative field list), rather than guessing and silently producing a segment that doesn't filter what they think it filters.

## Order forms (e-commerce)

A product must exist in the account's product catalog before it can be used on an order form — there's no MCP tool to create products or sync a webshop catalog; that happens in the UI (automatic for Unas/Shoprenter integrations, manual otherwise).

`create_form` with `method="order"` requires: `shipping_method_ids` (call `list_shipping_methods` first if unknown), `order_type` (1=fixed single product, 2=selector, 3=quantity-based, 4=recurring subscription), and `products` (each needs `productId` or `sku`).

## Merge tag syntax

When an Action's `update` type needs to copy a value from one list's field into another (rather than a literal value), the field reference uses **square brackets**: `[mssys_firstname]` — not `{mssys_firstname}`.

This is a different, narrower thing than the merge tags used *inside letter content* written through `create_letter`/`update_letter` (subscriber field personalization, unsubscribe links, a link to a previously sent letter, open tracking, etc.). Read `references/letter-mergetags.md` before writing or editing letter HTML/text content — don't improvise a personalization tag from a plausible-looking guess (e.g. `[FIRSTNAME]`, `[UNSUB_LINK]` are not real tags).

## Deliverability best practices

SalesAutopilot documents a specific set of minimum requirements to keep a legitimate, opt-in send
out of spam/promotions folders (unsubscribe link, sender identification, own domain, SPF/DKIM/DMARC,
own tracking subdomain, never sending to a purchased or long-unused list, testing with a spam
checker, double opt-in). Read `references/deliverability-best-practices.md` and apply or suggest
these whenever writing real, send-ready letter content through `create_letter`/`update_letter` — not
for a throwaway draft the user is still iterating on.

## MCP scope — what's actually reachable

The building blocks above are true regardless of interface, but **the SalesAutopilot MCP server (what Claude/ChatGPT actually call) exposes only a subset** of what SalesAutopilot as a product can do. Read `references/mcp-tool-scope.md` for the full, verified list of what each of the 57 MCP tools covers and — just as importantly — the specific things that look like they should exist but don't (e.g. there is no `delete_letter`, no `delete_send`, and critically **no `deactivate_send`** — once a send is activated through MCP there is no MCP-side undo, only the UI has one, which is exactly why `activate_send` is documented as needing explicit user confirmation before calling it).

Don't assume parity with any other SalesAutopilot AI surface (e.g. the in-product assistant) — it has a materially larger toolset (automation templates, dashboard widgets, letter folders, global variables, a `deactivate_send` undo path) that the MCP server does not have. When in doubt about whether something is possible through MCP specifically, check the reference file rather than assuming.
