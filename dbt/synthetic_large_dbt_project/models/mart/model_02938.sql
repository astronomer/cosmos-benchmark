{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01625') }},
        {{ ref('model_01741') }},
        {{ ref('model_01922') }}
)
select id, 'model_02938' as name from sources
