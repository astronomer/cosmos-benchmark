{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00133') }},
        {{ ref('model_00242') }},
        {{ ref('model_00298') }}
)
select id, 'model_00781' as name from sources
