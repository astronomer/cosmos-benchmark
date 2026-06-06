{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00876') }},
        {{ ref('model_00804') }},
        {{ ref('model_01250') }}
)
select id, 'model_02045' as name from sources
