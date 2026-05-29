{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01883') }},
        {{ ref('model_01571') }},
        {{ ref('model_01676') }}
)
select id, 'model_02502' as name from sources
