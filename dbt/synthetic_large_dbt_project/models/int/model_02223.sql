{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01393') }},
        {{ ref('model_00764') }}
)
select id, 'model_02223' as name from sources
