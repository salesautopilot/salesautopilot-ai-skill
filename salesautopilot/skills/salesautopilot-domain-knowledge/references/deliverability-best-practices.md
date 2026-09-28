# Deliverability / spam-avoidance minimums

These are SalesAutopilot's own documented minimum requirements for a legitimately opt-in-based
send to reliably reach the inbox instead of spam/promotions. Apply or suggest these whenever
writing **real, send-ready** letter content through `create_letter`/`update_letter` — not for a
throwaway draft the user is still iterating on. Full source:
[Minimális követelmények SalesAutopilotos email küldéshez](https://support.salesautopilot.com/hu/articles/14701371-minimalis-kovetelmenyek-salesautopilotos-email-kuldeshez)
(Hungarian).

## 1. Never send to a purchased or long-unused list

Sending to a purchased list (data brokers, "harvested" addresses) or a list nobody has emailed in
roughly 6+ months (or not within ~2 months of signup) violates SalesAutopilot's own Terms of
Service and anti-spam policy — regardless of what local law would otherwise permit. If a user
describes the target list this way, don't help configure the send; tell them plainly this isn't
allowed and that the list needs cleaning up (or removal of those contacts) first. There's no MCP
tool to check "when was this list last emailed," so rely on what the user tells you rather than
assuming a list is fine.

## 2. Always include an unsubscribe option

See `references/letter-mergetags.md` for the exact tag syntax (`[unsubscribe]`/`[leiratkozas]`).
Recommended prominently, ideally near the top as well as the footer — a visible unsubscribe link
reduces the chance of being marked as spam instead. Default to including it in letter content you
write unless the user explicitly asks you not to.

## 3. Identify the sender in the footer

Company/brand name plus contact info (address, phone), so the recipient clearly sees who sent it.

## 4. Include a "why you're receiving this" line

E.g. "You're receiving this because you subscribed with [email] on [subdate] on our newsletter at
...". Use the list's actual subscription-date field's technical name (from `list_list_fields`,
typically `subdate`) rather than guessing one.

## 5. Send only from a domain you own

Free-mail addresses (Gmail etc.) can't have SPF/DKIM set up, and SalesAutopilot has disallowed
sending newsletters from a Gmail-type sender address since February 2024. If a user wants a
free-mail sender, tell them it isn't possible and point them toward getting their own domain
address instead.

## 6. SPF, DKIM, and DMARC records

These are DNS-level, **account-level** setup, not something `create_letter`/`update_letter` content
touches — there's no MCP tool for this. If asked, point to SalesAutopilot's own guide rather than
attempting to talk someone through DNS configuration yourself.

## 7. Use your own tracking subdomain for links

So the links in the email resolve on the same domain as the sender address, which lowers phishing
suspicion in spam filters. Practically: if a verified tracking subdomain exists for the account,
set `create_letter`/`update_letter`'s `linkTrackingDomain`-equivalent field to it instead of leaving
the default tracking domain. **Caveat**: this MCP server does not expose a tool to list an account's
verified tracking domains (unlike the in-product AI Agent's `list_tracking_domains`) — if you don't
already know the account's own tracking domain, ask the user for it rather than guessing or
inventing one.

## 8. Test in a spam checker before sending

SalesAutopilot recommends mail-tester.com. This is a manual, external step the user does themselves
(paste a generated test address into the "send test" flow, then check the score) — there's no MCP
tool for it; just mention it as a recommended step, don't attempt to fake or simulate a score.

## +1. Use double opt-in signup

Reduces both "someone else subscribed me" abuse and bot signups. `create_form` can create a signup
form, but enabling double opt-in as a *process* (confirmation email, template, etc.) is UI-driven
setup beyond a single tool call — mention it as a recommendation rather than assuming you can wire
the whole flow through the MCP tools available.
