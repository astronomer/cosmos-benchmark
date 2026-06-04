{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00633') }},
        {{ ref('model_00652') }},
        {{ ref('model_00311') }}
)
select id, 'model_00911' as name from sources
