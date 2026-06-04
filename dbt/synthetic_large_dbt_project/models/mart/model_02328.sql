{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01954') }},
        {{ ref('model_01747') }},
        {{ ref('model_01681') }}
)
select id, 'model_02328' as name from sources
