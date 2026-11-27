# ontologies

Starter ontologies for [ontology.sh](https://ontology.sh). Each folder holds one ontology: an `ONTOLOGY.md`, its source files, and an `index.md` that makes the folder an [Open Knowledge Format](https://github.com/open-knowledge-format/open-knowledge-format) v0.3 bundle.

```bash
npx ontology.sh add modernrelay/ontologies/<name>
```

| Ontology | What it models | Source | License |
|---|---|---|---|
| [schemaorg-core](schemaorg-core/) | People, organizations, places, events, creative works, products | curated subset of schema.org | CC BY-SA 3.0 |
| [prov-o](prov-o/) | Provenance: entities, activities, agents | W3C PROV-O | W3C Software and Document License |
| [foaf](foaf/) | People, groups, documents, online accounts | FOAF 0.99 | CC BY 1.0 |
| [skos](skos/) | Taxonomies, thesauri, controlled vocabularies | W3C SKOS | W3C Software and Document License |
| [time](time/) | Instants, intervals, durations | W3C/OGC OWL-Time | CC BY 4.0 |
| [fibo-legal-entities](fibo-legal-entities/) | Companies as legal entities: jurisdiction, legal form, LEI, parents | FIBO Legal Entities and the FND and OMG Commons modules it imports | MIT |
| [base](base/) | Shared base types for Omnigraph apps | ontology.sh | MIT |
| [company-brain](company-brain/) | A company's people, sources, claims, decisions | Omnigraph cookbooks | MIT |

`base` and `company-brain` are written in Omnigraph `.pg` and also ship Cypher (Neo4j 5), a GraphQL schema and Atlas HCL (PostgreSQL) generated from it. Those were applied to Neo4j 5 Enterprise and PostgreSQL 16 before publishing. Each `ONTOLOGY.md` says what the translations lose.

The upstream files are copied unmodified, except `schemaorg-core.ttl`, which is a curated subset. `fibo-legal-entities` takes whole FIBO files, but only the ones the Legal Entities module needs. Each ontology keeps its own license; see the `license` and `sources` fields in its `ONTOLOGY.md`. `generated` says who wrote the current text; none of them carries a `verified` sign-off yet.

The format is described at https://ontology.sh/docs.
