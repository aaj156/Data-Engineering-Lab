# VIVA_QUESTIONS.md
# Experiment 05 – Viva Question Bank

## Instructions
Faculty may ask questions from any section. Students should understand the concepts instead of memorizing answers.

# REST APIs

### Q1. What is a REST API?

**Expected Answer:** An architectural style for building web services using HTTP methods.

### Q2. Why are REST APIs used in Data Engineering?

**Expected Answer:** They provide a standard way to ingest and expose data.

### Q3. What is an endpoint?

**Expected Answer:** A URL that provides access to a specific API resource.

### Q4. Differentiate client and server.

**Expected Answer:** Client sends requests; server processes requests and returns responses.

### Q5. What is CRUD?

**Expected Answer:** Create, Read, Update and Delete operations.

# HTTP Methods

### Q6. What is GET?

**Expected Answer:** Retrieves data.

### Q7. What is POST?

**Expected Answer:** Creates a new resource.

### Q8. What is PUT?

**Expected Answer:** Updates or replaces an existing resource.

### Q9. What is DELETE?

**Expected Answer:** Removes a resource.

### Q10. What is a 200 status code?

**Expected Answer:** Request processed successfully.

### Q11. What is a 201 status code?

**Expected Answer:** Resource created successfully.

### Q12. What is a 404 status code?

**Expected Answer:** Requested resource not found.

### Q13. What is a 500 status code?

**Expected Answer:** Internal server error.

# JSON

### Q14. What is JSON?

**Expected Answer:** JavaScript Object Notation; a lightweight data-interchange format.

### Q15. Why is JSON popular?

**Expected Answer:** It is human-readable, lightweight and language-independent.

### Q16. What is a JSON object?

**Expected Answer:** A collection of key-value pairs enclosed in braces.

### Q17. What is a JSON array?

**Expected Answer:** An ordered list enclosed in square brackets.

### Q18. Can JSON store nested objects?

**Expected Answer:** Yes.

# FastAPI & Pydantic

### Q19. What is FastAPI?

**Expected Answer:** A modern Python framework for building APIs.

### Q20. Why FastAPI?

**Expected Answer:** High performance, automatic documentation and validation.

### Q21. What is Swagger UI?

**Expected Answer:** Interactive API documentation generated automatically.

### Q22. What is Pydantic?

**Expected Answer:** A library used for data validation.

### Q23. Why validate JSON?

**Expected Answer:** To ensure incoming data matches the required schema.

# MongoDB

### Q24. What is MongoDB?

**Expected Answer:** A NoSQL document database.

### Q25. What is a document?

**Expected Answer:** A JSON-like BSON record.

### Q26. What is a collection?

**Expected Answer:** A group of related documents.

### Q27. What is a database?

**Expected Answer:** A logical container of collections.

### Q28. When is a database created?

**Expected Answer:** Automatically when the first document is inserted.

# Elasticsearch

### Q29. What is Elasticsearch?

**Expected Answer:** A distributed search and analytics engine.

### Q30. What is an index?

**Expected Answer:** A logical collection of searchable documents.

### Q31. Why use Elasticsearch?

**Expected Answer:** Fast full-text search and analytics.

### Q32. What is a match query?

**Expected Answer:** Searches documents matching a field value.

### Q33. What is Kibana?

**Expected Answer:** A visualization and management tool for Elasticsearch.

# Data Engineering

### Q34. What is data ingestion?

**Expected Answer:** Collecting and loading data into storage systems.

### Q35. Why use REST APIs for ingestion?

**Expected Answer:** They provide a standard interface for applications.

### Q36. What is a data pipeline?

**Expected Answer:** A sequence of processes that move and transform data.

### Q37. Difference between SQL and NoSQL?

**Expected Answer:** SQL uses structured tables; NoSQL supports flexible document models.

### Q38. Name some real-world applications.

**Expected Answer:** E-commerce, banking, IoT, healthcare, social media.

# Debugging & Practical

### Q39. Port 8000 is busy. What do you do?

**Expected Answer:** Stop the existing process or change the port.

### Q40. MongoDB connection failed. What should you check?

**Expected Answer:** Verify the MongoDB service and connection string.

### Q41. Elasticsearch is unreachable. What should you check?

**Expected Answer:** Ensure the Elasticsearch service is running on port 9200.

### Q42. Why use a virtual environment?

**Expected Answer:** To isolate project dependencies.

### Q43. Why test with Swagger?

**Expected Answer:** To verify endpoints without writing client code.

# Scenario Based

### Q44. What happens when a POST request is sent?

**Expected Answer:** The API validates JSON, stores it in MongoDB, indexes it in Elasticsearch, and returns a response.

### Q45. Why store data in MongoDB and Elasticsearch?

**Expected Answer:** MongoDB stores operational data while Elasticsearch enables fast search.

### Q46. If JSON validation fails, what should the API return?

**Expected Answer:** A validation error indicating invalid input.

### Q47. How can you extend this project?

**Expected Answer:** Add PUT/DELETE APIs, authentication, PostgreSQL, or bulk indexing.

### Q48. Where is this architecture used?

**Expected Answer:** Log analytics, e-commerce, IoT platforms, healthcare, and banking.


---

**Total Questions:** 48

## Additional Activity
Faculty may ask students to explain the complete data flow from Client → FastAPI → Pydantic → MongoDB → Elasticsearch → GET/Search API using the architecture developed in the experiment.