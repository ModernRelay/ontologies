# Generated from schema.pg. Edit schema.pg and regenerate.
# Atlas HCL for PostgreSQL. Nodes become tables keyed by `slug`. An edge with at most
# one target per source (@card(0..1) or exactly 1) becomes a foreign-key column on the
# source table; any other edge becomes a join table. A minimum of one (@card(1..) on
# BasedOn and ActionFrom) can't be expressed in SQL and is left to the application.

schema "public" {}

enum "actor_kind" {
  schema = schema.public
  values = ["human", "agent"]
}

enum "project_status" {
  schema = schema.public
  values = ["planned", "active", "paused", "done", "cancelled"]
}

enum "source_kind" {
  schema = schema.public
  values = ["meeting", "thread", "document", "email", "ticket", "other"]
}

enum "claim_kind" {
  schema = schema.public
  values = ["fact", "proposal", "commitment", "risk"]
}

enum "claim_status" {
  schema = schema.public
  values = ["unverified", "verified", "rejected"]
}

enum "decision_status" {
  schema = schema.public
  values = ["proposed", "accepted", "rejected", "deprecated"]
}

enum "action_item_status" {
  schema = schema.public
  values = ["open", "in_progress", "done", "cancelled"]
}

table "person" {
  schema = schema.public
  column "slug" {
    type = text
    null = false
  }
  column "name" {
    type = text
    null = false
  }
  column "title" {
    type = text
    null = true
  }
  column "active" {
    type = boolean
    null = true
  }
  column "email" {
    type = text
    null = true
  }
  column "slack" {
    type = text
    null = true
  }
  column "github" {
    type = text
    null = true
  }
  primary_key {
    columns = [column.slug]
  }
  index "person_email_key" {
    unique  = true
    columns = [column.email]
  }
  index "person_slack_key" {
    unique  = true
    columns = [column.slack]
  }
  index "person_github_key" {
    unique  = true
    columns = [column.github]
  }
}

table "actor" {
  schema = schema.public
  column "slug" {
    type = text
    null = false
  }
  column "kind" {
    type = enum.actor_kind
    null = false
  }
  column "name" {
    type = text
    null = false
  }
  column "purpose" {
    type = text
    null = true
  }
  column "active" {
    type = boolean
    null = true
  }
  column "acts_for" {
    type = text
    null = true
  }
  primary_key {
    columns = [column.slug]
  }
  foreign_key "actor_acts_for_fkey" {
    columns     = [column.acts_for]
    ref_columns = [table.person.column.slug]
    on_delete   = SET_NULL
  }
}

table "team" {
  schema = schema.public
  column "slug" {
    type = text
    null = false
  }
  column "name" {
    type = text
    null = false
  }
  column "part_of" {
    type = text
    null = true
  }
  primary_key {
    columns = [column.slug]
  }
  foreign_key "team_part_of_fkey" {
    columns     = [column.part_of]
    ref_columns = [table.team.column.slug]
    on_delete   = SET_NULL
  }
}

table "project" {
  schema = schema.public
  column "slug" {
    type = text
    null = false
  }
  column "name" {
    type = text
    null = false
  }
  column "status" {
    type = enum.project_status
    null = false
  }
  column "target_date" {
    type = date
    null = true
  }
  column "owned_by" {
    type = text
    null = true
  }
  column "run_by" {
    type = text
    null = true
  }
  primary_key {
    columns = [column.slug]
  }
  index "project_status_idx" {
    columns = [column.status]
  }
  foreign_key "project_owned_by_fkey" {
    columns     = [column.owned_by]
    ref_columns = [table.person.column.slug]
    on_delete   = SET_NULL
  }
  foreign_key "project_run_by_fkey" {
    columns     = [column.run_by]
    ref_columns = [table.team.column.slug]
    on_delete   = SET_NULL
  }
}

table "source" {
  schema = schema.public
  column "slug" {
    type = text
    null = false
  }
  column "kind" {
    type = enum.source_kind
    null = false
  }
  column "title" {
    type = text
    null = false
  }
  column "url" {
    type = text
    null = true
  }
  column "occurred_at" {
    type = timestamptz
    null = false
  }
  column "summary" {
    type = text
    null = true
  }
  primary_key {
    columns = [column.slug]
  }
  index "source_title_idx" {
    columns = [column.title]
  }
  index "source_occurred_at_idx" {
    columns = [column.occurred_at]
  }
}

table "claim" {
  schema = schema.public
  column "slug" {
    type = text
    null = false
  }
  column "statement" {
    type = text
    null = false
  }
  column "quote" {
    type = text
    null = false
  }
  column "locator" {
    type = text
    null = true
  }
  column "kind" {
    type = enum.claim_kind
    null = false
  }
  column "status" {
    type = enum.claim_status
    null = false
  }
  column "recorded_at" {
    type = timestamptz
    null = false
  }
  column "claim_from" {
    type = text
    null = false
  }
  column "claimed_by" {
    type = text
    null = false
  }
  primary_key {
    columns = [column.slug]
  }
  index "claim_statement_idx" {
    columns = [column.statement]
  }
  index "claim_quote_idx" {
    columns = [column.quote]
  }
  index "claim_status_idx" {
    columns = [column.status]
  }
  foreign_key "claim_claim_from_fkey" {
    columns     = [column.claim_from]
    ref_columns = [table.source.column.slug]
    on_delete   = RESTRICT
  }
  foreign_key "claim_claimed_by_fkey" {
    columns     = [column.claimed_by]
    ref_columns = [table.person.column.slug]
    on_delete   = RESTRICT
  }
}

table "decision" {
  schema = schema.public
  column "slug" {
    type = text
    null = false
  }
  column "title" {
    type = text
    null = false
  }
  column "statement" {
    type = text
    null = false
  }
  column "rationale" {
    type = text
    null = true
  }
  column "status" {
    type = enum.decision_status
    null = false
  }
  column "decided_at" {
    type = timestamptz
    null = true
  }
  column "recorded_at" {
    type = timestamptz
    null = false
  }
  column "decision_about" {
    type = text
    null = false
  }
  column "superseded_by" {
    type = text
    null = true
  }
  column "superseded_by_reason" {
    type = text
    null = true
  }
  primary_key {
    columns = [column.slug]
  }
  index "decision_title_idx" {
    columns = [column.title]
  }
  index "decision_status_idx" {
    columns = [column.status]
  }
  foreign_key "decision_decision_about_fkey" {
    columns     = [column.decision_about]
    ref_columns = [table.project.column.slug]
    on_delete   = RESTRICT
  }
  foreign_key "decision_superseded_by_fkey" {
    columns     = [column.superseded_by]
    ref_columns = [table.decision.column.slug]
    on_delete   = SET_NULL
  }
}

table "action_item" {
  schema = schema.public
  column "slug" {
    type = text
    null = false
  }
  column "title" {
    type = text
    null = false
  }
  column "status" {
    type = enum.action_item_status
    null = false
  }
  column "due" {
    type = date
    null = true
  }
  column "completed_at" {
    type = timestamptz
    null = true
  }
  column "recorded_at" {
    type = timestamptz
    null = false
  }
  column "assigned_to" {
    type = text
    null = true
  }
  column "follows_from" {
    type = text
    null = true
  }
  column "action_about" {
    type = text
    null = true
  }
  primary_key {
    columns = [column.slug]
  }
  index "action_item_status_idx" {
    columns = [column.status]
  }
  index "action_item_due_idx" {
    columns = [column.due]
  }
  foreign_key "action_item_assigned_to_fkey" {
    columns     = [column.assigned_to]
    ref_columns = [table.person.column.slug]
    on_delete   = SET_NULL
  }
  foreign_key "action_item_follows_from_fkey" {
    columns     = [column.follows_from]
    ref_columns = [table.decision.column.slug]
    on_delete   = SET_NULL
  }
  foreign_key "action_item_action_about_fkey" {
    columns     = [column.action_about]
    ref_columns = [table.project.column.slug]
    on_delete   = SET_NULL
  }
}

table "member_of" {
  schema = schema.public
  column "person" {
    type = text
    null = false
  }
  column "team" {
    type = text
    null = false
  }
  column "role" {
    type = text
    null = true
  }
  column "since" {
    type = date
    null = false
  }
  primary_key {
    columns = [column.person, column.team, column.since]
  }
  foreign_key "member_of_person_fkey" {
    columns     = [column.person]
    ref_columns = [table.person.column.slug]
    on_delete   = CASCADE
  }
  foreign_key "member_of_team_fkey" {
    columns     = [column.team]
    ref_columns = [table.team.column.slug]
    on_delete   = CASCADE
  }
}

table "left_team" {
  schema = schema.public
  column "person" {
    type = text
    null = false
  }
  column "team" {
    type = text
    null = false
  }
  column "since" {
    type = date
    null = false
  }
  column "until" {
    type = date
    null = false
  }
  primary_key {
    columns = [column.person, column.team, column.since]
  }
  foreign_key "left_team_person_fkey" {
    columns     = [column.person]
    ref_columns = [table.person.column.slug]
    on_delete   = CASCADE
  }
  foreign_key "left_team_team_fkey" {
    columns     = [column.team]
    ref_columns = [table.team.column.slug]
    on_delete   = CASCADE
  }
}

table "source_about" {
  schema = schema.public
  column "source" {
    type = text
    null = false
  }
  column "project" {
    type = text
    null = false
  }
  primary_key {
    columns = [column.source, column.project]
  }
  foreign_key "source_about_source_fkey" {
    columns     = [column.source]
    ref_columns = [table.source.column.slug]
    on_delete   = CASCADE
  }
  foreign_key "source_about_project_fkey" {
    columns     = [column.project]
    ref_columns = [table.project.column.slug]
    on_delete   = CASCADE
  }
}

table "contradicts" {
  schema = schema.public
  column "claim" {
    type = text
    null = false
  }
  column "other_claim" {
    type = text
    null = false
  }
  primary_key {
    columns = [column.claim, column.other_claim]
  }
  foreign_key "contradicts_claim_fkey" {
    columns     = [column.claim]
    ref_columns = [table.claim.column.slug]
    on_delete   = CASCADE
  }
  foreign_key "contradicts_other_claim_fkey" {
    columns     = [column.other_claim]
    ref_columns = [table.claim.column.slug]
    on_delete   = CASCADE
  }
}

table "based_on" {
  schema = schema.public
  column "decision" {
    type = text
    null = false
  }
  column "claim" {
    type = text
    null = false
  }
  primary_key {
    columns = [column.decision, column.claim]
  }
  foreign_key "based_on_decision_fkey" {
    columns     = [column.decision]
    ref_columns = [table.decision.column.slug]
    on_delete   = CASCADE
  }
  foreign_key "based_on_claim_fkey" {
    columns     = [column.claim]
    ref_columns = [table.claim.column.slug]
    on_delete   = CASCADE
  }
}

table "decided_by" {
  schema = schema.public
  column "decision" {
    type = text
    null = false
  }
  column "person" {
    type = text
    null = false
  }
  primary_key {
    columns = [column.decision, column.person]
  }
  foreign_key "decided_by_decision_fkey" {
    columns     = [column.decision]
    ref_columns = [table.decision.column.slug]
    on_delete   = CASCADE
  }
  foreign_key "decided_by_person_fkey" {
    columns     = [column.person]
    ref_columns = [table.person.column.slug]
    on_delete   = CASCADE
  }
}

table "action_from" {
  schema = schema.public
  column "action_item" {
    type = text
    null = false
  }
  column "claim" {
    type = text
    null = false
  }
  primary_key {
    columns = [column.action_item, column.claim]
  }
  foreign_key "action_from_action_item_fkey" {
    columns     = [column.action_item]
    ref_columns = [table.action_item.column.slug]
    on_delete   = CASCADE
  }
  foreign_key "action_from_claim_fkey" {
    columns     = [column.claim]
    ref_columns = [table.claim.column.slug]
    on_delete   = CASCADE
  }
}
