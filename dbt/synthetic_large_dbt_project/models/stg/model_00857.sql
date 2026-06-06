{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00658') }},
        {{ ref('model_00281') }},
        {{ ref('model_00433') }}
)
select id, 'model_00857' as name from sources
