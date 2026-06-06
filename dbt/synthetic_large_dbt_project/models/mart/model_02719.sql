{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01850') }},
        {{ ref('model_02045') }}
)
select id, 'model_02719' as name from sources
