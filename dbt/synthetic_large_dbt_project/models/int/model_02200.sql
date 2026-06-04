{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01150') }},
        {{ ref('model_00948') }},
        {{ ref('model_01370') }}
)
select id, 'model_02200' as name from sources
