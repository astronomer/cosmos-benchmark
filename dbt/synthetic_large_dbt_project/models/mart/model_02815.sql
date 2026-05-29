{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01629') }},
        {{ ref('model_01652') }}
)
select id, 'model_02815' as name from sources
