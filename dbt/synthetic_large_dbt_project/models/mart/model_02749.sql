{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01522') }},
        {{ ref('model_01898') }},
        {{ ref('model_02085') }}
)
select id, 'model_02749' as name from sources
