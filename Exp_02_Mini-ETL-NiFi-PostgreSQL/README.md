# README.md

# Mini ETL Pipeline using Apache NiFi and PostgreSQL

## Data Engineering Laboratory

------------------------------------------------------------------------

# Overview

This repository provides a complete hands-on laboratory for building,
validating, repairing, documenting, and assessing a Mini ETL Pipeline
using **Apache NiFi** and **PostgreSQL**.

The experiment follows the ETL workflow:

``` text
REST API
    │
    ▼
InvokeHTTP
    │
    ▼
SplitJson
    │
    ▼
JoltTransformJSON
    │
    ▼
UpdateRecord
    │
    ▼
PutDatabaseRecord
    │
    ▼
PostgreSQL
```

------------------------------------------------------------------------

# Repository Structure

``` text
Mini-ETL-NiFi-PostgreSQL/
├── docs/
├── scripts/
├── sql/
├── dataset/
├── nifi-template/
├── screenshots/
├── reports/
├── output/
└── logs/
```

------------------------------------------------------------------------

# Phase 1 -- Prepare the Project

Run the following scripts in order:

``` bash
bash scripts/01_environment_setup.sh
bash scripts/02_postgresql_setup.sh
bash scripts/03_pgadmin_setup.sh
bash scripts/04_nifi_setup.sh
bash scripts/05_workspace_setup.sh
bash scripts/06_verify_environment.sh
```

Expected outcome:

-   Ubuntu ready
-   Java installed
-   PostgreSQL configured
-   pgAdmin configured
-   Apache NiFi installed
-   Workspace created

------------------------------------------------------------------------

# Phase 2 -- Study the Documentation

Read the laboratory manuals in this sequence:

1.  01-Environment-and-Software-Setup.md
2.  02-REST-API-and-Database-Design.md
3.  03-Building-the-NiFi-Flow.md
4.  04-Data-Transformation.md
5.  05-Loading-into-PostgreSQL.md
6.  06-Testing-and-Verification.md
7.  07-Troubleshooting.md
8.  08-Viva-Questions.md
9.  09-Assignment.md

Then study the NiFi chapters:

1.  Chapter-01-Introduction.md
2.  Chapter-02-ETL-Architecture.md
3.  Chapter-03-Apache-NiFi-Basics.md
4.  Chapter-04-InvokeHTTP.md
5.  Chapter-05-SplitJson.md
6.  Chapter-06-JoltTransformJSON.md
7.  Chapter-07-UpdateRecord.md
8.  Chapter-08-PutDatabaseRecord.md
9.  Chapter-09-Running-the-Pipeline.md
10. Chapter-10-Validation.md
11. Chapter-11-Industry-Best-Practices.md

Use **Complete-ETL-Command-Reference.md** as the quick reference during
implementation.

------------------------------------------------------------------------

# Phase 3 -- Prepare PostgreSQL

Execute:

``` bash
psql -U postgres -f sql/create_database.sql
psql -U postgres -d etl_lab -f sql/create_tables.sql
```

Verify:

``` bash
psql -U postgres -d etl_lab
```

Run:

``` sql
\dt
SELECT COUNT(*) FROM products;
```

------------------------------------------------------------------------

# Phase 4 -- Build the NiFi Flow

Open:

    https://localhost:8443/nifi

Create the processors in this order:

1.  InvokeHTTP
2.  SplitJson
3.  JoltTransformJSON
4.  UpdateRecord
5.  PutDatabaseRecord

Configure every processor according to the corresponding chapter.

Enable Controller Services.

Connect processors.

Start the pipeline.

------------------------------------------------------------------------

# Phase 5 -- Validate the ETL Pipeline

Execute:

``` bash
bash scripts/validate_nifi_pipeline.sh
bash scripts/pipeline_validation_report.sh
```

Verify:

-   REST API reachable
-   No failed FlowFiles
-   Records inserted into PostgreSQL

------------------------------------------------------------------------

# Phase 6 -- Export the NiFi Flow

Execute:

``` bash
bash scripts/export_nifi_template.sh
```

Copy the exported:

    MiniETL.json

to

    nifi-template/

------------------------------------------------------------------------

# Phase 7 -- Generate Reports

Generate the reports:

``` bash
bash scripts/environment_report.sh
bash scripts/generate_student_report_V2.sh
bash scripts/assignment_grading_v2.sh
bash scripts/final_lab_report.sh
```

Reports will be created in:

    reports/

Formats:

-   Markdown
-   Text
-   HTML

------------------------------------------------------------------------

# Phase 8 -- If Something Goes Wrong

Run:

``` bash
bash scripts/etl_repair_and_validate.sh
```

This script will:

-   Detect configuration problems
-   Repair supported issues
-   Revalidate the environment
-   Generate repair reports

------------------------------------------------------------------------

# Phase 9 -- Project Maintenance

Generate or repair the repository structure:

``` bash
bash scripts/generate_project_structure_v2.sh
```

------------------------------------------------------------------------

# Expected Deliverables

Students should submit:

-   MiniETL.json
-   SQL scripts
-   Student report
-   Screenshots
-   Validation reports
-   Final laboratory report

------------------------------------------------------------------------

# Suggested Execution Order

``` text
01_environment_setup.sh
        ↓
02_postgresql_setup.sh
        ↓
03_pgadmin_setup.sh
        ↓
04_nifi_setup.sh
        ↓
05_workspace_setup.sh
        ↓
06_verify_environment.sh
        ↓
Study Documentation
        ↓
Execute SQL Scripts
        ↓
Build NiFi Pipeline
        ↓
validate_nifi_pipeline.sh
        ↓
pipeline_validation_report.sh
        ↓
export_nifi_template.sh
        ↓
environment_report.sh
        ↓
generate_student_report_V2.sh
        ↓
assignment_grading_v2.sh
        ↓
final_lab_report.sh
        ↓
etl_repair_and_validate.sh (only if required)
```

------------------------------------------------------------------------

# Completion Checklist

-   [ ] Environment prepared
-   [ ] PostgreSQL configured
-   [ ] Apache NiFi configured
-   [ ] REST API tested
-   [ ] ETL pipeline built
-   [ ] Data transformed
-   [ ] Records loaded into PostgreSQL
-   [ ] Validation completed
-   [ ] MiniETL.json exported
-   [ ] Reports generated
-   [ ] Assignment graded
-   [ ] Final report generated

------------------------------------------------------------------------

# Result

After completing all phases, students will have successfully designed,
implemented, validated, documented, and assessed a complete end-to-end
ETL pipeline using Apache NiFi and PostgreSQL, following an
industry-oriented workflow.
