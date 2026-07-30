//======================================================
// STEP 5 : INDEXING
//======================================================

// Create Index
db.products.createIndex({brand:1});

// Compound Index
db.products.createIndex({
    category:1,
    price:-1
});

// Verify
db.products.getIndexes();

// Query Performance
db.products.find({brand:"Dell"})
          .explain("executionStats");

// Observe:
// Look for totalDocsExamined and totalKeysExamined.

// Challenge:
// Create an index on productId.
