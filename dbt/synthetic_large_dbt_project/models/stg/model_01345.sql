{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00705') }},
        {{ ref('model_00115') }}
)
select id, 'model_01345' as name from sources
