// Generated from base.pg. Edit base.pg and regenerate.
// Neo4j 5 schema: constraints and indexes. Cypher has no relationship schema, so the
// allowed relationships are listed as patterns at the end. Constraints marked
// (Enterprise) need Neo4j Enterprise Edition or Aura.

// ── Keys and unique properties ───────────────────────────────────────────
CREATE CONSTRAINT person_slug IF NOT EXISTS FOR (n:Person) REQUIRE n.slug IS UNIQUE;
CREATE CONSTRAINT person_email IF NOT EXISTS FOR (n:Person) REQUIRE n.email IS UNIQUE;
CREATE CONSTRAINT organization_slug IF NOT EXISTS FOR (n:Organization) REQUIRE n.slug IS UNIQUE;
CREATE CONSTRAINT organization_domain IF NOT EXISTS FOR (n:Organization) REQUIRE n.domain IS UNIQUE;
CREATE CONSTRAINT event_slug IF NOT EXISTS FOR (n:Event) REQUIRE n.slug IS UNIQUE;
CREATE CONSTRAINT document_slug IF NOT EXISTS FOR (n:Document) REQUIRE n.slug IS UNIQUE;
CREATE CONSTRAINT document_url IF NOT EXISTS FOR (n:Document) REQUIRE n.url IS UNIQUE;

// ── Required properties (Enterprise) ─────────────────────────────────────
CREATE CONSTRAINT person_slug_required IF NOT EXISTS FOR (n:Person) REQUIRE n.slug IS NOT NULL;
CREATE CONSTRAINT person_name_required IF NOT EXISTS FOR (n:Person) REQUIRE n.name IS NOT NULL;
CREATE CONSTRAINT organization_slug_required IF NOT EXISTS FOR (n:Organization) REQUIRE n.slug IS NOT NULL;
CREATE CONSTRAINT organization_name_required IF NOT EXISTS FOR (n:Organization) REQUIRE n.name IS NOT NULL;
CREATE CONSTRAINT event_slug_required IF NOT EXISTS FOR (n:Event) REQUIRE n.slug IS NOT NULL;
CREATE CONSTRAINT event_name_required IF NOT EXISTS FOR (n:Event) REQUIRE n.name IS NOT NULL;
CREATE CONSTRAINT event_starts_at_required IF NOT EXISTS FOR (n:Event) REQUIRE n.starts_at IS NOT NULL;
CREATE CONSTRAINT document_slug_required IF NOT EXISTS FOR (n:Document) REQUIRE n.slug IS NOT NULL;
CREATE CONSTRAINT document_title_required IF NOT EXISTS FOR (n:Document) REQUIRE n.title IS NOT NULL;
CREATE CONSTRAINT document_kind_required IF NOT EXISTS FOR (n:Document) REQUIRE n.kind IS NOT NULL;

// ── Property types (Enterprise, Neo4j 5.9+) ──────────────────────────────
CREATE CONSTRAINT event_starts_at_type IF NOT EXISTS FOR (n:Event) REQUIRE n.starts_at IS :: ZONED DATETIME;
CREATE CONSTRAINT event_ends_at_type IF NOT EXISTS FOR (n:Event) REQUIRE n.ends_at IS :: ZONED DATETIME;
CREATE CONSTRAINT document_created_at_type IF NOT EXISTS FOR (n:Document) REQUIRE n.created_at IS :: ZONED DATETIME;
CREATE CONSTRAINT member_of_since_type IF NOT EXISTS FOR ()-[r:MEMBER_OF]-() REQUIRE r.since IS :: DATE;

// ── Indexes ──────────────────────────────────────────────────────────────
CREATE INDEX event_starts_at IF NOT EXISTS FOR (n:Event) ON (n.starts_at);
CREATE INDEX document_title IF NOT EXISTS FOR (n:Document) ON (n.title);

// ── Relationships (not enforced by Neo4j) ────────────────────────────────
// (:Person)-[:MEMBER_OF {role, since}]->(:Organization)
// (:Organization)-[:PART_OF]->(:Organization)        at most one per organization
// (:Person)-[:ATTENDED]->(:Event)
// (:Event)-[:ORGANIZED_BY]->(:Organization)          at most one per event
// (:Person)-[:AUTHORED]->(:Document)
// (:Document)-[:DOCUMENT_ABOUT]->(:Event)
//
// Enum values, checked by the application:
//   Organization.kind: company, nonprofit, government, team, other
//   Document.kind: doc, page, file, thread, email, recording, other
