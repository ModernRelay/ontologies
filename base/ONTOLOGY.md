---
name: base
description: Shared base types for Omnigraph apps. People, organizations, events and documents, so every app on one store means the same Person.
license: MIT
entities: [Person, Organization, Event, Document]
formats: [pg]
tags: [omnigraph, base, people, organizations, events, documents]
version: 0.1.0
---

# base

## What it models

The four types nearly every app mentions: who (Person, Organization), when (Event) and what was written down (Document). It's deliberately small. Apps built on Omnigraph install it first so their own types can point at the same Person and Organization, instead of each app keeping its own copy. Domain ontologies (CRM, tasks, meetings) add their types on top and link to these.

## Entities

- **Person**: one node per human, keyed by `slug`, with an optional unique `email` and a `title`.
- **Organization**: a company, nonprofit, government body or team (`kind`), keyed by `slug`, with an optional unique `domain`.
- **Event**: something that happens at a time: `starts_at` (indexed), `ends_at`, a free-text `location`.
- **Document**: content with an address: `kind` (doc, page, file, thread, email, recording), `title` (indexed), an optional unique `url`, `created_at`.

Person, Organization and Event share a `Named` interface (`name`).

## Relations

- Person → MemberOf → Organization [0..*], with `role` and `since`
- Organization → PartOf → Organization [0..1]
- Person → Attended → Event [0..*]
- Event → OrganizedBy → Organization [0..1]
- Person → Authored → Document [0..*]
- Document → DocumentAbout → Event [0..*]

```mermaid
flowchart LR
  classDef who fill:#e8f0fe,stroke:#4a6fd1,color:#1d1d1f
  classDef what fill:#fdf0e2,stroke:#d08a2b,color:#1d1d1f
  Person["<b>Person</b>"]:::who
  Organization["<b>Organization</b><br/><small>↻ part of</small>"]:::who
  Event["<b>Event</b>"]:::what
  Document["<b>Document</b>"]:::what
  Person -->|"member of (role, since)"| Organization
  Person -->|"attended"| Event
  Event -->|"organized by (0..1)"| Organization
  Person -->|"authored"| Document
  Document -->|"about"| Event
```

## Modeling decisions

- Readable `slug` keys (`ada-lovelace`, `acme`) instead of opaque ids, so agents can write links without a lookup first.
- A team is an Organization with `kind: team` and a `PartOf` edge to its company. One type covers the whole org chart.
- `location` on Event is free text. Promote it to a Place node (see `schemaorg-core`) only if places are shared and queried.
- No Document → Person "mentions" edge: Omnigraph edges have one target type, and mentions usually belong to a domain ontology with its own rules.

## How to integrate

- **Omnigraph**: copy `base.pg` into your schema first. Domain ontologies reference `Person`, `Organization`, `Event` and `Document` by name. Compile with `omnigraph init --schema base.pg <tmp>`, or plan with `omnigraph schema plan` on a live graph.
- **Other stores**: four tables (`people`, `organizations`, `events`, `documents`), plus join tables for MemberOf, Attended and Authored.
- **Overlaps**: Person ≈ schema:Person, foaf:Person, prov:Person. Organization ≈ schema:Organization, foaf:Organization. Event ≈ schema:Event. Document ≈ schema:CreativeWork, foaf:Document.
- If your project already has `User`, map it to Person and keep login details on User (or on an Actor type, as in `company-brain`).

## Files

- `base.pg`: the schema in Omnigraph's schema language; compiles on Omnigraph 0.14.
