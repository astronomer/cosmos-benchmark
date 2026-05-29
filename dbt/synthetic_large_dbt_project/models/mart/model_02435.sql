{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01963') }},
        {{ ref('model_01946') }}
)
select id, 'model_02435' as name from sources
