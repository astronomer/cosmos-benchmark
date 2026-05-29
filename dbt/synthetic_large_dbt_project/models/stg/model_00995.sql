{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00610') }},
        {{ ref('model_00604') }}
)
select id, 'model_00995' as name from sources
