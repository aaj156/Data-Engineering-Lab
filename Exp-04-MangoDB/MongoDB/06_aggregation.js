//======================================================
// STEP 6 : AGGREGATION
//======================================================

// Average Price by Category

db.products.aggregate([
{
    $group:{
        _id:"$category",
        AveragePrice:{$avg:"$price"}
    }
}
]);

// Maximum Price

db.products.aggregate([
{
    $group:{
        _id:null,
        MaximumPrice:{$max:"$price"}
    }
}
]);

// Reflection:
// How is aggregation different from find()?
