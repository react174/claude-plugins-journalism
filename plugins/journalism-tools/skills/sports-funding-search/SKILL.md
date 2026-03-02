---
name: sports-funding-search
description: Search for and compile public subsidies, tax breaks, and government funding for sports teams, stadiums, and venues. Use when a journalist is investigating public money flowing to professional or amateur sports organizations, tracking stadium deals, documenting tax incentives, or building a dataset of sports-related public expenditures. Helps identify and access relevant databases, public records, and FOIA request targets. Emphasizes verifiability—every funding figure must trace to a primary source document.
---

# Sports Funding Search

Research public subsidies and government funding for sports organizations. Every dollar amount must trace to a primary source the journalist can verify independently.

## Core Principles

1. **Primary sources only**: Every funding figure must cite a budget document, bond issuance, tax filing, government contract, or official record—not a press release or news article.
2. **Distinguish fund types**: Grants, tax abatements, tax-exempt bonds, infrastructure spending, and operating subsidies are different instruments. Track each separately.
3. **Totals require methodology**: Any aggregate figure (e.g., "total public subsidy") requires explicit methodology and a list of every line item.
4. **Negative space matters**: Document what you can't find, not just what you find. Gaps in records are findings.
5. **Multiple verification paths**: Cross-reference figures across sources—budget documents, bond disclosures, audit reports, and news accounts should agree.

## Key Data Sources

### National Databases

| Source | What It Covers | URL Pattern |
|--------|---------------|-------------|
| Good Jobs First Subsidy Tracker | Federal and state subsidies by company | subsidytracker.goodjobsfirst.org |
| Good Jobs First Sports Subsidies | Stadium deals and public costs | Filtered view of Subsidy Tracker |
| USA Spending | Federal contracts, grants, direct payments | usaspending.gov |
| SEC EDGAR | Municipal bond disclosures for stadium financing | efts.sec.gov/LATEST/search-index |
| IRS Form 990s (ProPublica Nonprofit Explorer) | Nonprofit sports orgs, league offices | projects.propublica.org/nonprofits |

### State and Local Sources

- **State budget portals**: Most states publish line-item budgets with searchable databases
- **Municipal bond documents**: Official Statements filed with MSRB (msrb.org) detail public financing
- **Property tax records**: Exemptions and PILOTs (payments in lieu of taxes) recorded with county assessors
- **Economic development agreements**: Filed with city/county clerk or economic development agencies
- **Annual financial reports (AFRs/CAFRs)**: Comprehensive government financial statements, often include major economic development commitments

### League-Specific Sources

- **NFL/NBA/MLB/NHL**: Venue agreements often filed as public records with the host municipality
- **NCAA**: Form 990s for conferences; university athletic department financial statements
- **Minor leagues**: Local government budgets, development authorities, industrial revenue bonds

## Workflow

### Stage 1: Scoping

Before searching, clarify with the journalist:

1. **Geographic scope**: Which city, state, or region?
2. **Temporal scope**: What date range? (Stadium deals often span 20-30 years)
3. **Organizational scope**: Professional leagues only? College sports? Amateur/youth?
4. **Fund type scope**: All public money, or specific instruments (e.g., tax-exempt bonds only)?
5. **Comparison frame**: Is this a single deal, or a comparison across multiple markets?

Produce a one-page scope document for journalist approval before proceeding.

### Stage 2: Database Search

Search the national databases first to establish a baseline. For each database:

1. Run the search and screenshot/export results
2. Note the database's methodology and limitations
3. Flag any figures that need primary source verification
4. Document the search date (databases update regularly)

**Sample search approach:**

```
Good Jobs First Subsidy Tracker:
- Search: [team name] OR [stadium name] OR [ownership entity]
- Filter: State = [state], Program type = [relevant types]
- Export full results to CSV
- Note: covers state-level subsidies; may miss local deals

MSRB/SEC EDGAR for bond documents:
- Search issuer: [city] OR [stadium authority name]
- Filter by state and date range
- Download Official Statements for relevant bond issuances
```

### Stage 3: Primary Source Verification

For each funding item identified, locate the primary source document:

| Funding Type | Primary Source Document |
|-------------|------------------------|
| State grant | Budget appropriation + grant agreement |
| Tax abatement | Abatement agreement + property tax records |
| Tax-exempt bonds | Bond Official Statement + MSRB filing |
| Infrastructure | Capital budget + project contracts |
| Tax increment financing (TIF) | TIF agreement + annual reports |
| Federal grant | USASpending.gov award + grant agreement |

**Verification checklist per item:**
- [ ] Amount confirmed in primary source (not press release)
- [ ] Date range confirmed
- [ ] Recipient/beneficiary identified
- [ ] Government authority identified (who authorized this?)
- [ ] Conditions/clawbacks documented (what did the public get in return?)
- [ ] Source document saved and cited with URL or FOIA tracking number

### Stage 4: FOIA/Records Requests

For records not publicly available online, draft targeted requests:

**Common FOIA targets for sports funding:**
- Lease agreements between team and public stadium authority
- Non-disclosure agreements (note if they exist, then request them)
- Economic impact study contracts and full reports
- Correspondence between team ownership and public officials
- Term sheets and negotiating documents for public subsidies
- Clawback provisions and whether they've ever been triggered

**FOIA request components:**
1. Specific record type (not "any documents about")
2. Date range
3. Parties involved
4. Format preference (electronic preferred)
5. Fee waiver request citing journalistic purpose

Save all requests with: agency, date sent, tracking number, status.

### Stage 5: Data Assembly

Compile all verified funding into a structured dataset. Required fields:

```
- subsidy_id          # Unique identifier for this subsidy item
- recipient_name      # Team or entity receiving benefit
- recipient_type      # Professional team / league / stadium authority / etc.
- sport               # Football / Basketball / Baseball / etc.
- league              # NFL / NBA / MLB / NHL / MLS / NCAA / etc.
- city                # Primary city
- state               # State abbreviation
- venue_name          # Stadium/arena name (if applicable)
- subsidy_type        # Grant / Tax abatement / Bond / Infrastructure / TIF / Other
- amount_usd          # Dollar amount (use NULL if unknown, not 0)
- amount_notes        # How amount was calculated if not a single figure
- year_start          # Year subsidy begins
- year_end            # Year subsidy ends (NULL if ongoing)
- government_level    # Federal / State / Local
- authorizing_body    # Which government entity authorized this
- source_document     # Citation for primary source
- source_url          # URL if available
- verified_date       # When this entry was verified
- verification_notes  # Any caveats about this figure
```

### Stage 6: Findings Summary

Produce a `sports_funding_findings.md` report:

```markdown
# Sports Funding Research: [Scope]
**Date**: [Date]
**Researcher**: [Name]
**Scope**: [Geographic and temporal scope]

---

## Summary

**Total verified public funding**: $[amount] ([methodology note])
**Number of distinct subsidy items**: [N]
**Time period covered**: [start] – [end]
**Deals with incomplete records**: [N]

---

## Top Findings

### Finding 1: [Headline-style description]
**Amount**: $[X]
**Source**: [Primary source citation]
**Key detail**: [What makes this newsworthy]
**Verification status**: Confirmed / Pending / Partial

[Continue for each major finding]

---

## Records Gaps

[Document what public records were unavailable, pending, or denied]

| Gap | Why it matters | Status |
|-----|---------------|--------|
| [Record type] | [Why this matters to the story] | [Requested/Not yet requested/Denied] |

---

## Methodology

[Brief explanation of how totals were calculated, what was included/excluded, and key assumptions]

---

## Output Files

| File | Description |
|------|-------------|
| `sports_funding_data.csv` | All verified subsidy items |
| `foia_log.csv` | Log of all records requests |
| `source_documents/` | Copies of primary source documents |
```

## Common Issues and Pitfalls

**Inflated totals from double-counting**: Bond face value ≠ public cost. A $500M tax-exempt bond issued by a stadium authority may cost taxpayers far less (or far more) depending on who pays debt service.

**"Economic impact" is not public subsidy**: Economic impact claims from booster reports are not evidence of public benefit. Separate them from direct public expenditures.

**Team values vs. public cost**: Stadium construction cost ≠ public subsidy. Identify exactly which portions were publicly funded.

**Shell entities**: Public funding often flows through stadium authorities, development corporations, or TIF districts—not directly to teams. Follow the money through these intermediaries.

**Clawbacks rarely enforced**: If a deal includes clawback provisions, check whether they've ever been triggered. Document if they haven't.

## References

- `references/data-sources.md` - Detailed guide to accessing each database
- `references/subsidy-types.md` - Definitions and accounting conventions for each subsidy type
