{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02117') }},
        {{ ref('model_02245') }}
)
select id, 'model_02618' as name from sources
