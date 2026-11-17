// Generated from schema.pg. Edit schema.pg and regenerate.
// Neo4j 5 schema: constraints and indexes. Cypher has no relationship schema, so the
// allowed relationships are listed as patterns at the end. Constraints marked
// (Enterprise) need Neo4j Enterprise Edition or Aura. Edge cardinality (@card) and
// enum values are checked by the application.

// ── Keys and unique properties ───────────────────────────────────────────
CREATE CONSTRAINT person_slug IF NOT EXISTS FOR (n:Person) REQUIRE n.slug IS UNIQUE;
CREATE CONSTRAINT person_email IF NOT EXISTS FOR (n:Person) REQUIRE n.email IS UNIQUE;
CREATE CONSTRAINT person_slack IF NOT EXISTS FOR (n:Person) REQUIRE n.slack IS UNIQUE;
CREATE CONSTRAINT person_github IF NOT EXISTS FOR (n:Person) REQUIRE n.github IS UNIQUE;
CREATE CONSTRAINT actor_slug IF NOT EXISTS FOR (n:Actor) REQUIRE n.slug IS UNIQUE;
CREATE CONSTRAINT team_slug IF NOT EXISTS FOR (n:Team) REQUIRE n.slug IS UNIQUE;
CREATE CONSTRAINT project_slug IF NOT EXISTS FOR (n:Project) REQUIRE n.slug IS UNIQUE;
CREATE CONSTRAINT source_slug IF NOT EXISTS FOR (n:Source) REQUIRE n.slug IS UNIQUE;
CREATE CONSTRAINT claim_slug IF NOT EXISTS FOR (n:Claim) REQUIRE n.slug IS UNIQUE;
CREATE CONSTRAINT decision_slug IF NOT EXISTS FOR (n:Decision) REQUIRE n.slug IS UNIQUE;
CREATE CONSTRAINT action_item_slug IF NOT EXISTS FOR (n:ActionItem) REQUIRE n.slug IS UNIQUE;

// ── Required properties (Enterprise) ─────────────────────────────────────
CREATE CONSTRAINT person_slug_required IF NOT EXISTS FOR (n:Person) REQUIRE n.slug IS NOT NULL;
CREATE CONSTRAINT person_name_required IF NOT EXISTS FOR (n:Person) REQUIRE n.name IS NOT NULL;
CREATE CONSTRAINT actor_slug_required IF NOT EXISTS FOR (n:Actor) REQUIRE n.slug IS NOT NULL;
CREATE CONSTRAINT actor_kind_required IF NOT EXISTS FOR (n:Actor) REQUIRE n.kind IS NOT NULL;
CREATE CONSTRAINT actor_name_required IF NOT EXISTS FOR (n:Actor) REQUIRE n.name IS NOT NULL;
CREATE CONSTRAINT team_slug_required IF NOT EXISTS FOR (n:Team) REQUIRE n.slug IS NOT NULL;
CREATE CONSTRAINT team_name_required IF NOT EXISTS FOR (n:Team) REQUIRE n.name IS NOT NULL;
CREATE CONSTRAINT project_slug_required IF NOT EXISTS FOR (n:Project) REQUIRE n.slug IS NOT NULL;
CREATE CONSTRAINT project_name_required IF NOT EXISTS FOR (n:Project) REQUIRE n.name IS NOT NULL;
CREATE CONSTRAINT project_status_required IF NOT EXISTS FOR (n:Project) REQUIRE n.status IS NOT NULL;
CREATE CONSTRAINT source_slug_required IF NOT EXISTS FOR (n:Source) REQUIRE n.slug IS NOT NULL;
CREATE CONSTRAINT source_kind_required IF NOT EXISTS FOR (n:Source) REQUIRE n.kind IS NOT NULL;
CREATE CONSTRAINT source_title_required IF NOT EXISTS FOR (n:Source) REQUIRE n.title IS NOT NULL;
CREATE CONSTRAINT source_occurred_at_required IF NOT EXISTS FOR (n:Source) REQUIRE n.occurred_at IS NOT NULL;
CREATE CONSTRAINT claim_slug_required IF NOT EXISTS FOR (n:Claim) REQUIRE n.slug IS NOT NULL;
CREATE CONSTRAINT claim_statement_required IF NOT EXISTS FOR (n:Claim) REQUIRE n.statement IS NOT NULL;
CREATE CONSTRAINT claim_quote_required IF NOT EXISTS FOR (n:Claim) REQUIRE n.quote IS NOT NULL;
CREATE CONSTRAINT claim_kind_required IF NOT EXISTS FOR (n:Claim) REQUIRE n.kind IS NOT NULL;
CREATE CONSTRAINT claim_status_required IF NOT EXISTS FOR (n:Claim) REQUIRE n.status IS NOT NULL;
CREATE CONSTRAINT claim_recorded_at_required IF NOT EXISTS FOR (n:Claim) REQUIRE n.recorded_at IS NOT NULL;
CREATE CONSTRAINT decision_slug_required IF NOT EXISTS FOR (n:Decision) REQUIRE n.slug IS NOT NULL;
CREATE CONSTRAINT decision_title_required IF NOT EXISTS FOR (n:Decision) REQUIRE n.title IS NOT NULL;
CREATE CONSTRAINT decision_statement_required IF NOT EXISTS FOR (n:Decision) REQUIRE n.statement IS NOT NULL;
CREATE CONSTRAINT decision_status_required IF NOT EXISTS FOR (n:Decision) REQUIRE n.status IS NOT NULL;
CREATE CONSTRAINT decision_recorded_at_required IF NOT EXISTS FOR (n:Decision) REQUIRE n.recorded_at IS NOT NULL;
CREATE CONSTRAINT action_item_slug_required IF NOT EXISTS FOR (n:ActionItem) REQUIRE n.slug IS NOT NULL;
CREATE CONSTRAINT action_item_title_required IF NOT EXISTS FOR (n:ActionItem) REQUIRE n.title IS NOT NULL;
CREATE CONSTRAINT action_item_status_required IF NOT EXISTS FOR (n:ActionItem) REQUIRE n.status IS NOT NULL;
CREATE CONSTRAINT action_item_recorded_at_required IF NOT EXISTS FOR (n:ActionItem) REQUIRE n.recorded_at IS NOT NULL;

// ── Property types (Enterprise, Neo4j 5.9+) ──────────────────────────────
CREATE CONSTRAINT person_active_type IF NOT EXISTS FOR (n:Person) REQUIRE n.active IS :: BOOLEAN;
CREATE CONSTRAINT actor_active_type IF NOT EXISTS FOR (n:Actor) REQUIRE n.active IS :: BOOLEAN;
CREATE CONSTRAINT project_target_date_type IF NOT EXISTS FOR (n:Project) REQUIRE n.target_date IS :: DATE;
CREATE CONSTRAINT source_occurred_at_type IF NOT EXISTS FOR (n:Source) REQUIRE n.occurred_at IS :: ZONED DATETIME;
CREATE CONSTRAINT claim_recorded_at_type IF NOT EXISTS FOR (n:Claim) REQUIRE n.recorded_at IS :: ZONED DATETIME;
CREATE CONSTRAINT decision_decided_at_type IF NOT EXISTS FOR (n:Decision) REQUIRE n.decided_at IS :: ZONED DATETIME;
CREATE CONSTRAINT decision_recorded_at_type IF NOT EXISTS FOR (n:Decision) REQUIRE n.recorded_at IS :: ZONED DATETIME;
CREATE CONSTRAINT action_item_due_type IF NOT EXISTS FOR (n:ActionItem) REQUIRE n.due IS :: DATE;
CREATE CONSTRAINT action_item_completed_at_type IF NOT EXISTS FOR (n:ActionItem) REQUIRE n.completed_at IS :: ZONED DATETIME;
CREATE CONSTRAINT action_item_recorded_at_type IF NOT EXISTS FOR (n:ActionItem) REQUIRE n.recorded_at IS :: ZONED DATETIME;
CREATE CONSTRAINT member_of_since_type IF NOT EXISTS FOR ()-[r:MEMBER_OF]-() REQUIRE r.since IS :: DATE;
CREATE CONSTRAINT left_team_since_type IF NOT EXISTS FOR ()-[r:LEFT_TEAM]-() REQUIRE r.since IS :: DATE;
CREATE CONSTRAINT left_team_until_type IF NOT EXISTS FOR ()-[r:LEFT_TEAM]-() REQUIRE r.until IS :: DATE;

// ── Indexes ──────────────────────────────────────────────────────────────
CREATE INDEX project_status IF NOT EXISTS FOR (n:Project) ON (n.status);
CREATE INDEX source_title IF NOT EXISTS FOR (n:Source) ON (n.title);
CREATE INDEX source_occurred_at IF NOT EXISTS FOR (n:Source) ON (n.occurred_at);
CREATE INDEX claim_statement IF NOT EXISTS FOR (n:Claim) ON (n.statement);
CREATE INDEX claim_quote IF NOT EXISTS FOR (n:Claim) ON (n.quote);
CREATE INDEX claim_status IF NOT EXISTS FOR (n:Claim) ON (n.status);
CREATE INDEX decision_title IF NOT EXISTS FOR (n:Decision) ON (n.title);
CREATE INDEX decision_status IF NOT EXISTS FOR (n:Decision) ON (n.status);
CREATE INDEX action_item_status IF NOT EXISTS FOR (n:ActionItem) ON (n.status);
CREATE INDEX action_item_due IF NOT EXISTS FOR (n:ActionItem) ON (n.due);

// ── Relationships (not enforced by Neo4j) ────────────────────────────────
// (:Person)-[:MEMBER_OF {role, since}]->(:Team)                [0..] per Person
// (:Person)-[:LEFT_TEAM {since, until}]->(:Team)               [0..] per Person
// (:Team)-[:PART_OF]->(:Team)                                  [0..1] per Team
// (:Actor)-[:ACTS_FOR]->(:Person)                              [0..1] per Actor
// (:Project)-[:OWNED_BY]->(:Person)                            [0..1] per Project
// (:Project)-[:RUN_BY]->(:Team)                                [0..1] per Project
// (:Source)-[:SOURCE_ABOUT]->(:Project)                        [0..] per Source
// (:Claim)-[:CLAIM_FROM]->(:Source)                            [1] per Claim
// (:Claim)-[:CLAIMED_BY]->(:Person)                            [1] per Claim
// (:Claim)-[:CONTRADICTS]->(:Claim)                            [0..] per Claim
// (:Decision)-[:BASED_ON]->(:Claim)                            [1..] per Decision
// (:Decision)-[:DECIDED_BY]->(:Person)                         [0..] per Decision
// (:Decision)-[:DECISION_ABOUT]->(:Project)                    [1] per Decision
// (:Decision)-[:SUPERSEDED_BY {reason}]->(:Decision)           [0..1] per Decision
// (:ActionItem)-[:ASSIGNED_TO]->(:Person)                      [0..1] per ActionItem
// (:ActionItem)-[:ACTION_FROM]->(:Claim)                       [1..] per ActionItem
// (:ActionItem)-[:FOLLOWS_FROM]->(:Decision)                   [0..1] per ActionItem
// (:ActionItem)-[:ACTION_ABOUT]->(:Project)                    [0..1] per ActionItem
//
// Enum values:
//   actor_kind: human, agent
//   project_status: planned, active, paused, done, cancelled
//   source_kind: meeting, thread, document, email, ticket, other
//   claim_kind: fact, proposal, commitment, risk
//   claim_status: unverified, verified, rejected
//   decision_status: proposed, accepted, rejected, deprecated
//   action_item_status: open, in_progress, done, cancelled
