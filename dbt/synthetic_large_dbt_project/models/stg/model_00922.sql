{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00393') }},
        {{ ref('model_00428') }},
        {{ ref('model_00623') }}
)
select id, 'model_00922' as name from sources
