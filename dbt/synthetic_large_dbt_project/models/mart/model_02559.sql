{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01824') }},
        {{ ref('model_01979') }}
)
select id, 'model_02559' as name from sources
