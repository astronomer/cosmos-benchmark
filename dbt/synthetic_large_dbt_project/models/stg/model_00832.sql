{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00428') }},
        {{ ref('model_00548') }},
        {{ ref('model_00703') }}
)
select id, 'model_00832' as name from sources
