{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02099') }},
        {{ ref('model_01837') }},
        {{ ref('model_01963') }}
)
select id, 'model_02916' as name from sources
