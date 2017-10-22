# pgloader, Your Migration Companion

Migrating data from another RDBMS to PostgreSQL should be really easy. After
all it's all relations and tables and the same data types everywhere or
abouts, with text, dates and numbers. Well it's actually quite messy and
complex to migrate the data properly from one system to another. pgloader
solves this problem and turns it into a one-liner: in this talk you'll learn
how to benefit from that, and the classic pitfalls to avoid.

The process of migrating the data being all automated means that you can run
it into your CI environment and test your code everyday with a fresh load of
production's data.

## Talk

  - Presenter
    - PostgreSQL Major Contributor
    - Mastering PostgreSQL in Application Development

  - Database Migration Projects
    - Why?
      - Cost
      - Efficiency
      - “Expected Behavior” (ACID)
        - Less work for the developers
        - Just Work™
        - Handle complexity (as a service)
    - Budget (data, code, service, opportunity cost)
  
  - Methodology / How
    - most common, as seen in the field
      - setup pg, move data
      - one off script
      - port the code, weeks long project
      - ready for production! plan a switch
      - sometimes, run the one-off script again before d-day
    - 
    
  - Improving the Methodology
    - CI/CD
    - All automated data migration, at least nigthly
    - Unit tests against the new PostgreSQL version of the code
    - Porting with a CI running against PostgreSQL
    - No surprise on D-Day
    
  - That's pgloader for you!
    - demo
    - mention docker image?
    - integration in CI/CD easy, single script, all automated
    - all the details that make it possible:
      - catalog mapping / operations
      - advanced User Defined Casting Rules
      - non-trivial options
      - works with an empty just-created database
      - works also with the database left from the previous run

  - Other pgloader use cases
    - CSV
    - 
    
  - Testimonials
  - pgloader Moral License

## Testimonials

  https://gist.github.com/joshmosh/187b2ad0713ec22ced62ebd2440d1424
  
  When I was doing my research on importing large amounts of data via a CSV
  I had a tab open in the background for pgloader. At first I was a little
  itimitated by the amount of features but after I sat down an narrowed down
  my use case I found almost the exact thing I needed to do in the test
  folder. The test for FILENAMES MATCHING was exactly what I wanted to do
  because I already had these large files broken up by 1,000,000 rows each
  in a folder. I modified it for local use and was able to see performance
  as fast a 8,000,000 rows taking only 1 minute and 15 seconds. This is huge
  because I can now archieve these audience files using git and git-lfs so
  they can be re-imported at any time we need with little to no downtime.
  
  LOAD CSV
  FROM ALL FILENAMES MATCHING ~<TS_062617_NatInds55.*csv$> IN DIRECTORY 'csvs/nat-inds-over-55' WITH ENCODING iso-8859-1
      HAVING FIELDS
      (
          van_id, first_name, middle_name, last_name, suffix, phone, email, address, city, state, zip5, audience_id, audience_list_id
      )
  INTO postgresql://postgres:postgres@localhost:5432/postgres?persons
      TARGET COLUMNS
      (
          van_id, first_name, middle_name, last_name, suffix, phone, email, address, city, state, zip5, audience_id, audience_list_id
      )
  WITH truncate,
      skip header = 1,
      fields optionally enclosed by '"',
      fields escaped by double-quote,
      fields terminated by ',';


  https://twitter.com/jasonrabolli/status/910728177017868289

  @heroku pgloader works, mysqltopostgres doesn't (like ever). just a public
  service. update docs


  https://twitter.com/tommasomatic/status/884181490724155392
  
  @tapoueh #pgloader is so good I'm almost crying! Say goodbye to all mysql
  implementations! Thanks!


  https://developer.salesforce.com/blogs/developer-relations/2016/05/mysql-to-postgres-in-20-minutes.html?utm_content=buffer5f10c&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer
  
  Migrating from MySQL to Postgres in 20 Minutes (give or take)
  
  We had two volunteers from Heroku help us, Lyric Hartley and Phil
  Ripperger. They regularly do this same kind of work with external
  customers, and it would have been a very different (and maybe
  unsuccessful) process without them. First they installed a program called
  ‘pgloader’ on an EC2 instance, which would do the actual conversion. This
  was as easy as telling pgloader to point directly at the source MySQL
  instance and the destination Postgres instance. Because both the MySQL and
  Postgres databases were on the same Amazon network, the conversion took
  only 20 minutes. Seriously. Our production database amounted to about 1 GB
  of uncompressed text, and if we’d done the conversion a different way
  across networks, we’d still be doing this a week later.


  https://twitter.com/mhadaily/status/806763214092414976

  Successfully migrated from #MySQL 5 to #PostgreSQL 9.5, roughly 16GB data,
  thanks to @tapoueh for a fantastic #pgloader tool


  https://twitter.com/whitequark/status/768208585503354881

  so I need to migrate ~17 million rows from MySQL to Postgres. am I in for
  pain or for a lot of pain?
  
  pgloader appears to be able to do it in ~1 hour, with 512MB of RAM
  (probably faster with more RAM)
  
