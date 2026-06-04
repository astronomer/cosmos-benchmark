{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01308') }},
        {{ ref('model_00856') }},
        {{ ref('model_00789') }}
)
select id, 'model_02243' as name from sources
