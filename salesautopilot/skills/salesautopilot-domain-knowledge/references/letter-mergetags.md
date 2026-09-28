# Merge tag reference for letter content

`create_letter`/`update_letter` write raw HTML/text into a letter. SalesAutopilot personalizes
that content at send time through **merge tags** — a fixed, product-defined syntax, not something
to improvise. This reference covers the tags that are safe to use when *writing letter content*
through MCP. It is separate from the "Merge tag syntax" note in SKILL.md, which covers a different,
narrower thing: referencing another list's field as a *value* inside an `update`-type Action's
`fields` parameter (`[mssys_firstname]` there is a tool-input convention, not letter content).

**Never invent a merge tag.** If a user asks for a personalization tag that isn't below (or you're
unsure of the exact parameters), say so plainly and point them to the SalesAutopilot knowledge base
article [Megszemélyesítésre használható mezőkódok](https://support.salesautopilot.com/hu/articles/14701516-megszemelyesitesre-hasznalhato-mezokodok)
(Hungarian) rather than writing a plausible-looking but non-existent tag such as `[FIRSTNAME]` or
`[UNSUB_LINK]` — those specific ones do not exist in the product.

## Subscriber field personalization

Any field that exists on the target list (the technical `field_name` from `list_list_fields`/
`get_list_field`, e.g. `mssys_firstname` — lowercase/digits/underscore, never the human-readable
label) can be inserted with square brackets:

```
Dear [mssys_firstname]!
```

Default value when the field is empty for a given subscriber: `[field_name/"default text"]`, e.g.
`Dear [mssys_firstname/"reader"]!`. Works in letter content, subject, and thank-you page text.

In a link's `href` (to pass a field value to an external URL), the syntax is different —
triple-slash, no brackets: `<a href="http://example.com?email=///email">`.

## Unsubscribe

Only valid inside letter **content** (and thank-you page text) — not in the subject line.

- Plain-text letter (or the text part of a multipart letter): `[/unsubscribe]` — replaced with a
  single unsubscribe link.
- HTML letter: opening/closing pair with free link text in between —
  `[unsubscribe]Click here to unsubscribe[/unsubscribe]`. The closing tag must stay in the same
  paragraph as the opening one.
- Hungarian-named alias with identical behavior: `[leiratkozas]...[/leiratkozas]` (and
  `[/leiratkozas]` for plain text).

## Open tracking

`[checkopen]` — HTML multipart letters only, a single self-closing tag (typically placed right
before `</body>`). No opening/closing pair.

## Link to a *different*, previously sent letter — `show_single_htmlletter_link`

Inserts the current recipient's personal link to the online/browser view of **another letter that
was already sent** — e.g. "see our previous newsletter." HTML letter content only.

```
[show_single_htmlletter_link[LIST_ID_LETTER_ID]]Link text[/show_single_htmlletter_link]
```

- `LIST_ID` — the `nl_id` of the list the referenced letter was **actually sent to** (from
  `list_lists`).
- `LETTER_ID` — the id of the referenced letter (from `list_letters`/`get_letter`), joined to
  `LIST_ID` with an underscore inside the same bracket pair, e.g.
  `[show_single_htmlletter_link[8637_1019795]]`.
- The closing tag is always exactly `[/show_single_htmlletter_link]`, with no ids.

**This only works if that exact `LETTER_ID` was already sent (excluding A/B-test variants) to that
exact `LIST_ID`** — if it wasn't, or was sent to a different list, the editor flags it as broken and
the link won't resolve at send time. If you can't confirm the referenced letter was actually sent to
that list, say so instead of guessing, or suggest the user check `list_sends`/campaign history
first.

## Links to the *current* letter (not a past one)

- `[show_archived_letter_link]link text[/show_archived_letter_link]` — the online/browser view of
  the letter this tag is placed in (not a different letter).
- `[show_letter_archive]link text[/show_letter_archive]` — a link to that subscriber's whole letter
  archive (every past letter sent to them), not one specific letter.

Both HTML-letter-content only.

## Article-of-the-noun helper

`[a(z)]` — placed before another merge tag when the correct Hungarian definite article ("a" vs
"az") depends on the substituted value; the product picks the right one automatically. Rarely
relevant outside Hungarian-language content.

## Blog notification letters only

These only make sense inside an automatic new-blog-post notification letter, not an arbitrary
newsletter: `[blog_title]`, `[blog_description]` (HTML), `[blog_description_text]` (plain text),
`[blog_link]Text[/blog_link]` (HTML link) / `[blog_link]` (plain-text, bare URL), and `///blog_link`
for use inside an `href` attribute.

## Everything else — don't guess

The product recognizes further tags (`[ordered_items_html]`, `[product_recommendation_...]`,
`[creatives]`, `[segmentcountN]`, `[dateformat(...)]`, form-embedding tags, payment/CRM-integration
tags, etc.) that are either integration-dependent (webshop, CRM, payment provider) or normally
inserted by the editor UI rather than typed by hand. If a request needs one of these, ask what the
user is trying to achieve and point them at the knowledge base / support rather than reproducing the
exact syntax from memory.
