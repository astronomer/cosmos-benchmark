{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01733') }},
        {{ ref('model_01941') }}
)
select id, 'model_02898' as name from sources
