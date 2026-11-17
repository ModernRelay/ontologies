# Generated from base.pg. Edit base.pg and regenerate.
# Atlas HCL for PostgreSQL. Nodes become tables keyed by `slug`. An edge with at
# most one target (@card(0..1)) becomes a foreign-key column; any other edge
# becomes a join table. The Named interface is flattened into each table.

schema "public" {}

enum "organization_kind" {
  schema = schema.public
  values = ["company", "nonprofit", "government", "team", "other"]
}

enum "document_kind" {
  schema = schema.public
  values = ["doc", "page", "file", "thread", "email", "recording", "other"]
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
  column "email" {
    type = text
    null = true
  }
  column "title" {
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
}

table "organization" {
  schema = schema.public
  column "slug" {
    type = text
    null = false
  }
  column "name" {
    type = text
    null = false
  }
  column "domain" {
    type = text
    null = true
  }
  column "kind" {
    type = enum.organization_kind
    null = true
  }
  column "part_of" {
    type = text
    null = true
  }
  primary_key {
    columns = [column.slug]
  }
  index "organization_domain_key" {
    unique  = true
    columns = [column.domain]
  }
  foreign_key "organization_part_of_fkey" {
    columns     = [column.part_of]
    ref_columns = [table.organization.column.slug]
    on_delete   = SET_NULL
  }
}

table "event" {
  schema = schema.public
  column "slug" {
    type = text
    null = false
  }
  column "name" {
    type = text
    null = false
  }
  column "starts_at" {
    type = timestamptz
    null = false
  }
  column "ends_at" {
    type = timestamptz
    null = true
  }
  column "location" {
    type = text
    null = true
  }
  column "organized_by" {
    type = text
    null = true
  }
  primary_key {
    columns = [column.slug]
  }
  index "event_starts_at_idx" {
    columns = [column.starts_at]
  }
  foreign_key "event_organized_by_fkey" {
    columns     = [column.organized_by]
    ref_columns = [table.organization.column.slug]
    on_delete   = SET_NULL
  }
}

table "document" {
  schema = schema.public
  column "slug" {
    type = text
    null = false
  }
  column "title" {
    type = text
    null = false
  }
  column "kind" {
    type = enum.document_kind
    null = false
  }
  column "url" {
    type = text
    null = true
  }
  column "created_at" {
    type = timestamptz
    null = true
  }
  primary_key {
    columns = [column.slug]
  }
  index "document_url_key" {
    unique  = true
    columns = [column.url]
  }
  index "document_title_idx" {
    columns = [column.title]
  }
}

table "member_of" {
  schema = schema.public
  column "person" {
    type = text
    null = false
  }
  column "organization" {
    type = text
    null = false
  }
  column "role" {
    type = text
    null = true
  }
  column "since" {
    type = date
    null = true
  }
  primary_key {
    columns = [column.person, column.organization]
  }
  foreign_key "member_of_person_fkey" {
    columns     = [column.person]
    ref_columns = [table.person.column.slug]
    on_delete   = CASCADE
  }
  foreign_key "member_of_organization_fkey" {
    columns     = [column.organization]
    ref_columns = [table.organization.column.slug]
    on_delete   = CASCADE
  }
}

table "attended" {
  schema = schema.public
  column "person" {
    type = text
    null = false
  }
  column "event" {
    type = text
    null = false
  }
  primary_key {
    columns = [column.person, column.event]
  }
  foreign_key "attended_person_fkey" {
    columns     = [column.person]
    ref_columns = [table.person.column.slug]
    on_delete   = CASCADE
  }
  foreign_key "attended_event_fkey" {
    columns     = [column.event]
    ref_columns = [table.event.column.slug]
    on_delete   = CASCADE
  }
}

table "authored" {
  schema = schema.public
  column "person" {
    type = text
    null = false
  }
  column "document" {
    type = text
    null = false
  }
  primary_key {
    columns = [column.person, column.document]
  }
  foreign_key "authored_person_fkey" {
    columns     = [column.person]
    ref_columns = [table.person.column.slug]
    on_delete   = CASCADE
  }
  foreign_key "authored_document_fkey" {
    columns     = [column.document]
    ref_columns = [table.document.column.slug]
    on_delete   = CASCADE
  }
}

table "document_about" {
  schema = schema.public
  column "document" {
    type = text
    null = false
  }
  column "event" {
    type = text
    null = false
  }
  primary_key {
    columns = [column.document, column.event]
  }
  foreign_key "document_about_document_fkey" {
    columns     = [column.document]
    ref_columns = [table.document.column.slug]
    on_delete   = CASCADE
  }
  foreign_key "document_about_event_fkey" {
    columns     = [column.event]
    ref_columns = [table.event.column.slug]
    on_delete   = CASCADE
  }
}
