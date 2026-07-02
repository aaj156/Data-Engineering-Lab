
# Data Engineering Laboratory

# Experiment No. 1

## Title
**Exploratory Data Analysis (EDA) & Data Cleaning using Python**

---

# Aim

To perform Exploratory Data Analysis (EDA) on a CSV dataset using Python and Pandas, identify missing values, duplicate records, inconsistent data types, and outliers, clean the dataset, generate statistical summaries, visualize the data, and prepare a high-quality dataset for further analytics.

---

# Course Outcome Mapping

**CO3:** Design and implement basic data ingestion workflows, perform exploratory data analysis, apply data cleaning techniques, and analyze data quality within data pipelines.

**Bloom's Taxonomy Level:** Apply (L3)

---

# Software & Hardware Requirements

## Hardware
- Intel i3/i5/i7 Processor
- Minimum 8 GB RAM
- 10 GB Free Disk Space

## Software

- Python 3.11+
- Jupyter Notebook / VS Code
- Anaconda (Optional)

## Python Libraries

```bash
pip install pandas numpy matplotlib seaborn
```

# Learning Outcome

After successful completion of this experiment, students will be able to:

- Load structured datasets into a **Pandas DataFrame**.
- Perform **Exploratory Data Analysis (EDA)** on structured data.
- Detect and analyze **missing values**, **duplicate records**, and **inconsistent data types**.
- Identify **statistical outliers** using appropriate techniques.
- Apply suitable **data cleaning** methods to improve data quality.
- Generate **descriptive statistics** for data analysis.
- Create meaningful **visualizations** to understand data characteristics and distributions.
- Perform **data profiling** to assess the overall quality and usability of the dataset.
- Prepare a cleaned and structured dataset for further analytics and machine learning applications.

---

# Dataset

This experiment can be performed using **any structured CSV dataset** containing numerical and/or categorical attributes.

### Example Datasets

- 🎓 Student Performance Dataset
- 🚢 Titanic Passenger Dataset
- 👨‍💼 Employee Dataset
- 💰 Sales Dataset
- 🌸 Iris Flower Dataset
- 🏥 Healthcare Dataset
- 🛒 E-Commerce Customer Dataset
- 🏦 Banking Customer Dataset

> **Note:** The dataset should be in **CSV (Comma-Separated Values)** format and contain sufficient records for performing data exploration, cleaning, and visualization tasks.
---

# Theory

## What is Exploratory Data Analysis (EDA)?

Before building any data pipeline, the quality of data must be examined. Exploratory Data Analysis (EDA) is the process of understanding the structure, characteristics, and quality of the data before applying transformations. Typical EDA activities include:

## Common EDA Activities

During Exploratory Data Analysis, the following activities are commonly performed:

- 📊 Understanding dataset dimensions (`shape`)
- 📋 Viewing column names and attribute information (`columns`)
- 🔍 Examining data types (`dtypes`)
- 📑 Displaying sample records (`head()`, `tail()`)
- 📈 Generating descriptive statistics (`describe()`)
- ❓ Identifying missing values (`isnull()`)
- 🔄 Detecting duplicate records (`duplicated()`)
- 🚨 Detecting statistical outliers using Boxplots or the IQR method
- 📉 Visualizing distributions using Histograms
- 🔥 Analyzing feature relationships using Correlation Heatmaps
- 📊 Performing data profiling to assess dataset quality

## Data cleaning improves the quality of the dataset by correcting or removing invalid, incomplete, duplicate, or inconsistent records. These steps form the Transform phase of the ETL (Extract, Transform, Load) process.
---

## Why Data Cleaning?

Raw datasets are rarely perfect.

Common problems include:

- Missing values
- Duplicate records
- Invalid values
- Incorrect data types
- Outliers
- Inconsistent formatting

Data cleaning improves data quality before loading it into a warehouse or analytics platform.

---

## Data Quality Dimensions

- Completeness
- Accuracy
- Consistency
- Validity
- Timeliness
- Uniqueness

---

## Role of Data Engineers

A Data Engineer:

- Collects data
- Builds ETL/ELT pipelines
- Cleans data
- Stores data
- Maintains data quality
- Makes data available for analytics

---

## Real-world Applications

- Banking
- Healthcare
- Retail
- Manufacturing
- Smart Cities
- IoT
- E-Commerce

---

# Flow Diagram

```text
Start
   |
Import Libraries
   |
Load CSV Dataset
   |
Explore Dataset
   |
Profile Data
   |
Detect Missing Values
   |
Detect Duplicates
   |
Detect Outliers
   |
Handle Missing Values
   |
Correct Data Types
   |
Remove Duplicates
   |
Handle Outliers
   |
Generate Statistics
   |
Visualize Dataset
   |
Save Clean Dataset
   |
End
```

---

# Dataset Description

Use any structured CSV dataset such as:

- Titanic
- Iris
- Employee
- Sales
- Student
- Healthcare

---

# Installation

```bash
pip install pandas numpy matplotlib seaborn
```

---

# Folder Structure

```text
EDA_Lab/
│
├── dataset.csv
├── README.md
├── experiment1.ipynb
├── cleaned_dataset.csv
└── images/
```

---

# Step-by-Step Implementation

## Step 1 – Import Libraries

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
```

Explanation:
Imports libraries required for data manipulation and visualization.

---

## Step 2 – Load CSV Dataset

```python
df = pd.read_csv("dataset.csv")
```

Loads CSV into a Pandas DataFrame.

---

## Step 3 – Display Dataset

```python
df.head()
df.tail()
```

Displays first and last records.

---

## Step 4 – Dataset Shape

```python
df.shape
```

Returns rows and columns.

---

## Step 5 – Column Names

```python
df.columns
```

Lists all attributes.

---

## Step 6 – Data Types

```python
df.dtypes
```

Checks datatype of every column.

---

## Step 7 – Dataset Information

```python
df.info()
```

Displays memory usage, datatype and null count.

---

## Step 8 – Summary Statistics

```python
df.describe()
df.describe(include='object')
```

Generates statistical summary.

---

## Step 9 – Missing Values

```python
df.isnull().sum()
```

Counts missing values.

---

## Step 10 – Duplicate Records

```python
df.duplicated().sum()
```

Detects duplicate rows.

---

## Step 11 – Unique Values

```python
df.nunique()
```

Displays unique values.

---

## Step 12 – Handle Missing Values

```python
df.dropna(inplace=True)

# OR

df["Age"].fillna(df["Age"].mean(), inplace=True)
```

---

## Step 13 – Correct Data Types

```python
df["Date"]=pd.to_datetime(df["Date"])
```

---

## Step 14 – Remove Duplicates

```python
df.drop_duplicates(inplace=True)
```

---

## Step 15 – Detect Outliers

```python
Q1=df["Salary"].quantile(0.25)
Q3=df["Salary"].quantile(0.75)
IQR=Q3-Q1

lower=Q1-1.5*IQR
upper=Q3+1.5*IQR

outliers=df[(df["Salary"]<lower)|
            (df["Salary"]>upper)]
```

---

## Step 16 – Remove Outliers

```python
df=df[(df["Salary"]>=lower)&
      (df["Salary"]<=upper)]
```

---

## Step 17 – Visualizations

### Histogram

```python
df.hist(figsize=(10,8))
plt.show()
```

### Boxplot

```python
sns.boxplot(x=df["Salary"])
plt.show()
```

### Correlation Heatmap

```python
sns.heatmap(df.corr(numeric_only=True),
            annot=True,
            cmap="coolwarm")
plt.show()
```

---

## Step 18 – Save Clean Dataset

```python
df.to_csv("cleaned_dataset.csv",index=False)
```

---

# Complete Python Code

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

df=pd.read_csv("dataset.csv")

print(df.head())
print(df.info())
print(df.describe())

print(df.isnull().sum())
print(df.duplicated().sum())

df.drop_duplicates(inplace=True)

df.hist(figsize=(10,8))
plt.show()

sns.boxplot(data=df)
plt.show()

sns.heatmap(df.corr(numeric_only=True),annot=True,cmap="coolwarm")
plt.show()

df.to_csv("cleaned_dataset.csv",index=False)
```

---

# Expected Outputs

- Dataset loaded successfully
- Dataset profile generated
- Missing value report
- Duplicate report
- Summary statistics
- Histogram
- Boxplot
- Correlation Heatmap
- Cleaned CSV dataset

---

# Explanation of Every Command

| Command | Purpose |
|----------|----------|
| read_csv() | Reads CSV file |
| head() | First five records |
| tail() | Last five records |
| shape | Dataset dimensions |
| columns | List columns |
| dtypes | Data types |
| info() | Dataset summary |
| describe() | Statistical summary |
| isnull() | Missing values |
| duplicated() | Duplicate records |
| fillna() | Replace missing values |
| dropna() | Remove missing rows |
| drop_duplicates() | Remove duplicate rows |
| quantile() | Quartiles |
| hist() | Histogram |
| boxplot() | Outlier visualization |
| heatmap() | Correlation matrix |
| to_csv() | Save cleaned dataset |

---

# Observation Table

| Activity | Observation |
|-----------|-------------|
| Dataset Loaded | Successful |
| Shape Checked | Rows and columns identified |
| Missing Values | Identified |
| Duplicate Records | Identified |
| Outliers | Detected |
| Data Cleaned | Successful |
| Visualizations | Generated |

---

# Result

The CSV dataset was successfully explored using Exploratory Data Analysis techniques. Missing values, duplicate records, inconsistent data types, and outliers were identified and handled appropriately. Statistical summaries and visualizations were generated, and the cleaned dataset was saved for further data engineering tasks.

---

# Conclusion

EDA is a fundamental step in Data Engineering that ensures data quality before analytics and machine learning. Using Pandas and visualization libraries, engineers can efficiently profile, clean, and validate datasets for reliable downstream processing.

---

# Viva Questions

1. What is EDA?
2. Why is EDA important?
3. Define Data Cleaning.
4. What are missing values?
5. Explain duplicate records.
6. What are outliers?
7. What is IQR?
8. Difference between mean and median?
9. What is data profiling?
10. What is ETL?
11. Difference between ETL and ELT?
12. Explain describe().
13. Explain info().
14. What is correlation?
15. Why use heatmaps?

---

# Assignment

1. Perform EDA on the Titanic dataset.
2. Replace missing values using mean, median, and mode.
3. Detect outliers using the IQR method.
4. Compare histogram and boxplot interpretations.
5. Save the cleaned dataset and summarize the changes.

---

# References

1. Pandas Documentation – https://pandas.pydata.org
2. NumPy Documentation – https://numpy.org
3. Matplotlib Documentation – https://matplotlib.org
4. Seaborn Documentation – https://seaborn.pydata.org
5. Python Documentation – https://docs.python.org
6. *Data Engineering with Python* by Paul Crickard.
