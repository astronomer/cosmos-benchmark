{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01696') }},
        {{ ref('model_01922') }},
        {{ ref('model_01690') }}
)
select id, 'model_02480' as name from sources
