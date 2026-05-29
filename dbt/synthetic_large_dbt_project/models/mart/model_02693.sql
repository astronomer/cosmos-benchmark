{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01612') }},
        {{ ref('model_02203') }}
)
select id, 'model_02693' as name from sources
