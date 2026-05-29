{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00784') }},
        {{ ref('model_01410') }}
)
select id, 'model_02072' as name from sources
