{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00447') }},
        {{ ref('model_00654') }},
        {{ ref('model_00498') }}
)
select id, 'model_00810' as name from sources
