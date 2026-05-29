{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00758') }},
        {{ ref('model_00908') }},
        {{ ref('model_00857') }}
)
select id, 'model_01929' as name from sources
