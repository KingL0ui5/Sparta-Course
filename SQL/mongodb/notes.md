# NoSQL Databases 

NoSQL - NotOnlySQL 

 - Contains key value pairs, and the syntax varies from database to database 
 - Non-relational or distributed database system
 
 - Dynamic schema for unstructured data.
 - Different forms - key:values, documents, graph, column


 ## ACID in sql
Properties of a reliable transaction 
- Atomic. A transaction is treated as a single, indivisible unit. If one step fails, the whole thing fails.
- Consistency. Any data written must be valid according to defined rules. 
- Isolation. Concurrent transactions must execute completely independently.
- Durability. Once a transaction has been committed, it remains forever.


## MongoDB Intro 

A document like database that stores JSON-like documents, which allows you to store data with flexible schema and provides querying and aggregation tools for access and analysis. 
It uses BJSON (Binary-JSON)

### Advantages 
- Document Oriented Storage
- High level of polymorphism - not every row must have the same columns (which is the case in SQL). There can be null fields 
- There is no translation required quite often 
- Easy scaling (Horizontal). Vertical scaling is making your single processor more beefy. Horizontal scaling is increasing the number of CPUs, so you can parallelise your workload.
    - Scaling horizontally is better for parallel processing, like in websites. Furthermore, 
- Fast/Efficient - so you can easily process high velocity data
- Open Source: You can view, edit, distribute and enhance the code (at will) 

Vendor Locking: The state of being locked into a particular provider contractually or due to infrastructure

### Disadvantages 
- High memory usage and data redundancy 
- Can be inconsistent 
- Unsupported transactions

### Use Cases
- Social Media posts/data 
- API data (easy to map into mongoDB)
- Mobile app backend 
- Caching 
    - E.g. shopping cart 
- Product info
- Media files/data 
- CRM systems (customer relationship management)
    - Heavy text aspects
- CMS systems (customer management system)
- IoT and Sensor Data (there is lots of metadata - not as bothered about structure, just storage and query)
- Logs and monitoring data (things like splunk are better)
- Gaming data
- Chat systems/app


note: usually worth changing the default port to help with security


##  MongoShell 

By default, it will open with test> 
To create a database: 
```mongosh
use sparta
```

Can also use the db command to show the active database

To create a Table, use 

```mongosh 
db.createCollection("institute")
```

To insert a document (field) 

```mongosh
db.institute.insertOne({name:"New Document"})
```

You recieve an object ID, which you can use to reference the object from a different collection

To insert many documents simulataneously,
```mongosh
db.institute.insertMany([{"course": "Data Engineering"}, {"course": "Data Analysis"}])
```
Recieve two object IDs for example
![insertMany screenshot example](images/insertManyeg.png)

To see your documents in a collection, run 
```mongosh
db.institute.find()
db.institute.find({course: "Data Engineering"})
db.institute.find({_id: ObjectId("6a1d8fd64c7cbf914caa168b")})
```


### Validation 
To implement validation on creation of a document 
```mongosh 
db.createCollection("myinfo", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            title: "my infomation validation",
            required: ["name", "university", "graduation_year"],
            properties: {
                name: {
                    bsonType: "string",
                    description: "'name' is a required string" 
                },
                university: {
                    bsonType: "string",
                    description: "'university' is a required string"
                },
                graduation_year: {
                    bsonType: "int", 
                    minimum: 1900,
                    maximum: 2030, 
                    description: "'graduation_year' is a mandatory integer"
                }
            }
        }
    }
})
```