{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01594') }},
        {{ ref('model_01861') }}
)
select id, 'model_02845' as name from sources
