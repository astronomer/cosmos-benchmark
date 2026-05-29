{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01615') }},
        {{ ref('model_02141') }}
)
select id, 'model_02451' as name from sources
