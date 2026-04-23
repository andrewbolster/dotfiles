# Data Analytics Agent Instructions

## Agent Purpose & Scope
This agent assists with data analysis tasks using Black Duck's security data products, creating insights, and supporting data-driven decision making across the organization.

## Data Architecture Understanding

### Black Duck Data Products
Three catalog layers, each with multiple schemas:

| Catalog | Schemas | Purpose |
|---------|---------|---------|
| **data_product_marts** | `core`, `enterprise`, product-specific | Analytics-ready; start here |
| **data_product_intermediate** | `core`, `enterprise`, product-specific | Shared calculations used across marts |
| **data_product_staging** | product-specific only | Raw product-native data |

**Schema types:**
- **`core`** (marts + intermediate): Cross-product business entities — customers, applications, findings, scans, targets
- **`enterprise`** (marts + intermediate): Cross-product analytics
- **Product-specific** (all catalogs): Product-native deep dives (e.g., `llm_gateway`, `polaris`, `cd`)

**Default starting point**: `data_product_marts.core` for cross-product analysis.

### Scale Context
- ~4K customers → ~130K applications → ~317K targets → ~2.8M findings
- ~20M scans with dramatic volume differences by product

### Product Context
- **Continuous Dynamic (cd_*)**: Expert-validated DAST (formerly WhiteHat Security)
- **Polaris (polaris_*)**: Multi-AST platform providing SAST, SCA, and DAST capabilities

## Analysis Best Practices

### Starting Points
1. **Customer Analysis**: Use `data_product_marts.core.customers` as base; be aware of duplicate records in Polaris regions
2. **Security Posture**: `data_product_marts.core.findings` for vulnerability analysis, join with targets for context
3. **Usage Patterns**: Cross-reference customers with applications and scans via `data_product_marts.core`

### Common Gotchas
- Some customers have duplicate records (especially Polaris EU/US)
- Not all relationships are perfectly clean (orphaned records exist)
- Customer names in Polaris may be MD5 hashes
- Scan volumes vary dramatically by product/tool type

### Quality Validation
- Always use `describe_data_product()` before querying to understand schema and known issues
- Start with `data_product_marts.core` tables for cross-product analysis
- Use product-specific staging schemas for deep dives
- Document data quality limitations in findings

## Available Tools

### Service-MCP Data Products
- Query execution with Spark SQL dialect
- Table schema exploration and description
- Data quality insights and known limitations
- Automated result pagination for large datasets

### Analysis Workflow
1. **Explore**: List and describe relevant data products
2. **Understand**: Review schema, relationships, and data quality
3. **Query**: Execute analysis with appropriate complexity for question
4. **Validate**: Cross-check results against known data limitations
5. **Document**: Provide context about data quality and methodology

## Query Standards

### SQL Best Practices
- Reference tables using full three-part names: `catalog.schema.table`
- Use appropriate timeouts for complex queries (default 60s)
- Limit result sets appropriately (default 100 rows)
- Include data quality context in results

### Common Analysis Patterns

Before using these examples, run `list_data_products()` and `describe_data_product()` to confirm current table names and column schemas — they may differ from the examples below.

```sql
-- Customer Overview
SELECT customer_name, COUNT(DISTINCT application_id) as app_count
FROM data_product_marts.core.customers c
JOIN data_product_marts.core.applications a ON c.customer_id = a.customer_id
GROUP BY customer_name
LIMIT 20;

-- Security Posture Analysis
SELECT severity, COUNT(*) as finding_count
FROM data_product_marts.core.findings
WHERE finding_status = 'open'
GROUP BY severity
ORDER BY finding_count DESC;

-- Usage Patterns
SELECT tool_type, DATE_TRUNC('month', created_at) as month, COUNT(*) as scan_count
FROM data_product_marts.core.scans
WHERE created_at >= DATE_SUB(CURRENT_DATE(), 365)
GROUP BY tool_type, month
ORDER BY month DESC, scan_count DESC;
```

## Development Standards
For Python coding tasks (scripts, automation, analysis tools), refer to standards in `/shared/development-environment.md`, particularly UV script preferences and Click CLI patterns.

## Reporting Standards
- Include methodology and data limitations
- Provide source table references
- Note data quality issues that may affect conclusions
- Suggest follow-up analyses when appropriate
- Reference time periods and data freshness