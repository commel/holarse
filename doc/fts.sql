--create sequence revision_seq;

-- fts 
-- create extension unaccent;
-- create extension pg_trgm;
-- 
-- create text search configuration holarse_de ( COPY = german );
-- ALTER TEXT SEARCH CONFIGURATION holarse_de ALTER MAPPING
-- FOR hword, hword_part, word WITH unaccent, german_stem;
-- 
-- -- Materialized View: public.search_index
-- 
-- DROP MATERIALIZED VIEW public.search_index;
-- 
-- CREATE MATERIALIZED VIEW public.search_index AS 
-- SELECT articles.id AS pid,
--     articles.title AS ptitle,
--     'wiki/' || articles.slug AS purl,
--     'news'::text AS pnodetype,    
--     concat_ws(', '::text, articles.alternativetitle1, articles.alternativetitle2, articles.alternativetitle3) AS palternativetitle,
--     string_agg(tags.name, ', ') as ptags,
--     articles.content AS pcontent,
--     (((	setweight(to_tsvector('holarse_de'::regconfig, articles.title::text), 'A'::"char") || 
-- 	setweight(to_tsvector('holarse_de'::regconfig, articles.alternativetitle1::text), 'B'::"char")) || 
-- 	setweight(to_tsvector('holarse_de'::regconfig, articles.alternativetitle2::text), 'B'::"char")) || 
-- 	setweight(to_tsvector('holarse_de'::regconfig, articles.alternativetitle3::text), 'B'::"char")) || 
-- 	setweight(to_tsvector('holarse_de'::regconfig, articles.content::text), 'B'::"char") || 
-- 	setweight(to_tsvector('holarse_de'::regconfig, string_agg(tags.name, ' ')), 'B'::"char") AS document
--    FROM articles
--    left join articles_tags on articles_tags.article_id = articles.id
--    left join tags on articles_tags.tags_id = tags.id
--    group by articles.id
-- UNION
--  SELECT comments.id AS pid,
--     coalesce(a.title, n.title) || ' (Kommentar #' || comments.id || ')' as ptitle,
--     case when a.id is not null then 'wiki/' || a.slug || '#comment-' || comments.id
-- 	 when n.id is not null then 'news/' || n.slug || '#comment-' || comments.id
-- 	 else null
--     end as purl,
--     'comments'::text AS pnodetype,    
--     NULL::character varying AS palternativetitle,
--     NULL::character varying AS ptags,
--     comments.content AS pcontent,
--     setweight(to_tsvector('holarse_de'::regconfig, comments.content::text), 'A'::"char") AS document
--    FROM comments
--    left join articles a on a.id = comments.node_id
--    left join news n on n.id = comments.node_id
-- UNION
--  SELECT news.id AS pid,
--     news.title AS ptitle,
--     'news/' || news.slug AS purl,    
--     'news'::text AS pnodetype,    
--     news.subtitle AS palternativetitle,
--     NULL::character varying AS ptags,    
--     news.content AS pcontent,
--     (setweight(to_tsvector('holarse_de'::regconfig, news.title::text), 'A'::"char") || setweight(to_tsvector('holarse_de'::regconfig, news.subtitle::text), 'B'::"char")) || setweight(to_tsvector('holarse_de'::regconfig, news.content::text), 'B'::"char") AS document
--    FROM news
-- 
-- WITH DATA;
-- 
-- ALTER TABLE public.search_index
--   OWNER TO holarse;

-- Suchindex anlegen:
--drop materialized view mv_searchindex;
create materialized view mv_searchindex as (
    select  
        a.id as pid,
        a.title as ptitle,
        a.slug as purl,
        a.content as content,
        att.attachmentdata as image,
        string_agg(tags.name, ';') as tags,
        setweight(to_tsvector('english', unaccent(a.title)), 'A') || 
        setweight(to_tsvector('english', coalesce(unaccent(a.alternativetitle1), '')), 'C') || 
        setweight(to_tsvector('english', coalesce(unaccent(a.alternativetitle2), '')), 'C') || 
        setweight(to_tsvector('english', coalesce(unaccent(a.alternativetitle3), '')), 'C') ||
        setweight(to_tsvector('german', coalesce(a.content, '')), 'B') ||
        setweight(to_tsvector('simple', string_agg(tags.name, ' ')), 'C')
    as document        
    from public.articles a
    join articles_tags on articles_tags.article_id = a.id
    join tags on tags.id = articles_tags.tags_id
    left join attachments att on att.id = (
        select id from attachments where nodeid = a.id and attachmenttype = 'SCREENSHOT' and attachmentgroup = 'IMAGE' order by id limit 1
    )
    group by a.id, att.attachmentdata
);

create index idx_fts_search on mv_searchindex using gin(document);
create index on mv_searchindex using gin(tags);

-- Abfrage:
select pid, ptitle, purl, content, image from mv_searchindex
where document @@ to_tsquery('german', 'Echtzeit')
ORDER BY ts_rank(document, to_tsquery('german', 'Echtzeit')) DESC;

-- tagbasierte Suche
select * from mv_Searchindex where tags @> array['Spiele'::varchar, 'Horror'::varchar];