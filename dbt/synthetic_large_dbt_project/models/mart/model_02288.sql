{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02149') }},
        {{ ref('model_01618') }}
)
select id, 'model_02288' as name from sources
