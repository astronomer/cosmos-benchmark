{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01850') }},
        {{ ref('model_01829') }},
        {{ ref('model_01521') }}
)
select id, 'model_02744' as name from sources
