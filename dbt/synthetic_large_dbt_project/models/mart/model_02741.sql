{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01945') }},
        {{ ref('model_02093') }}
)
select id, 'model_02741' as name from sources
