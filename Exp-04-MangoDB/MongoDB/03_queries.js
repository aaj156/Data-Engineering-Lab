//======================================================
// STEP 3 : READ OPERATIONS
//======================================================

// Display all documents
db.products.find();

// Projection
db.products.find({}, {_id:0,name:1,price:1});

// Filter
db.products.find({category:"Electronics"});

// Price greater than 30000
db.products.find({price:{$gt:30000}});

// Nested document
db.products.find({"specifications.RAM":"16GB"});

// Reflection:
// Which query returned the fewest documents?
