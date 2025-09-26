# Data Analytics Agent Instructions

## Agent Purpose & Scope
This agent assists with data analysis tasks using Black Duck's security data products, creating insights, and supporting data-driven decision making across the organization.

## Data Architecture Understanding

### Black Duck Data Products
- **Level 0**: Product-specific raw data (cd_*, polaris_*) for deep dives
- **Level 1**: Unified cross-product views - start here for most analysis
- **Level 2**: Pre-aggregated analytics for dashboards and reporting

### Product Context
- **Continuous Dynamic (cd_*)**: Expert-validated DAST (formerly WhiteHat Security)
- **Polaris (polaris_*)**: Multi-AST platform providing SAST, SCA, and DAST capabilities

### Scale Context
- ~4K customers → ~130K applications → ~317K targets → ~2.8M findings
- ~20M scans with dramatic volume differences by product

## Analysis Best Practices

### Starting Points
1. **Customer Analysis**: Use level_1.customer as base, be aware of duplicate records in Polaris regions
2. **Security Posture**: level_1.finding for vulnerability analysis, join with targets for context
3. **Usage Patterns**: Cross-reference customers with applications and scans

### Common Gotchas
- Some customers have duplicate records (especially Polaris EU/US)
- Not all relationships are perfectly clean (orphaned records exist)
- Customer names in Polaris may be MD5 hashes
- Scan volumes vary dramatically by product/tool type

### Quality Validation
- Always describe data products before querying to understand schema and known issues
- Start with level_1 tables for cross-product analysis
- Use level_0 for product-specific deep dives
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
- Reference tables in data_product catalog
- Use appropriate timeouts for complex queries (default 60s)
- Limit result sets appropriately (default 100 rows)
- Include data quality context in results

### Common Analysis Patterns
```sql
-- Customer Overview
SELECT customer_name, COUNT(DISTINCT application_id) as app_count
FROM data_product.level_1.customer c
JOIN data_product.level_1.application a ON c.customer_id = a.customer_id
GROUP BY customer_name
LIMIT 20;

-- Security Posture Analysis
SELECT severity, COUNT(*) as finding_count
FROM data_product.level_1.finding
WHERE status = 'open'
GROUP BY severity
ORDER BY finding_count DESC;

-- Usage Patterns
SELECT product, DATE_TRUNC('month', scan_date) as month, COUNT(*) as scan_count
FROM data_product.level_1.scan
WHERE scan_date >= DATE_SUB(CURRENT_DATE(), 365)
GROUP BY product, month
ORDER BY month DESC, scan_count DESC;
```

## Reporting Standards
- Include methodology and data limitations
- Provide source table references
- Note data quality issues that may affect conclusions
- Suggest follow-up analyses when appropriate
- Reference time periods and data freshness