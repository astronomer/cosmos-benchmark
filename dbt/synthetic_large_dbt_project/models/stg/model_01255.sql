{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00012') }},
        {{ ref('model_00295') }}
)
select id, 'model_01255' as name from sources
