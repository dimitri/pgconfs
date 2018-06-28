# PostgreSQL: an Object Relational Database System.

PostgreSQL is a powerful, open source object-relational database system with
over 30 years of active development that has earned it a strong reputation
for reliability, feature robustness, and performance.

In this talk we're going to dive into the “object-relational database” part
of this sentence. PostgreSQL was unique in this capabilities when it was
designed, and still is to this day. Spoiler: it has nothing to do with table
inheritance!

## Glossary

  - Database System
  
      - Concurrency, not storage
      - Storage is a solved problem, serialize to XML/JSON files on S3/Ceph
      - ACID
      - Today, we dive into the C part of ACID: consistency
      
  - Relational

      https://en.wikipedia.org/wiki/Relation_(database)
      
      In relational database theory, a relation, as originally defined by E.
      F. Codd,[1] is a set of tuples (d1, d2, ..., dn), where each element
      dj is a member of Dj, a data domain.
      
  - Object-Relational
  
    http://db.cs.berkeley.edu/papers/ERL-M85-95.pdf
    
    THE DESIGN OF POSTGRES, ERL-M87-13
    Michael Stonebraker and Lawrence A. Rowe
    
    Abstract

    This paper presents the preliminary design of a new database management
    system, called POSTGRES, that is the successor to the INGRES relational
    database system. The main design goals of the new system are to:
    
      1. provide better support for complex objects,
      2. provide user extendibility for data types, operators and access
         methods,
      3. provide facilities for active databases (i.e., alerters and
         triggers) and inferencing includ- ing forward- and
         backward-chaining,
      4. simplify the DBMS code for crash recovery,
      5. produce a design that can take advantage of optical disks,
         workstations composed of multiple tightly-coupled processors, and
         custom designed VLSI chips, and
      6. make as few changes as possible (preferably none) to the relational
         model.
      
    The paper describes the query language, programming langauge interface,
    system architecture, query processing strategy, and storage system for
    the new system.
      
## PostgreSQL Data Types
  
  - System Catalogs
  
    Query system catalogs, show how it works, all dynamic
  
  - Core Data Types
  
    - Boolean
    - Text, encoding, processing
    - Date and Time
    - Network addresses
    - Ranges
    - Arrays
    - XML
    - JSON
    - ENUM
    - Point

  - Extensions
  
    - Extensibility and indexes, quick intro
  
    - ip4r
    - prefix
    - base36
    - debversion
    - PostGIS
    
## Conclusion

PostgreSQL is YeSQL!
