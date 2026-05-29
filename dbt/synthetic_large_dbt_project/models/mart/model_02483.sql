{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02219') }},
        {{ ref('model_01752') }}
)
select id, 'model_02483' as name from sources
