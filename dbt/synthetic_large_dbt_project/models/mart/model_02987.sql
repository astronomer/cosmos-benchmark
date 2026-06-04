{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01958') }},
        {{ ref('model_01698') }},
        {{ ref('model_01850') }}
)
select id, 'model_02987' as name from sources
