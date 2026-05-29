{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02027') }},
        {{ ref('model_01598') }},
        {{ ref('model_02008') }}
)
select id, 'model_02810' as name from sources
