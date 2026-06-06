{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01173') }}
)
select id, 'model_01974' as name from sources
