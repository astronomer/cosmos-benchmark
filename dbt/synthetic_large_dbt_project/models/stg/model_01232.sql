{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00157') }},
        {{ ref('model_00295') }}
)
select id, 'model_01232' as name from sources
