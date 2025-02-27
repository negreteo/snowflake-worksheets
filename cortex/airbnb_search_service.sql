-- AIRBNB LISTINGS CORTEX SEARCH APPLICATION

USE WAREHOUSE WH_CORTEX_DEV;
USE DATABASE DEV;
USE SCHEMA AI_POC;

select * from airbnb_listings;

-- List cortex search services
SHOW CORTEX SEARCH SERVICES;

-- Describe cortex service
DESCRIBE CORTEX SEARCH SERVICE AIRBNB_SVC;

-- Create cortex search service
-- The ON parameter specifies the column for queries to search over. In this case, it’s the listing_text, which is generated in the source query as a concatenation of several text columns in the base table.
-- The ATTRIBUTES parameter specifies the columns that you will be able to filter search results on. This example filers on room_type and amenities when issuing queries to the listing_text column.
-- The WAREHOUSE and TARGET_LAG parameters specify the user-provided warehouse and the desired freshness of the search service, respectively. This example specifies to use the cortex_search_tutorial_wh warehouse to create the index and perform refreshes, and to keep the service no more than '1 hour' behind the source table AIRBNB_LISTINGS.
-- The AS field defines the source table for the service. This example concatenates several text columns in the original table into the search column listing_text so that queries can search over multiple fields.

CREATE OR REPLACE CORTEX SEARCH SERVICE airbnb_svc
ON listing_text
ATTRIBUTES room_type, amenities
WAREHOUSE = wh_cortex_dev
TARGET_LAG = '1 hour'
AS
    SELECT
        room_type,
        amenities,
        price,
        cancellation_policy,
        ('Summary\n\n' || summary || '\n\n\nDescription\n\n' || description || '\n\n\nSpace\n\n' || space) as listing_text
    FROM
    airbnb_listings;

ALTER CORTEX SEARCH SERVICE AIRBNB_SVC SUSPEND SERVING;
ALTER CORTEX SEARCH SERVICE AIRBNB_SVC SUSPEND INDEXING;
-- ALTER CORTEX SEARCH SERVICE AIRBNB_SVC RESUME SERVING;
-- ALTER CORTEX SEARCH SERVICE AIRBNB_SVC RESUME INDEXING;

-- Describe cortex service
DESCRIBE CORTEX SEARCH SERVICE AIRBNB_SVC;



