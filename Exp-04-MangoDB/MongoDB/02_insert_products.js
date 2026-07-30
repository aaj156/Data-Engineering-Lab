//======================================================
// STEP 2 : INSERT DOCUMENTS
//======================================================

// Flexible Schema Example

db.products.insertMany([
{
  productId:1001,
  name:"Laptop",
  brand:"Dell",
  category:"Electronics",
  price:65000,
  stock:20,
  specifications:{
      RAM:"16GB",
      SSD:"512GB"
  },
  ratings:[5,4,5]
},
{
  productId:1002,
  name:"Wireless Mouse",
  brand:"Logitech",
  category:"Accessories",
  price:1200,
  color:"Black",
  wireless:true
},
{
  productId:1003,
  name:"Smartphone",
  brand:"Samsung",
  category:"Electronics",
  price:38000,
  camera:"64MP",
  battery:"5000mAh"
}
]);

// Verify
// db.products.find().pretty()

// Observe:
// Notice that every document does NOT contain the same fields.

// Challenge:
// Insert another product with your own custom fields.
