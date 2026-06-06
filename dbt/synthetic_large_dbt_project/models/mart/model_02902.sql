{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01918') }},
        {{ ref('model_01623') }},
        {{ ref('model_01787') }}
)
select id, 'model_02902' as name from sources
