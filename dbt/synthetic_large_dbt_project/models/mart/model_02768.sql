{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02011') }},
        {{ ref('model_01629') }},
        {{ ref('model_01537') }}
)
select id, 'model_02768' as name from sources
