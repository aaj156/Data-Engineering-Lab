//======================================================
// STEP 4 : UPDATE & DELETE
//======================================================

// Update price
db.products.updateOne(
    {productId:1001},
    {$set:{price:70000}}
);

// Increase stock
db.products.updateMany(
    {},
    {$inc:{stock:5}}
);

// Delete one document
db.products.deleteOne(
    {productId:1002}
);

// Verify
db.products.find();
