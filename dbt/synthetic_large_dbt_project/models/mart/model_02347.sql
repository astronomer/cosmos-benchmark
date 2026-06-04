{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02184') }}
)
select id, 'model_02347' as name from sources
